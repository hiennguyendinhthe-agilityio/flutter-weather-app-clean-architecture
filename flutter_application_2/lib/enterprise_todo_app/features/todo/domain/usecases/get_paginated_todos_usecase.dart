import 'package:flutter_application_2/enterprise_todo_app/features/todo/domain/entities/todo_entity.dart';
import 'package:flutter_application_2/enterprise_todo_app/features/todo/domain/repositories/todo_repository.dart';

class GetPaginatedTodosUsecase {
  final TodoRepository _repository;

  GetPaginatedTodosUsecase(this._repository);

  Future<List<TodoEntity>> call({required int page, required int limit}) async {
    return await _repository.getTodosPaginated(page: page, limit: limit);
  }
}
