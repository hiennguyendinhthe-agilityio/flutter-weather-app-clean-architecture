import 'package:dio/dio.dart';
import 'package:flutter_application_2/enterprise_todo_app/core/sync/sync_queue_datasource.dart';
import 'package:flutter_application_2/enterprise_todo_app/features/todo/domain/usecases/get_paginated_todos_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/connectivity_service.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/todo_local_datasource.dart';
import '../../data/datasources/todo_remote_datasource.dart';
import '../../data/repositories/todo_repository_impl.dart';
import '../../domain/repositories/todo_repository.dart';
import '../../domain/usecases/add_todo_usecase.dart';
import '../../domain/usecases/delete_todo_usecase.dart';
import '../../domain/usecases/get_todos_usecase.dart';
import '../../domain/usecases/toggle_todo_usecase.dart';
import '../../domain/usecases/update_todo_usecase.dart';

final dioProvider = Provider<Dio>((ref) {
  return DioClient.create(ref);
});

final connectivityProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});

final syncQueueDatasourceProvider = Provider<SyncQueueDatasource>((ref) {
  return SyncQueueDatasource();
});

final todoRemoteDatasourceProvider = Provider<TodoRemoteDatasource>((ref) {
  final dio = ref.watch(dioProvider);
  return TodoRemoteDatasource(dio);
});

final todoLocalDatasourceProvider = Provider<TodoLocalDatasource>((ref) {
  return TodoLocalDatasource();
});

final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  return TodoRepositoryImpl(
    remote: ref.watch(todoRemoteDatasourceProvider),
    local: ref.watch(todoLocalDatasourceProvider),
    connectivity: ref.watch(connectivityProvider),
    syncQueue: ref.watch(syncQueueDatasourceProvider),
  );
});

final getTodosUseCaseProvider = Provider<GetTodosUseCase>((ref) {
  return GetTodosUseCase(ref.watch(todoRepositoryProvider));
});

final getPaginatedTodosUseCaseProvider = Provider<GetPaginatedTodosUsecase>((
  ref,
) {
  return GetPaginatedTodosUsecase(ref.watch(todoRepositoryProvider));
});

final addTodoUseCaseProvider = Provider<AddTodoUseCase>((ref) {
  return AddTodoUseCase(ref.watch(todoRepositoryProvider));
});

final toggleTodoUseCaseProvider = Provider<ToggleTodoUseCase>((ref) {
  return ToggleTodoUseCase(ref.watch(todoRepositoryProvider));
});

final updateTodoUseCaseProvider = Provider<UpdateTodoUseCase>((ref) {
  return UpdateTodoUseCase(ref.watch(todoRepositoryProvider));
});

final deleteTodoUseCaseProvider = Provider<DeleteTodoUseCase>((ref) {
  return DeleteTodoUseCase(ref.watch(todoRepositoryProvider));
});
