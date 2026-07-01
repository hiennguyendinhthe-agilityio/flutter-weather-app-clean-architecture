import 'package:dio/dio.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/core/network/connectivity_service.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/core/network/dio_client.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/core/sync/sync_queue_datasource.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/data/datasources/todo_local_datasource.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/data/datasources/todo_remote_datasource.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/data/repositories/todo_repository_impl.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/domain/repositories/todo_repository.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/domain/usecases/add_todo_usecase.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/domain/usecases/delete_todo_usecase.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/domain/usecases/get_paginated_todos_usecase.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/domain/usecases/get_todos_usecase.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/domain/usecases/toggle_todo_usecase.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/domain/usecases/update_todo_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todo_providers.g.dart';

@Riverpod(keepAlive: true)
Dio dio(Ref ref) => DioClient.create(ref);

@Riverpod(keepAlive: true)
ConnectivityService connectivity(Ref ref) => ConnectivityService();

@Riverpod(keepAlive: true)
SyncQueueDatasource syncQueueDatasource(Ref ref) => SyncQueueDatasource();

@Riverpod(keepAlive: true)
TodoRemoteDatasource todoRemoteDatasource(Ref ref) =>
    TodoRemoteDatasource(ref.watch(dioProvider));

@Riverpod(keepAlive: true)
TodoLocalDatasource todoLocalDatasource(Ref ref) => TodoLocalDatasource();

@Riverpod(keepAlive: true)
TodoRepository todoRepository(Ref ref) {
  return TodoRepositoryImpl(
    remote: ref.watch(todoRemoteDatasourceProvider),
    local: ref.watch(todoLocalDatasourceProvider),
    connectivity: ref.watch(connectivityProvider),
    syncQueue: ref.watch(syncQueueDatasourceProvider),
  );
}

@riverpod
GetTodosUseCase getTodosUseCase(Ref ref) {
  return GetTodosUseCase(ref.watch(todoRepositoryProvider));
}

@riverpod
GetPaginatedTodosUseCase getPaginatedTodosUseCase(Ref ref) {
  return GetPaginatedTodosUseCase(ref.watch(todoRepositoryProvider));
}

@riverpod
AddTodoUseCase addTodoUseCase(Ref ref) {
  return AddTodoUseCase(ref.watch(todoRepositoryProvider));
}

@riverpod
ToggleTodoUseCase toggleTodoUseCase(Ref ref) {
  return ToggleTodoUseCase(ref.watch(todoRepositoryProvider));
}

@riverpod
UpdateTodoUseCase updateTodoUseCase(Ref ref) {
  return UpdateTodoUseCase(ref.watch(todoRepositoryProvider));
}

@riverpod
DeleteTodoUseCase deleteTodoUseCase(Ref ref) {
  return DeleteTodoUseCase(ref.watch(todoRepositoryProvider));
}
