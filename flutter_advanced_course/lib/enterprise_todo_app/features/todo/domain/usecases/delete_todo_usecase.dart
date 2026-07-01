import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/domain/repositories/todo_repository.dart';

class DeleteTodoUseCase {
  final TodoRepository _repository;
  const DeleteTodoUseCase(this._repository);

  Future<void> call(int id) => _repository.deleteTodo(id);
}
