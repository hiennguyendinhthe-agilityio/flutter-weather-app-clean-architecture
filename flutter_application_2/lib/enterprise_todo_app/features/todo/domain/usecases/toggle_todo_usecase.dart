import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

class ToggleTodoUseCase {
  final TodoRepository _repository;
  const ToggleTodoUseCase(this._repository);

  Future<TodoEntity> call(int id) => _repository.toggleTodo(id);
}
