// ✅ Refactored TaskProvider (cleaned unused flags & redundant logic)

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:task_management_app/data/datasources/local_data_source.dart';
import 'package:task_management_app/data/models/task.dart';

class TaskProvider extends ChangeNotifier {
  final LocalDataSourceImpl localDataSource;

  Timer? _masterUpdateTimer;
  final Set<String> _tasksWithActiveTimers = {};
  final Map<String, DateTime> _lastUpdateTimes = {};

  bool _isLoading = false;
  String? _errorMessage;

  String? _selectedTaskId;
  List<Task> _allTasks = [];

  TaskProvider({required this.localDataSource});

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Task> get allTasks => _allTasks;
  String? get selectedTaskId => _selectedTaskId;

  List<Task> get archivedTasks => _allTasks.where((t) => t.isArchived).toList();
  List<Task> get activeTasks =>
      _allTasks.where((t) => !t.isArchived && !t.isCompleted).toList();
  List<Task> get tasksForActiveTab =>
      _allTasks.where((t) => !t.isArchived).toList();

  Task? get selectedTask =>
      _allTasks.firstWhereOrNull((t) => t.id == _selectedTaskId);

  Task? get runningTask => _allTasks.firstWhereOrNull(
        (t) => t.isActive && !t.isCompleted && !t.isArchived,
      );
  List<Task> get todayTasksList => _filterTasksByDay(0);
  List<Task> get yesterdayTasksList => _filterTasksByDay(1);

  List<Task> _filterTasksByDay(int subtractDays) {
    final now = DateTime.now();
    final base = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: subtractDays));
    return tasksForActiveTab.where((task) {
      final d = DateTime(
          task.startTime.year, task.startTime.month, task.startTime.day);
      return d.isAtSameMomentAs(base);
    }).toList();
  }

  void setSelectedTask(String? taskId) {
    _selectedTaskId = taskId;
    notifyListeners();
  }

  Future<void> loadTasks() async {
    _setLoading(true);
    try {
      final tasks = await localDataSource.getTasks();
      _allTasks = tasks;
      _initializeActiveTimers(tasks);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load tasks: \$e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addTask(Task task) async {
    if (!_validateTimeRange(task)) return;
    try {
      await localDataSource.saveTask(task);
      _allTasks.add(task);
      if (task.isActive) _trackTaskTimer(task.id);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to add task: \$e';
      notifyListeners();
    }
  }

  Future<void> updateTask(Task task) async {
    if (!_validateTimeRange(task)) return;
    try {
      await localDataSource.updateTask(task);
      final index = _allTasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _allTasks[index] = task;
        _updateTimerTracking(task);
      } else {
        await loadTasks();
      }
    } catch (e) {
      _errorMessage = 'Failed to update task: \$e';
      await loadTasks();
    }
    notifyListeners();
  }

  Future<void> deleteTask(String taskId) async {
    _allTasks.removeWhere((t) => t.id == taskId);
    _untrackTaskTimer(taskId);
    notifyListeners();
    try {
      await localDataSource.deleteTask(taskId);
    } catch (e) {
      _errorMessage = 'Failed to delete task: \$e';
      await loadTasks();
    }
  }

  Future<void> toggleTaskCompletion(String taskId) async {
    final index = _allTasks.indexWhere((t) => t.id == taskId);
    if (index == -1) return;

    final task = _allTasks[index];
    final updated = task.copyWith(
      isCompleted: !task.isCompleted,
      isActive: task.isCompleted ? task.isActive : false,
    );
    await updateTask(updated);
  }

  Future<void> archiveTask(String taskId) async => _archiveToggle(taskId, true);
  Future<void> unarchiveTask(String taskId) async =>
      _archiveToggle(taskId, false);

  Future<void> startTaskTimer(String taskId) async {
    final index = _allTasks.indexWhere((t) => t.id == taskId);
    if (index == -1) return;

    final task = _allTasks[index];
    if (task.isCompleted ||
        task.isArchived ||
        _tasksWithActiveTimers.contains(taskId)) {
      return;
    }

    final updated = task.copyWith(isActive: true);
    _allTasks[index] = updated;
    _trackTaskTimer(taskId);
    notifyListeners();

    try {
      await localDataSource.updateTask(updated);
    } catch (e) {
      _untrackTaskTimer(taskId);
      _allTasks[index] = task;
      _errorMessage = 'Failed to start timer: \$e';
      notifyListeners();
    }
  }

  Future<void> stopTaskTimer(String taskId) async {
    final index = _allTasks.indexWhere((t) => t.id == taskId);
    if (index == -1) return;

    final updated = _allTasks[index].copyWith(isActive: false);
    _allTasks[index] = updated;
    _untrackTaskTimer(taskId);
    notifyListeners();

    try {
      await localDataSource.updateTask(updated);
    } catch (e) {
      _errorMessage = 'Failed to stop timer: \$e';
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    for (final id in _tasksWithActiveTimers) {
      final task = _allTasks.firstWhereOrNull((t) => t.id == id);
      if (task != null) {
        localDataSource.updateTask(task).catchError((e) {
          debugPrint('Dispose failed to save task: \$e');
        });
      }
    }
    _masterUpdateTimer?.cancel();
    super.dispose();
  }

  // 🔧 Helpers
  bool _validateTimeRange(Task task) {
    if (task.endTime.isBefore(task.startTime)) {
      _errorMessage = 'End time cannot be before start time.';
      notifyListeners();
      return false;
    }
    return true;
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _initializeActiveTimers(List<Task> tasks) {
    _tasksWithActiveTimers.clear();
    for (final task in tasks) {
      if (task.isActive && !task.isCompleted && !task.isArchived) {
        _tasksWithActiveTimers.add(task.id);
        _lastUpdateTimes[task.id] = DateTime.now();
      }
    }
    if (_tasksWithActiveTimers.isNotEmpty) _ensureMasterTimerIsRunning();
  }

  void _trackTaskTimer(String taskId) {
    if (_tasksWithActiveTimers.add(taskId)) {
      _lastUpdateTimes[taskId] = DateTime.now();
      _ensureMasterTimerIsRunning();
    }
  }

  void _untrackTaskTimer(String taskId) {
    _tasksWithActiveTimers.remove(taskId);
    _lastUpdateTimes.remove(taskId);
    _stopMasterTimerIfNoActiveTasks();
  }

  void _updateTimerTracking(Task task) {
    if (task.isActive && !task.isCompleted && !task.isArchived) {
      _trackTaskTimer(task.id);
    } else {
      _untrackTaskTimer(task.id);
    }
  }

  Future<void> _archiveToggle(String taskId, bool archive) async {
    final index = _allTasks.indexWhere((t) => t.id == taskId);
    if (index == -1) return;

    final updated = _allTasks[index].copyWith(
      isArchived: archive,
      isActive: archive ? false : _allTasks[index].isActive,
    );
    await updateTask(updated);
  }

  void _ensureMasterTimerIsRunning() {
    if (_masterUpdateTimer == null || !_masterUpdateTimer!.isActive) {
      _masterUpdateTimer = Timer.periodic(
        const Duration(seconds: 1),
        _onMasterTimerTick,
      );
    }
  }

  void _stopMasterTimerIfNoActiveTasks() {
    if (_tasksWithActiveTimers.isEmpty) {
      _masterUpdateTimer?.cancel();
      _masterUpdateTimer = null;
    }
  }

  void _onMasterTimerTick(Timer timer) async {
    if (_tasksWithActiveTimers.isEmpty) {
      _stopMasterTimerIfNoActiveTasks();
      return;
    }

    final now = DateTime.now();
    bool hasChanges = false;
    bool needsSave = false;

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

        final lastSave = _lastUpdateTimes[task.id] ?? now;
        if (now.difference(lastSave).inSeconds >= 15) {
          needsSave = true;
          _lastUpdateTimes[task.id] = now;
        }
      }
    }

    if (hasChanges) notifyListeners();

    if (needsSave) {
      for (final task in _allTasks) {
        if (_tasksWithActiveTimers.contains(task.id)) {
          try {
            await localDataSource.updateTask(task);
          } catch (e) {
            debugPrint('Auto-save failed: \$e');
          }
        }
      }
    }
  }
}
