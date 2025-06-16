import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/task.dart';
import '../models/timeline_event.dart';

/// Task provider managing tasks and timeline events
class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  List<Project> _projects = [];
  DateTime _selectedDate = DateTime.now();
  String? _selectedTeamId;
  bool _isLoading = false;

  final _uuid = const Uuid();

  List<Task> get tasks => _tasks;
  List<Project> get projects => _projects;
  DateTime get selectedDate => _selectedDate;
  String? get selectedTeamId => _selectedTeamId;
  bool get isLoading => _isLoading;

  /// Get tasks for the selected date and team
  List<Task> get filteredTasks {
    return _tasks.where((task) {
      final taskDate = DateTime(
        task.startTime.year,
        task.startTime.month,
        task.startTime.day,
      );
      final selectedDateOnly = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
      );

      final dateMatches = taskDate.isAtSameMomentAs(selectedDateOnly);
      final teamMatches =
          _selectedTeamId == null || task.teamId == _selectedTeamId;

      return dateMatches && teamMatches;
    }).toList();
  }

  /// Get timeline events for the filtered tasks
  List<TimelineEvent> get timelineEvents {
    final filtered = filteredTasks;
    final events = <TimelineEvent>[];

    // Sort tasks by start time
    filtered.sort((a, b) => a.startTime.compareTo(b.startTime));

    // Calculate positions and handle overlaps
    for (int i = 0; i < filtered.length; i++) {
      final task = filtered[i];
      final column = _calculateColumn(task, events);
      final topPosition = _calculateTopPosition(task.startTime);
      final height = _calculateHeight(task.duration);

      events.add(TimelineEvent(
        task: task,
        column: column,
        topPosition: topPosition,
        height: height,
      ));
    }

    return events;
  }

  /// Initialize with mock data
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    _loadMockProjects();
    _loadMockTasks();

    _isLoading = false;
    notifyListeners();
  }

  /// Set selected date
  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  /// Set selected team
  void setSelectedTeam(String? teamId) {
    _selectedTeamId = teamId;
    notifyListeners();
  }

  /// Add a new task
  Future<void> addTask(Task task) async {
    _tasks.add(task);
    notifyListeners();

    // In a real app, you would save to backend/database
    await Future.delayed(const Duration(milliseconds: 200));
  }

  /// Update an existing task
  Future<void> updateTask(Task updatedTask) async {
    final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();

      // In a real app, you would save to backend/database
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }

  /// Delete a task
  Future<void> deleteTask(String taskId) async {
    _tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();

    // In a real app, you would delete from backend/database
    await Future.delayed(const Duration(milliseconds: 200));
  }

  /// Get project by ID
  Project? getProjectById(String projectId) {
    try {
      return _projects.firstWhere((project) => project.id == projectId);
    } catch (e) {
      return null;
    }
  }

  /// Calculate column for overlapping tasks
  int _calculateColumn(Task task, List<TimelineEvent> existingEvents) {
    int column = 0;

    for (final event in existingEvents) {
      if (_tasksOverlap(task, event.task)) {
        if (event.column >= column) {
          column = event.column + 1;
        }
      }
    }

    return column;
  }

  /// Check if two tasks overlap in time
  bool _tasksOverlap(Task task1, Task task2) {
    return task1.startTime.isBefore(task2.endTime) &&
        task1.endTime.isAfter(task2.startTime);
  }

  /// Calculate top position based on time (24-hour grid)
  double _calculateTopPosition(DateTime time) {
    final hour = time.hour;
    final minute = time.minute;
    const hourHeight = 60.0; // 60 pixels per hour

    return (hour * hourHeight) + (minute * hourHeight / 60);
  }

  /// Calculate height based on duration
  double _calculateHeight(Duration duration) {
    const hourHeight = 60.0;
    final hours = duration.inMinutes / 60.0;
    return hours * hourHeight;
  }

  /// Load mock projects
  void _loadMockProjects() {
    _projects = [
      Project(
        id: 'project_1',
        name: 'Mobile App',
        description: 'Flutter mobile application development',
        color: const Color(0xFF2196F3),
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      Project(
        id: 'project_2',
        name: 'Web Platform',
        description: 'React web platform development',
        color: const Color(0xFF4CAF50),
        teamId: 'team_1',
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
      Project(
        id: 'project_3',
        name: 'Design System',
        description: 'UI/UX design system creation',
        color: const Color(0xFFFF9800),
        teamId: 'team_2',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ];
  }

  /// Load mock tasks
  void _loadMockTasks() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    _tasks = [
      // Today's tasks
      Task(
        id: _uuid.v4(),
        title: 'Daily Standup',
        description: 'Team sync meeting',
        startTime: today.add(const Duration(hours: 9)),
        endTime: today.add(const Duration(hours: 9, minutes: 30)),
        status: TaskStatus.completed,
        priority: TaskPriority.medium,
        assigneeId: 'user_1',
        teamId: 'team_1',
        projectId: 'project_1',
        tags: ['meeting', 'standup'],
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now,
      ),
      Task(
        id: _uuid.v4(),
        title: 'Code Review',
        description: 'Review pull requests from team members',
        startTime: today.add(const Duration(hours: 10)),
        endTime: today.add(const Duration(hours: 11, minutes: 30)),
        status: TaskStatus.inProgress,
        priority: TaskPriority.high,
        assigneeId: 'user_1',
        teamId: 'team_1',
        projectId: 'project_1',
        tags: ['development', 'review'],
        createdAt: now.subtract(const Duration(hours: 2)),
        updatedAt: now,
      ),
      Task(
        id: _uuid.v4(),
        title: 'Feature Development',
        description: 'Implement new timeline view feature',
        startTime: today.add(const Duration(hours: 11)),
        endTime: today.add(const Duration(hours: 15)),
        status: TaskStatus.inProgress,
        priority: TaskPriority.high,
        assigneeId: 'user_1',
        projectId: 'project_1',
        tags: ['development', 'feature'],
        createdAt: now.subtract(const Duration(hours: 4)),
        updatedAt: now,
      ),
      Task(
        id: _uuid.v4(),
        title: 'Design Review',
        description: 'Review new UI mockups',
        startTime: today.add(const Duration(hours: 14)),
        endTime: today.add(const Duration(hours: 15, minutes: 30)),
        status: TaskStatus.todo,
        priority: TaskPriority.medium,
        assigneeId: 'user_1',
        teamId: 'team_2',
        projectId: 'project_3',
        tags: ['design', 'review'],
        createdAt: now.subtract(const Duration(minutes: 30)),
        updatedAt: now,
      ),
      Task(
        id: _uuid.v4(),
        title: 'Client Meeting',
        description: 'Weekly client check-in',
        startTime: today.add(const Duration(hours: 16)),
        endTime: today.add(const Duration(hours: 17)),
        status: TaskStatus.todo,
        priority: TaskPriority.urgent,
        assigneeId: 'user_1',
        projectId: 'project_2',
        tags: ['meeting', 'client'],
        createdAt: now.subtract(const Duration(minutes: 15)),
        updatedAt: now,
      ),
    ];
  }
}
