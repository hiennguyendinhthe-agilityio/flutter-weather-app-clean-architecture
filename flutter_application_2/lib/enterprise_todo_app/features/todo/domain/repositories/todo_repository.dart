import '../entities/todo_entity.dart';

abstract interface class TodoRepository {
  Future<List<TodoEntity>> getTodos();

  Future<TodoEntity> getTodoById(int id);

  Future<TodoEntity> addTodo(String title, {String? note});

  Future<TodoEntity> toggleTodo(int id);

  Future<TodoEntity> updateTodo(TodoEntity todo);

  Future<void> deleteTodo(int id);

  Future<List<TodoEntity>> getTodosPaginated({
    required int page,
    required int limit,
  });
}
