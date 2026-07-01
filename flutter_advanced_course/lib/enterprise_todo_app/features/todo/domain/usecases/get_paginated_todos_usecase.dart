import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/domain/entities/todo_entity.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/domain/repositories/todo_repository.dart';

class GetPaginatedTodosUseCase {
  final TodoRepository _repository;

  GetPaginatedTodosUseCase(this._repository);

  Future<List<TodoEntity>> call({required int page, required int limit}) async {
    return await _repository.getTodosPaginated(page: page, limit: limit);
  }
}
