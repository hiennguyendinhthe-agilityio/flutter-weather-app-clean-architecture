// lib/presentation/blocs/task/task_state.dart
import 'package:task_management_app/domain/entities/task.dart';

abstract class TaskState {}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TasksLoaded extends TaskState {
  final List<Task> allTasks;

  TasksLoaded({
    required this.allTasks,
  });

  List<Task> get activeTasks =>
      allTasks.where((task) => !task.isCompleted && !task.isArchived).toList();

  List<Task> get archivedTasks =>
      allTasks.where((task) => task.isArchived).toList();

  List<Task> get tasksForActiveTab {
    return allTasks.where((task) => !task.isArchived).toList();
  }

  List<Task> get todayTasksList {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return tasksForActiveTab.where((task) {
      final taskDate = DateTime(
        task.createdAt.year,
        task.createdAt.month,
        task.createdAt.day,
      );
      return taskDate.isAtSameMomentAs(today);
    }).toList();
  }

  List<Task> get yesterdayTasksList {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    return tasksForActiveTab.where((task) {
      final taskDate = DateTime(
          task.createdAt.year, task.createdAt.month, task.createdAt.day);
      return taskDate.isAtSameMomentAs(yesterday);
    }).toList();
  }

  List<Object> get props => [allTasks];
}

class TaskError extends TaskState {
  final String message;
  TaskError(this.message);
}
