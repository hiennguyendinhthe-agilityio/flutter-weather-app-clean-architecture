// lib/presentation/blocs/task/task_bloc.dart
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
  }

  Future<void> _onLoadTasks(
      LoadTasksEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = await getTasks();

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));

      final activeTasks = tasks.where((task) => task.isActive).toList();
      final archivedTasks = tasks.where((task) => !task.isActive).toList();

      final todayTasks = tasks.where((task) {
        final taskDate = DateTime(
          task.createdAt.year,
          task.createdAt.month,
          task.createdAt.day,
        );
        return taskDate.isAtSameMomentAs(today);
      }).toList();

      final yesterdayTasks = tasks.where((task) {
        final taskDate = DateTime(
          task.createdAt.year,
          task.createdAt.month,
          task.createdAt.day,
        );
        return taskDate.isAtSameMomentAs(yesterday);
      }).toList();

      emit(TasksLoaded(
        tasks: tasks,
        activeTasks: activeTasks,
        archivedTasks: archivedTasks,
        todayTasks: todayTasks,
        yesterdayTasks: yesterdayTasks,
      ));
    } catch (e) {
      emit(TaskError('Failed to load tasks: $e'));
    }
  }

  Future<void> _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) async {
    try {
      final task = event.task.copyWith(
        id: const Uuid().v4(),
      );

      await addTask(task);
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
    try {
      if (state is TasksLoaded) {
        final currentState = state as TasksLoaded;
        final task =
            currentState.tasks.firstWhere((task) => task.id == event.taskId);

        final updatedTask = task.copyWith(
          isCompleted: !task.isCompleted,
        );

        await updateTask(updatedTask);
        add(LoadTasksEvent());
      }
    } catch (e) {
      emit(TaskError('Failed to toggle task completion: $e'));
    }
  }

  Future<void> _onStartTaskTimer(
      StartTaskTimerEvent event, Emitter<TaskState> emit) async {
    try {
      if (state is TasksLoaded) {
        final currentState = state as TasksLoaded;
        final task =
            currentState.tasks.firstWhere((task) => task.id == event.taskId);

        final updatedTask = task.copyWith(
          isActive: true,
        );

        await updateTask(updatedTask);

        Timer.periodic(const Duration(seconds: 1), (timer) async {
          final currentTasks = await getTasks();
          final currentTask = currentTasks.firstWhere(
            (t) => t.id == event.taskId,
            orElse: () => task,
          );

          if (!currentTask.isActive) {
            timer.cancel();
            return;
          }

          final updatedTask = currentTask.copyWith(
            timeSpent: currentTask.timeSpent + const Duration(seconds: 1),
          );

          await updateTask(updatedTask);
          add(LoadTasksEvent());
        });

        add(LoadTasksEvent());
      }
    } catch (e) {
      emit(TaskError('Failed to start task timer: $e'));
    }
  }

  Future<void> _onStopTaskTimer(
      StopTaskTimerEvent event, Emitter<TaskState> emit) async {
    try {
      if (state is TasksLoaded) {
        final currentState = state as TasksLoaded;
        final task =
            currentState.tasks.firstWhere((task) => task.id == event.taskId);

        final updatedTask = task.copyWith(
          isActive: false,
        );

        await updateTask(updatedTask);
        add(LoadTasksEvent());
      }
    } catch (e) {
      emit(TaskError('Failed to stop task timer: $e'));
    }
  }
}
