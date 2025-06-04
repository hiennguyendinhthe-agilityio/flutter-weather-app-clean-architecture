import 'dart:async';

import 'package:flutter/material.dart';
import 'package:task_management_app/data/datasources/local_data_source.dart';
import 'package:task_management_app/data/models/task.dart';

class TaskProvider extends ChangeNotifier {
  final LocalDataSourceImpl localDataSource;

  Timer? _masterUpdateTimer;
  final Set<String> _tasksWithActiveTimers = {};

  final Map<String, DateTime> _lastUpdateTimes = {};
  bool _isLoadingFromDB = false;
  bool _isLoading = false;
  String? _errorMessage;

  String? _selectedTaskId;
  String? get selectedTaskId => _selectedTaskId;

  void setSelectedTask(String? taskId) {
    _selectedTaskId = taskId;
    notifyListeners();
  }

  Task? get selectedTask => _allTasks.firstWhere(
        (task) => task.id == _selectedTaskId,
        orElse: () => Task(
          projectColor: '',
          projectName: '',
          id: '',
          title: '',
          startTime: DateTime.now(),
          endTime: DateTime.now(),
          isActive: false,
          isCompleted: false,
          isArchived: false,
          timeSpent: Duration.zero,
          createdAt: DateTime.now(),
          assignee: '',
          tags: [],
        ),
      );
  Task? get runningTask => _allTasks.firstWhere(
        (t) => t.isActive && !t.isCompleted && !t.isArchived,
        orElse: () => Task(
          projectColor: '',
          projectName: '',
          id: '',
          title: '',
          startTime: DateTime.now(),
          endTime: DateTime.now(),
          isActive: false,
          isCompleted: false,
          isArchived: false,
          timeSpent: Duration.zero,
          createdAt: DateTime.now(),
          assignee: '',
          tags: [],
        ),
      );
  List<Task> _allTasks = [];
  List<Task> get allTasks => _allTasks;

  List<Task> get archivedTasks =>
      _allTasks.where((task) => task.isArchived).toList();

  List<Task> get activeTasks =>
      _allTasks.where((task) => !task.isArchived && !task.isCompleted).toList();

  List<Task> get tasksForActiveTab =>
      _allTasks.where((task) => !task.isArchived).toList();

  List<Task> get todayTasksList {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return tasksForActiveTab.where((task) {
      final taskDay = DateTime(
          task.createdAt.year, task.createdAt.month, task.createdAt.day);
      return taskDay.isAtSameMomentAs(today);
    }).toList();
  }

  List<Task> get yesterdayTasksList {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    return tasksForActiveTab.where((task) {
      final taskDay = DateTime(
          task.createdAt.year, task.createdAt.month, task.createdAt.day);
      return taskDay.isAtSameMomentAs(yesterday);
    }).toList();
  }

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  TaskProvider({required this.localDataSource});

  Future<void> loadTasks() async {
    _isLoading = true;
    _errorMessage = null;
    _isLoadingFromDB = true;
    notifyListeners();

    try {
      final tasks = await localDataSource.getTasks();
      _allTasks = tasks;

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

      _isLoading = false;
      _errorMessage = null;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load tasks: $e';
    } finally {
      _isLoadingFromDB = false;
      notifyListeners();
    }
  }

  Future<void> addTask(Task task) async {
    if (task.endTime.isBefore(task.startTime)) {
      _errorMessage = 'End time cannot be before start time.';
      notifyListeners();
      return;
    }

    try {
      await localDataSource.saveTask(task);

      _allTasks.add(task);
      notifyListeners();

      if (task.isActive) {
        if (!_tasksWithActiveTimers.contains(task.id)) {
          _tasksWithActiveTimers.add(task.id);
          _lastUpdateTimes[task.id] = DateTime.now();
          _ensureMasterTimerIsRunning();
        }
      }
    } catch (e) {
      _errorMessage = 'Failed to add task: $e';
      notifyListeners();
    }
  }

  Future<void> updateTask(Task task) async {
    if (task.endTime.isBefore(task.startTime)) {
      _errorMessage = 'End time cannot be before start time.';
      notifyListeners();
      return;
    }

    try {
      await localDataSource.updateTask(task);

      final index = _allTasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _allTasks[index] = task;
        notifyListeners();

        if (task.isActive && !task.isCompleted && !task.isArchived) {
          if (!_tasksWithActiveTimers.contains(task.id)) {
            _tasksWithActiveTimers.add(task.id);
            _lastUpdateTimes[task.id] = DateTime.now();
            _ensureMasterTimerIsRunning();
          }
        } else {
          _tasksWithActiveTimers.remove(task.id);
          _lastUpdateTimes.remove(task.id);
          _stopMasterTimerIfNoActiveTasks();
        }
      } else {
        await loadTasks();
      }
    } catch (e) {
      _errorMessage = 'Failed to update task: $e';
      notifyListeners();
      await loadTasks();
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      _allTasks.removeWhere((task) => task.id == taskId);
      notifyListeners();

      _tasksWithActiveTimers.remove(taskId);
      _lastUpdateTimes.remove(taskId);
      _stopMasterTimerIfNoActiveTasks();

      await localDataSource.deleteTask(taskId);
    } catch (e) {
      _errorMessage = 'Failed to delete task: $e';
      notifyListeners();
      await loadTasks();
    }
  }

  Future<void> toggleTaskCompletion(String taskId) async {
    try {
      final taskIndex = _allTasks.indexWhere((task) => task.id == taskId);
      if (taskIndex == -1) {
        throw Exception("Task not found for toggle completion");
      }

      final taskToToggle = _allTasks[taskIndex];
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

      await updateTask(updatedTask);
    } catch (e) {
      _errorMessage = 'Failed to toggle task completion: $e';
      notifyListeners();
    }
  }

  Future<void> archiveTask(String taskId) async {
    try {
      final taskIndex = _allTasks.indexWhere((task) => task.id == taskId);
      if (taskIndex == -1) {
        throw Exception("Task not found for archiving");
      }

      final taskToArchive = _allTasks[taskIndex];
      final updatedTask = taskToArchive.copyWith(
        isArchived: true,
        isActive: false,
      );

      if (_tasksWithActiveTimers.contains(updatedTask.id)) {
        _tasksWithActiveTimers.remove(updatedTask.id);
        _lastUpdateTimes.remove(updatedTask.id);
        _stopMasterTimerIfNoActiveTasks();
      }

      await updateTask(updatedTask);
    } catch (e) {
      _errorMessage = 'Failed to archive task: $e';
      notifyListeners();
    }
  }

  Future<void> unarchiveTask(String taskId) async {
    try {
      final taskIndex = _allTasks.indexWhere((task) => task.id == taskId);
      if (taskIndex == -1) {
        throw Exception("Task not found for unarchiving");
      }

      final taskToUnarchive = _allTasks[taskIndex];
      final updatedTask = taskToUnarchive.copyWith(isArchived: false);

      await updateTask(updatedTask);
    } catch (e) {
      _errorMessage = 'Failed to unarchive task: $e';
      notifyListeners();
    }
  }

  Future<void> startTaskTimer(String taskId) async {
    try {
      final taskIndex = _allTasks.indexWhere((t) => t.id == taskId);
      if (taskIndex == -1) {
        throw Exception('Task with id $taskId not found for starting timer');
      }

      final task = _allTasks[taskIndex];

      if (task.isCompleted ||
          task.isArchived ||
          _tasksWithActiveTimers.contains(taskId)) {
        return;
      }

      final optimisticTaskUpdate = task.copyWith(isActive: true);
      _allTasks[taskIndex] = optimisticTaskUpdate;
      notifyListeners();

      _tasksWithActiveTimers.add(taskId);
      _lastUpdateTimes[taskId] = DateTime.now();
      _ensureMasterTimerIsRunning();

      try {
        await localDataSource.updateTask(optimisticTaskUpdate);
      } catch (dbError) {
        _errorMessage = 'Failed to save timer start state to DB: $dbError';

        _tasksWithActiveTimers.remove(taskId);
        _lastUpdateTimes.remove(taskId);
        _stopMasterTimerIfNoActiveTasks();

        _allTasks[taskIndex] = task;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to start task timer: $e';
      notifyListeners();
    }
  }

  Future<void> stopTaskTimer(String taskId) async {
    try {
      final taskIndex = _allTasks.indexWhere((t) => t.id == taskId);
      if (taskIndex == -1) {
        throw Exception('Task with id $taskId not found for stopping timer');
      }

      final task = _allTasks[taskIndex];
      final optimisticTaskUpdate = task.copyWith(isActive: false);

      _allTasks[taskIndex] = optimisticTaskUpdate;
      notifyListeners();

      _tasksWithActiveTimers.remove(taskId);
      _lastUpdateTimes.remove(taskId);
      _stopMasterTimerIfNoActiveTasks();

      try {
        await localDataSource.updateTask(optimisticTaskUpdate);
      } catch (dbError) {
        _errorMessage = 'Failed to save timer stop state to DB: $dbError';
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to stop task timer: $e';
      notifyListeners();
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
    if (_tasksWithActiveTimers.isNotEmpty) {
      bool hasChanges = false;
      bool needsSave = false;
      final now = DateTime.now();

      for (int i = 0; i < _allTasks.length; i++) {
        final task = _allTasks[i];
        if (_tasksWithActiveTimers.contains(task.id) &&
            task.isActive &&
            !task.isCompleted &&
            !task.isArchived) {
          _allTasks[i] = task.copyWith(
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

      if (hasChanges && !_isLoadingFromDB) {
        notifyListeners();

        if (needsSave && !_isLoadingFromDB) {
          for (final task in _allTasks) {
            if (_tasksWithActiveTimers.contains(task.id)) {
              try {
                await localDataSource.updateTask(task);
              } catch (e) {
                debugPrint('Failed to auto-save task time: $e');
              }
            }
          }
        }
      }
    } else {
      _stopMasterTimerIfNoActiveTasks();
    }
  }

  @override
  void dispose() {
    if (_tasksWithActiveTimers.isNotEmpty) {
      for (final task in _allTasks) {
        if (_tasksWithActiveTimers.contains(task.id)) {
          localDataSource.updateTask(task).catchError((e) {
            debugPrint('Failed to save task time during provider dispose: $e');
          });
        }
      }
    }

    _masterUpdateTimer?.cancel();
    super.dispose();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
