import 'package:dio/dio.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/core/error/app_exception.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/core/logger/app_logger.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/core/network/endpoints.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/data/models/todo_model.dart';

class TodoRemoteDatasource {
  final Dio _dio;

  const TodoRemoteDatasource(this._dio);

  Future<List<TodoModel>> getTodos() async {
    try {
      AppLogger.debug('Remote: fetching todos...');
      final response = await _dio.get(
        ApiEndpoints.todos,
        queryParameters: {'_limit': 20},
      );

      final list = response.data as List<dynamic>;
      final todos = list
          .map((item) => TodoModel.fromJson(item as Map<String, dynamic>))
          .toList();

      AppLogger.info('Remote: fetched ${todos.length} todos');
      return todos;
    } on DioException catch (e) {
      final appException = e.error;
      if (appException is AppException) throw appException;
      throw NetworkException(originalError: e);
    }
  }

  Future<TodoModel> getTodoById(int id) async {
    try {
      final response = await _dio.get(ApiEndpoints.todoById(id));
      return TodoModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final appException = e.error;
      if (appException is AppException) throw appException;
      throw NetworkException(originalError: e);
    }
  }

  Future<List<TodoModel>> getTodosPaginated({
    required int page,
    required int limit,
  }) async {
    try {
      AppLogger.debug(
        'Remote: fetching todos paginated (page: $page, limit: $limit)',
      );
      final response = await _dio.get(
        ApiEndpoints.todos,
        queryParameters: {'_page': page, '_limit': limit},
      );

      final list = response.data as List<dynamic>;
      final todos = list
          .map((item) => TodoModel.fromJson(item as Map<String, dynamic>))
          .toList();

      AppLogger.info('Remote: fetched ${todos.length} todos paginated');
      return todos;
    } on DioException catch (e) {
      final appException = e.error;
      if (appException is AppException) throw appException;
      throw NetworkException(originalError: e);
    }
  }

  Future<TodoModel> createTodo(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(ApiEndpoints.todos, data: data);
      return TodoModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final appException = e.error;
      if (appException is AppException) throw appException;
      throw NetworkException(originalError: e);
    }
  }

  Future<TodoModel> updateTodo(int id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(ApiEndpoints.todoById(id), data: data);
      return TodoModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final appException = e.error;
      if (appException is AppException) throw appException;
      throw NetworkException(originalError: e);
    }
  }

  Future<void> deleteTodo(int id) async {
    try {
      await _dio.delete(ApiEndpoints.todoById(id));
    } on DioException catch (e) {
      final appException = e.error;
      if (appException is AppException) throw appException;
      throw NetworkException(originalError: e);
    }
  }
}
