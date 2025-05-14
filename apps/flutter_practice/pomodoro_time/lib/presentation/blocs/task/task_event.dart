import 'package:task_management_app/domain/entities/task.dart';

abstract class TaskEvent {}

class LoadTasksEvent extends TaskEvent {}

class AddTaskEvent extends TaskEvent {
  final Task task;
  AddTaskEvent(this.task);

  List<Object?> get props => [task];
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

class ArchiveTaskEvent extends TaskEvent {
  final String taskId;
  ArchiveTaskEvent(this.taskId);
}

class UnarchiveTaskEvent extends TaskEvent {
  final String taskId;
  UnarchiveTaskEvent(this.taskId);
}
