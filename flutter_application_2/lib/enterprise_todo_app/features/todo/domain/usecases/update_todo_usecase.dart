import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

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
