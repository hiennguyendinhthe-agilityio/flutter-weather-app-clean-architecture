import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/domain/entities/todo_entity.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/domain/repositories/todo_repository.dart';

class GetTodosUseCase {
  final TodoRepository _repository;

  const GetTodosUseCase(this._repository);

  Future<List<TodoEntity>> call() async {
    final todos = await _repository.getTodos();

    todos.sort((a, b) => b.priority.order.compareTo(a.priority.order));

    return todos;
  }
}
