import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/domain/entities/task.dart';
import 'package:task_management_app/domain/usecases/task/add_task.dart';
import 'package:task_management_app/domain/usecases/task/delete_task.dart';
import 'package:task_management_app/domain/usecases/task/get_tasks.dart';
import 'package:task_management_app/domain/usecases/task/update_task.dart';
import 'package:task_management_app/presentation/blocs/task/task_event.dart';
import 'package:task_management_app/presentation/blocs/task/task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasks getTasks;
  final AddTask addTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;

  Timer? _masterUpdateTimer;
  final Set<String> _tasksWithActiveTimers = {};

  final Map<String, DateTime> _lastUpdateTimes = {};
  bool _isLoadingFromDB = false;

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
    if (state is! TasksLoaded) {
      emit(TaskLoading());
    }

    _isLoadingFromDB = true;
    try {
      final tasks = await getTasks();

      _tasksWithActiveTimers.clear();
      for (final task in tasks) {
        if (task.isActive && !task.isCompleted && !task.isArchived) {
          _tasksWithActiveTimers.add(task.id);

          _lastUpdateTimes[task.id] = DateTime.now();
        }
      }

      if (_tasksWithActiveTimers.isNotEmpty) {
        _ensureMasterTimerIsRunning();
      }

      emit(TasksLoaded(allTasks: tasks));
    } catch (e) {
      emit(TaskError('Failed to load tasks: $e'));
    } finally {
      _isLoadingFromDB = false;
    }
  }

  Future<void> _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) async {
    try {
      final Task newTask = event.task;

      await addTask(newTask);

      if (state is TasksLoaded) {
        final currentState = state as TasksLoaded;

        final updatedAllTasks = List<Task>.from(currentState.allTasks)
          ..add(newTask);
        emit(TasksLoaded(allTasks: updatedAllTasks));

        if (newTask.isActive) {
          if (!_tasksWithActiveTimers.contains(newTask.id)) {
            _tasksWithActiveTimers.add(newTask.id);
            _lastUpdateTimes[newTask.id] = DateTime.now();
            _ensureMasterTimerIsRunning();
          }
        }
      } else {
        add(LoadTasksEvent());
      }
    } catch (e) {
      emit(TaskError('Failed to add task: $e'));
    }
  }

  Future<void> _onUpdateTask(
      UpdateTaskEvent event, Emitter<TaskState> emit) async {
    try {
      await updateTask(event.task);

      if (state is TasksLoaded) {
        final currentTasks = List<Task>.from((state as TasksLoaded).allTasks);
        final index = currentTasks.indexWhere((t) => t.id == event.task.id);
        if (index != -1) {
          currentTasks[index] = event.task;
          emit(TasksLoaded(allTasks: currentTasks));

          if (event.task.isActive &&
              !event.task.isCompleted &&
              !event.task.isArchived) {
            if (!_tasksWithActiveTimers.contains(event.task.id)) {
              _tasksWithActiveTimers.add(event.task.id);
              _lastUpdateTimes[event.task.id] = DateTime.now();
              _ensureMasterTimerIsRunning();
            }
          } else {
            _tasksWithActiveTimers.remove(event.task.id);
            _lastUpdateTimes.remove(event.task.id);
            _stopMasterTimerIfNoActiveTasks();
          }
        } else {
          add(LoadTasksEvent());
        }
      }
    } catch (e) {
      emit(TaskError('Failed to update task: $e'));
      add(LoadTasksEvent());
    }
  }

  Future<void> _onDeleteTask(
      DeleteTaskEvent event, Emitter<TaskState> emit) async {
    try {
      if (state is TasksLoaded) {
        final currentState = state as TasksLoaded;
        final tasksAfterDeletion = currentState.allTasks
            .where((task) => task.id != event.taskId)
            .toList();
        emit(TasksLoaded(allTasks: tasksAfterDeletion));

        _tasksWithActiveTimers.remove(event.taskId);
        _lastUpdateTimes.remove(event.taskId);
        _stopMasterTimerIfNoActiveTasks();

        await deleteTask(event.taskId);
      } else {
        await deleteTask(event.taskId);
        add(LoadTasksEvent());
      }
    } catch (e) {
      emit(TaskError('Failed to delete task: $e'));

      add(LoadTasksEvent());
    }
  }

  Future<void> _onToggleTaskCompletion(
      ToggleTaskCompletionEvent event, Emitter<TaskState> emit) async {
    if (state is TasksLoaded) {
      final currentState = state as TasksLoaded;
      try {
        final taskToToggle = currentState.allTasks.firstWhere(
            (task) => task.id == event.taskId,
            orElse: () =>
                throw Exception("Task not found for toggle completion"));

        final updatedTask = taskToToggle.copyWith(
          isCompleted: !taskToToggle.isCompleted,
          isActive: taskToToggle.isCompleted ? taskToToggle.isActive : false,
        );

        if (updatedTask.isCompleted &&
            _tasksWithActiveTimers.contains(updatedTask.id)) {
          _tasksWithActiveTimers.remove(updatedTask.id);
          _lastUpdateTimes.remove(updatedTask.id);
          _stopMasterTimerIfNoActiveTasks();
        }

        add(UpdateTaskEvent(updatedTask));
      } catch (e) {
        emit(TaskError('Failed to toggle task completion: $e'));
      }
    } else {
      emit(TaskError('Cannot toggle completion: Tasks not loaded.'));
    }
  }

  Future<void> _onArchiveTask(
      ArchiveTaskEvent event, Emitter<TaskState> emit) async {
    if (state is TasksLoaded) {
      final currentState = state as TasksLoaded;
      try {
        final taskToArchive =
            currentState.allTasks.firstWhere((task) => task.id == event.taskId);
        final updatedTask =
            taskToArchive.copyWith(isArchived: true, isActive: false);

        if (_tasksWithActiveTimers.contains(updatedTask.id)) {
          _tasksWithActiveTimers.remove(updatedTask.id);
          _lastUpdateTimes.remove(updatedTask.id);
          _stopMasterTimerIfNoActiveTasks();
        }
        add(UpdateTaskEvent(updatedTask));
      } catch (e) {
        emit(TaskError('Task not found for archiving: $e'));
      }
    } else {
      emit(TaskError('Cannot archive task: Tasks not loaded.'));
    }
  }

  Future<void> _onUnarchiveTask(
      UnarchiveTaskEvent event, Emitter<TaskState> emit) async {
    if (state is TasksLoaded) {
      final currentState = state as TasksLoaded;
      try {
        final taskToUnarchive =
            currentState.allTasks.firstWhere((task) => task.id == event.taskId);

        final updatedTask = taskToUnarchive.copyWith(isArchived: false);
        add(UpdateTaskEvent(updatedTask));
      } catch (e) {
        emit(TaskError('Task not found for unarchiving: $e'));
      }
    } else {
      emit(TaskError('Cannot unarchive task: Tasks not loaded.'));
    }
  }

  Future<void> _onStartTaskTimer(
      StartTaskTimerEvent event, Emitter<TaskState> emit) async {
    if (state is TasksLoaded) {
      final currentState = state as TasksLoaded;
      try {
        final taskIndex =
            currentState.allTasks.indexWhere((t) => t.id == event.taskId);
        if (taskIndex == -1) {
          emit(TaskError(
              'Task with id ${event.taskId} not found for starting timer'));
          return;
        }
        final task = currentState.allTasks[taskIndex];

        if (task.isCompleted ||
            task.isArchived ||
            _tasksWithActiveTimers.contains(event.taskId)) {
          return;
        }

        final optimisticTaskUpdate = task.copyWith(isActive: true);

        final newAllTasksForUI = List<Task>.from(currentState.allTasks);
        newAllTasksForUI[taskIndex] = optimisticTaskUpdate;

        emit(TasksLoaded(allTasks: newAllTasksForUI));

        _tasksWithActiveTimers.add(event.taskId);
        _lastUpdateTimes[event.taskId] = DateTime.now();
        _ensureMasterTimerIsRunning();

        try {
          await updateTask(optimisticTaskUpdate);
        } catch (dbError) {
          emit(TaskError('Failed to save timer start state to DB: $dbError'));

          _tasksWithActiveTimers.remove(event.taskId);
          _lastUpdateTimes.remove(event.taskId);
          _stopMasterTimerIfNoActiveTasks();

          final revertedTask = task.copyWith(isActive: false);
          final revertedListForUI = List<Task>.from(currentState.allTasks);
          revertedListForUI[taskIndex] = revertedTask;
          emit(TasksLoaded(allTasks: revertedListForUI));
        }
      } catch (e) {
        emit(TaskError('Failed to start task timer (initial find): $e'));
      }
    }
  }

  Future<void> _onStopTaskTimer(
      StopTaskTimerEvent event, Emitter<TaskState> emit) async {
    if (state is TasksLoaded) {
      final currentState = state as TasksLoaded;
      try {
        final taskIndex =
            currentState.allTasks.indexWhere((t) => t.id == event.taskId);
        if (taskIndex == -1) {
          emit(TaskError(
              'Task with id ${event.taskId} not found for stopping timer'));
          return;
        }

        final task = currentState.allTasks[taskIndex];

        final optimisticTaskUpdate = task.copyWith(isActive: false);

        final newAllTasksForUI = List<Task>.from(currentState.allTasks);
        newAllTasksForUI[taskIndex] = optimisticTaskUpdate;

        emit(TasksLoaded(allTasks: newAllTasksForUI));

        _tasksWithActiveTimers.remove(event.taskId);
        _lastUpdateTimes.remove(event.taskId);
        _stopMasterTimerIfNoActiveTasks();

        try {
          await updateTask(optimisticTaskUpdate);
        } catch (dbError) {
          emit(TaskError('Failed to save timer stop state to DB: $dbError'));
        }
      } catch (e) {
        emit(TaskError('Failed to stop task timer (initial find): $e'));
      }
    }
  }

  void _ensureMasterTimerIsRunning() {
    if (_masterUpdateTimer == null || !_masterUpdateTimer!.isActive) {
      _masterUpdateTimer =
          Timer.periodic(const Duration(seconds: 1), _onMasterTimerTick);
    }
  }

  void _stopMasterTimerIfNoActiveTasks() {
    if (_tasksWithActiveTimers.isEmpty && _masterUpdateTimer != null) {
      _masterUpdateTimer?.cancel();
      _masterUpdateTimer = null;
    }
  }

  void _onMasterTimerTick(Timer timer) async {
    if (state is TasksLoaded && _tasksWithActiveTimers.isNotEmpty) {
      final currentState = state as TasksLoaded;
      List<Task> updatedTasks = List<Task>.from(currentState.allTasks);
      bool hasChanges = false;
      bool needsSave = false;
      final now = DateTime.now();

      for (int i = 0; i < updatedTasks.length; i++) {
        final task = updatedTasks[i];
        if (_tasksWithActiveTimers.contains(task.id) &&
            task.isActive &&
            !task.isCompleted &&
            !task.isArchived) {
          updatedTasks[i] = task.copyWith(
            timeSpent: task.timeSpent + const Duration(seconds: 1),
          );
          hasChanges = true;

          final lastUpdate = _lastUpdateTimes[task.id] ?? DateTime.now();
          if (now.difference(lastUpdate).inSeconds >= 15) {
            needsSave = true;
            _lastUpdateTimes[task.id] = now;
          }
        }
      }

      if (hasChanges) {
        if (!_isLoadingFromDB) {
          emit(TasksLoaded(allTasks: updatedTasks));
        }

        if (needsSave && !_isLoadingFromDB) {
          for (final task in updatedTasks) {
            if (_tasksWithActiveTimers.contains(task.id)) {
              try {
                await updateTask(task);
              } catch (e) {
                print('Failed to auto-save task time: $e');
              }
            }
          }
        }
      }
    } else if (_tasksWithActiveTimers.isEmpty) {
      _stopMasterTimerIfNoActiveTasks();
    }
  }

  @override
  Future<void> close() {
    if (state is TasksLoaded && _tasksWithActiveTimers.isNotEmpty) {
      final tasks = (state as TasksLoaded).allTasks;
      for (final task in tasks) {
        if (_tasksWithActiveTimers.contains(task.id)) {
          updateTask(task).catchError((e) {
            print('Failed to save task time during bloc close: $e');
          });
        }
      }
    }

    _masterUpdateTimer?.cancel();
    return super.close();
  }
}
