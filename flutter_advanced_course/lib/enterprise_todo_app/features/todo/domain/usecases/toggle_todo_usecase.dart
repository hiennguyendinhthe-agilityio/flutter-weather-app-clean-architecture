import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/domain/entities/todo_entity.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/domain/repositories/todo_repository.dart';

class ToggleTodoUseCase {
  final TodoRepository _repository;
  const ToggleTodoUseCase(this._repository);

  Future<TodoEntity> call(int id) => _repository.toggleTodo(id);
}
