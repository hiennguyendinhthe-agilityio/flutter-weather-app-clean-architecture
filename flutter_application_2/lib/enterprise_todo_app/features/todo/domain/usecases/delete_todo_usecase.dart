import '../repositories/todo_repository.dart';

class DeleteTodoUseCase {
  final TodoRepository _repository;
  const DeleteTodoUseCase(this._repository);

  Future<void> call(int id) => _repository.deleteTodo(id);
}
