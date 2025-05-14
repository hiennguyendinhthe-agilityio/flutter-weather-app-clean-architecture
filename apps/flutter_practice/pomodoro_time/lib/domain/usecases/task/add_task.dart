import 'package:task_management_app/domain/entities/task.dart';
import 'package:task_management_app/domain/repositories/task_repository.dart';

class AddTask {
  final TaskRepository repository;

  AddTask(this.repository);

  Future<void> call(Task task) async {
    await repository.saveTask(task);
  }
}
