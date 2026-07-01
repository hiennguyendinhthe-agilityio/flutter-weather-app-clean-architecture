import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/domain/entities/todo_entity.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/domain/repositories/todo_repository.dart';

class AddTodoUseCase {
  final TodoRepository _repository;
  const AddTodoUseCase(this._repository);

  Future<TodoEntity> call(String title, {String? note}) async {
    final trimmed = title.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('Title cannot be empty');
    }
    if (trimmed.length > 200) {
      throw ArgumentError('Title cannot be longer than 200 characters');
    }

    return _repository.addTodo(trimmed, note: note?.trim());
  }
}
