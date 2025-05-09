// lib/domain/usecases/task/delete_task.dart
import 'package:task_management_app/domain/repositories/task_repository.dart';

class DeleteTask {
  final TaskRepository repository;

  DeleteTask(this.repository);

  Future<void> call(String id) async {
    await repository.deleteTask(id);
  }
}
