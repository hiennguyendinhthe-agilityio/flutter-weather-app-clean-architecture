import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/domain/entities/todo_entity.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/domain/repositories/todo_repository.dart';

class UpdateTodoUseCase {
  final TodoRepository _repository;
  const UpdateTodoUseCase(this._repository);

  Future<TodoEntity> call(TodoEntity todo) async {
    final trimmed = todo.title.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('Title cannot be empty');
    }
    return _repository.updateTodo(todo.copyWith(title: trimmed));
  }
}
