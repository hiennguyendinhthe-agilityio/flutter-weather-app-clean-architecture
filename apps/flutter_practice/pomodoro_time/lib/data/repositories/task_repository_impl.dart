import 'package:task_management_app/data/datasources/local_data_source.dart';
import 'package:task_management_app/data/models/task_model.dart';
import 'package:task_management_app/domain/entities/task.dart';
import 'package:task_management_app/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final LocalDataSource localDataSource;

  TaskRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Task>> getTasks() async {
    final taskModels = await localDataSource.getTasks();
    return taskModels;
  }

  @override
  Future<void> saveTask(Task task) async {
    final taskModel = TaskModel.fromEntity(task);
    await localDataSource.saveTask(taskModel);
  }

  @override
  Future<void> updateTask(Task task) async {
    final taskModel = TaskModel.fromEntity(task);
    await localDataSource.updateTask(taskModel);
  }

  @override
  Future<void> deleteTask(String id) async {
    await localDataSource.deleteTask(id);
  }
}
