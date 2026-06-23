import '../../../../core/error/app_exception.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/logger/app_logger.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../domain/entities/todo_entity.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_local_datasource.dart';
import '../datasources/todo_remote_datasource.dart';
import '../models/todo_model.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDatasource _remote;
  final TodoLocalDatasource _local;
  final ConnectivityService _connectivity;

  const TodoRepositoryImpl({
    required TodoRemoteDatasource remote,
    required TodoLocalDatasource local,
    required ConnectivityService connectivity,
  }) : _remote = remote,
       _local = local,
       _connectivity = connectivity;

  @override
  Future<List<TodoEntity>> getTodos() async {
    try {
      final isOnline = await _connectivity.isConnected;

      if (isOnline) {
        AppLogger.info('Repo: online → fetch from API');
        final remoteTodos = await _remote.getTodos();

        await _local.saveAll(remoteTodos);
        return remoteTodos;
      } else {
        AppLogger.warning('Repo: offline → load from cache');
        final cached = await _local.getAll();
        if (cached.isEmpty) {
          throw const NetworkFailure(
            message: 'No internet connection and no cached todos',
          );
        }
        return cached;
      }
    } on Failure {
      rethrow;
    } on AppException catch (e) {
      throw _mapException(e);
    } catch (e, st) {
      AppLogger.error('Repo: unexpected error in getTodos', e, st);
      throw const UnknownFailure();
    }
  }

  @override
  Future<TodoEntity> getTodoById(int id) async {
    try {
      final local = await _local.getAll();
      final cached = local.where((t) => t.id == id).firstOrNull;
      if (cached != null) return cached;

      return await _remote.getTodoById(id);
    } on AppException catch (e) {
      throw _mapException(e);
    }
  }

  @override
  Future<TodoEntity> addTodo(String title, {String? note}) async {
    try {
      final created = await _remote.createTodo({
        'title': title,
        'completed': false,
        'userId': 1,
      });

      final enriched = created.copyWith(note: note);
      await _local.save(enriched);
      return enriched;
    } on AppException catch (e) {
      throw _mapException(e);
    }
  }

  @override
  Future<TodoEntity> toggleTodo(int id) async {
    try {
      final todos = await _local.getAll();
      final current = todos.where((t) => t.id == id).firstOrNull;
      if (current == null) {
        throw NotFoundException(message: 'Todo #$id not found.');
      }

      final toggled = current.copyWith(isCompleted: !current.isCompleted);

      await _local.save(toggled);

      _remote.updateTodo(id, toggled.toJson()).catchError((e) {
        AppLogger.warning('Sync toggle failed: $e');
        throw e;
      });

      return toggled;
    } on AppException catch (e) {
      throw _mapException(e);
    }
  }

  @override
  Future<TodoEntity> updateTodo(TodoEntity todo) async {
    try {
      final model = TodoModel.fromEntity(todo);

      await _local.save(model);

      _remote.updateTodo(todo.id, model.toJson()).catchError((e) {
        AppLogger.warning('Sync update failed: $e');
        throw e;
      });

      return model;
    } on AppException catch (e) {
      throw _mapException(e);
    }
  }

  @override
  Future<void> deleteTodo(int id) async {
    try {
      await _local.delete(id);

      _remote.deleteTodo(id).catchError((e) {
        AppLogger.warning('Sync delete failed: $e');
      });
    } on AppException catch (e) {
      throw _mapException(e);
    }
  }

  Failure _mapException(AppException e) {
    return switch (e) {
      NetworkException() => const NetworkFailure(),
      UnauthorizedException() => const AuthFailure(),
      NotFoundException(:final message) => NotFoundFailure(message: message),
      ServerException(:final message) => ServerFailure(message: message),
      CacheException() => const CacheFailure(),
      _ => const UnknownFailure(),
    };
  }

  @override
  Future<List<TodoEntity>> getTodosPaginated({
    required int page,
    required int limit,
  }) async {
    try {
      final isOnline = await _connectivity.isConnected;

      if (isOnline) {
        AppLogger.info(
          'Repo: online -> fetch paginated from API (page: $page, limit: $limit)',
        );
        final remoteTodos = await _remote.getTodosPaginated(
          page: page,
          limit: limit,
        );

        await _local.saveAll(remoteTodos);
        return remoteTodos;
      } else {
        AppLogger.warning('Repo: offline -> load paginated from cache');
        final cached = await _local.getAll();

        final startIndex = (page - 1) * limit;
        if (startIndex >= cached.length) return [];
        final endIndex = (startIndex + limit) > cached.length
            ? cached.length
            : (startIndex + limit);
        return cached.sublist(startIndex, endIndex);
      }
    } on Failure {
      rethrow;
    } on AppException catch (e) {
      throw _mapException(e);
    } catch (e, st) {
      AppLogger.error('Repo: unexpected error in getTodosPaginated', e, st);
      throw const UnknownFailure();
    }
  }
}
