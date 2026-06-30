import 'package:flutter_application_2/enterprise_todo_app/features/todo/domain/repositories/todo_repository.dart';

class DeleteTodoUseCase {
  final TodoRepository _repository;
  const DeleteTodoUseCase(this._repository);

  Future<void> call(int id) => _repository.deleteTodo(id);
}
