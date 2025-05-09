// lib/presentation/blocs/task/task_event.dart
import 'package:task_management_app/domain/entities/task.dart';

abstract class TaskEvent {}

class LoadTasksEvent extends TaskEvent {}

class AddTaskEvent extends TaskEvent {
  final Task task;
  AddTaskEvent(this.task);
}

class UpdateTaskEvent extends TaskEvent {
  final Task task;
  UpdateTaskEvent(this.task);
}

class DeleteTaskEvent extends TaskEvent {
  final String taskId;
  DeleteTaskEvent(this.taskId);
}

class ToggleTaskCompletionEvent extends TaskEvent {
  final String taskId;
  ToggleTaskCompletionEvent(this.taskId);
}

class StartTaskTimerEvent extends TaskEvent {
  final String taskId;
  StartTaskTimerEvent(this.taskId);
}

class StopTaskTimerEvent extends TaskEvent {
  final String taskId;
  StopTaskTimerEvent(this.taskId);
}
