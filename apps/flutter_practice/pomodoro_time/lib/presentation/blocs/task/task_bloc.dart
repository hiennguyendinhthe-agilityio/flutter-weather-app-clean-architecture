import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/domain/usecases/task/add_task.dart';
import 'package:task_management_app/domain/usecases/task/delete_task.dart';
import 'package:task_management_app/domain/usecases/task/get_tasks.dart';
import 'package:task_management_app/domain/usecases/task/update_task.dart';
import 'package:task_management_app/presentation/blocs/task/task_event.dart';
import 'package:task_management_app/presentation/blocs/task/task_state.dart';
import 'package:uuid/uuid.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasks getTasks;
  final AddTask addTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;

  TaskBloc({
    required this.getTasks,
    required this.addTask,
    required this.updateTask,
    required this.deleteTask,
  }) : super(TaskInitial()) {
    on<LoadTasksEvent>(_onLoadTasks);
    on<AddTaskEvent>(_onAddTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<ToggleTaskCompletionEvent>(_onToggleTaskCompletion);
    on<StartTaskTimerEvent>(_onStartTaskTimer);
    on<StopTaskTimerEvent>(_onStopTaskTimer);
    on<ArchiveTaskEvent>(_onArchiveTask);
    on<UnarchiveTaskEvent>(_onUnarchiveTask);
  }

  Future<void> _onLoadTasks(
      LoadTasksEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = await getTasks();

      emit(TasksLoaded(allTasks: tasks));
    } catch (e) {
      emit(TaskError('Failed to load tasks: $e'));
    }
  }

  Future<void> _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) async {
    try {
      final taskWithId = event.task.copyWith(
          id: const Uuid().v4(),
          createdAt: DateTime.now(),
          isActive: true,
          isCompleted: false,
          isArchived: false,
          timeSpent: Duration.zero);
      await addTask(taskWithId);

      add(LoadTasksEvent());
    } catch (e) {
      emit(TaskError('Failed to add task: $e'));
    }
  }

  Future<void> _onUpdateTask(
      UpdateTaskEvent event, Emitter<TaskState> emit) async {
    try {
      await updateTask(event.task);
      add(LoadTasksEvent());
    } catch (e) {
      emit(TaskError('Failed to update task: $e'));
    }
  }

  Future<void> _onDeleteTask(
      DeleteTaskEvent event, Emitter<TaskState> emit) async {
    try {
      await deleteTask(event.taskId);
      add(LoadTasksEvent());
    } catch (e) {
      emit(TaskError('Failed to delete task: $e'));
    }
  }

  Future<void> _onToggleTaskCompletion(
      ToggleTaskCompletionEvent event, Emitter<TaskState> emit) async {
    if (state is TasksLoaded) {
      final currentState = state as TasksLoaded;

      final taskToToggle = currentState.allTasks.firstWhere(
          (task) => task.id == event.taskId,
          orElse: () =>
              throw Exception("Task not found for toggle completion"));

      final updatedTask = taskToToggle.copyWith(
        isCompleted: !taskToToggle.isCompleted,
      );

      add(UpdateTaskEvent(updatedTask));
    } else {
      emit(TaskError('Cannot toggle completion: Tasks not loaded.'));
    }
  }

  Future<void> _onArchiveTask(
      ArchiveTaskEvent event, Emitter<TaskState> emit) async {
    if (state is TasksLoaded) {
      final currentState = state as TasksLoaded;
      final taskToArchive = currentState.allTasks.firstWhere(
          (task) => task.id == event.taskId,
          orElse: () => throw Exception("Task not found for archiving"));

      final updatedTask =
          taskToArchive.copyWith(isArchived: true, isActive: false);
      add(UpdateTaskEvent(updatedTask));
    } else {
      emit(TaskError('Cannot archive task: Tasks not loaded.'));
    }
  }

  Future<void> _onUnarchiveTask(
      UnarchiveTaskEvent event, Emitter<TaskState> emit) async {
    if (state is TasksLoaded) {
      final currentState = state as TasksLoaded;
      final taskToUnarchive = currentState.allTasks.firstWhere(
          (task) => task.id == event.taskId,
          orElse: () => throw Exception("Task not found for unarchiving"));

      final updatedTask =
          taskToUnarchive.copyWith(isArchived: false, isActive: true);
      add(UpdateTaskEvent(updatedTask));
    } else {
      emit(TaskError('Cannot unarchive task: Tasks not loaded.'));
    }
  }

  final Map<String, Timer> _activeTimers = {};

  Future<void> _onStartTaskTimer(
      StartTaskTimerEvent event, Emitter<TaskState> emit) async {
    if (state is TasksLoaded) {
      final currentState = state as TasksLoaded;
      final task = currentState.allTasks.firstWhere((t) => t.id == event.taskId,
          orElse: () => throw Exception("Task not found for starting timer"));

      if (_activeTimers.containsKey(event.taskId)) {
        return;
      }

      final initialUpdate = task.copyWith(isActive: true);
      await updateTask(initialUpdate);

      add(LoadTasksEvent());

      _activeTimers[event.taskId] =
          Timer.periodic(const Duration(seconds: 1), (timer) async {
        if (state is TasksLoaded) {
          final latestState = state as TasksLoaded;
          try {
            final currentTask =
                latestState.allTasks.firstWhere((t) => t.id == event.taskId);

            if (!currentTask.isActive ||
                currentTask.isArchived ||
                currentTask.isCompleted) {
              timer.cancel();
              _activeTimers.remove(event.taskId);

              if (currentTask.isActive) {
                add(UpdateTaskEvent(currentTask.copyWith(isActive: false)));
              }
              return;
            }

            final updatedTask = currentTask.copyWith(
              timeSpent: currentTask.timeSpent + const Duration(seconds: 1),
            );

            await updateTask(updatedTask);

            if (state is TasksLoaded) {
              final reloadedTasks = await getTasks();
              emit(TasksLoaded(allTasks: reloadedTasks));
            }
          } catch (e) {
            timer.cancel();
            _activeTimers.remove(event.taskId);
          }
        } else {
          timer.cancel();
          _activeTimers.remove(event.taskId);
        }
      });
    }
  }

  Future<void> _onStopTaskTimer(
      StopTaskTimerEvent event, Emitter<TaskState> emit) async {
    _activeTimers[event.taskId]?.cancel();
    _activeTimers.remove(event.taskId);

    if (state is TasksLoaded) {
      final currentState = state as TasksLoaded;
      try {
        final task =
            currentState.allTasks.firstWhere((t) => t.id == event.taskId);
        final updatedTask = task.copyWith(isActive: false);

        add(UpdateTaskEvent(updatedTask));
      } catch (e) {
        emit(TaskError('Failed to stop task timer: $e'));
      }
    }
  }

  @override
  Future<void> close() {
    _activeTimers.forEach((key, timer) => timer.cancel());
    return super.close();
  }
}
