import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

class GetTodosUseCase {
  final TodoRepository _repository;

  const GetTodosUseCase(this._repository);

  Future<List<TodoEntity>> call() async {
    final todos = await _repository.getTodos();

    todos.sort((a, b) => b.priority.order.compareTo(a.priority.order));

    return todos;
  }
}
