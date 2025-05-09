// lib/presentation/blocs/task/task_state.dart
import 'package:task_management_app/domain/entities/task.dart';

abstract class TaskState {}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TasksLoaded extends TaskState {
  final List<Task> tasks;
  final List<Task> activeTasks;
  final List<Task> archivedTasks;
  final List<Task> todayTasks;
  final List<Task> yesterdayTasks;

  TasksLoaded({
    required this.tasks,
    required this.activeTasks,
    required this.archivedTasks,
    required this.todayTasks,
    required this.yesterdayTasks,
  });
}

class TaskError extends TaskState {
  final String message;
  TaskError(this.message);
}
