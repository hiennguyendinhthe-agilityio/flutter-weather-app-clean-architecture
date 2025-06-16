import 'package:flutter/material.dart';

/// Task priority levels
enum TaskPriority {
  low,
  medium,
  high,
  urgent;

  /// Get color for priority
  Color get color {
    switch (this) {
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.urgent:
        return Colors.purple;
    }
  }

  /// Get display name for priority
  String get displayName {
    switch (this) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
      case TaskPriority.urgent:
        return 'Urgent';
    }
  }
}

/// Task status
enum TaskStatus {
  todo,
  inProgress,
  completed,
  cancelled;

  /// Get color for status
  Color get color {
    switch (this) {
      case TaskStatus.todo:
        return Colors.grey;
      case TaskStatus.inProgress:
        return Colors.blue;
      case TaskStatus.completed:
        return Colors.green;
      case TaskStatus.cancelled:
        return Colors.red;
    }
  }

  /// Get display name for status
  String get displayName {
    switch (this) {
      case TaskStatus.todo:
        return 'To Do';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.completed:
        return 'Completed';
      case TaskStatus.cancelled:
        return 'Cancelled';
    }
  }

  /// Get icon for status
  IconData get icon {
    switch (this) {
      case TaskStatus.todo:
        return Icons.radio_button_unchecked;
      case TaskStatus.inProgress:
        return Icons.access_time;
      case TaskStatus.completed:
        return Icons.check_circle;
      case TaskStatus.cancelled:
        return Icons.cancel;
    }
  }
}

/// Task model representing a task in the timeline
class Task {
  final String id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final TaskStatus status;
  final TaskPriority priority;
  final String assigneeId;
  final String? teamId;
  final String projectId;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.priority,
    required this.assigneeId,
    this.teamId,
    required this.projectId,
    this.tags = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  /// Get duration of the task
  Duration get duration => endTime.difference(startTime);

  /// Check if task is overdue
  bool get isOverdue =>
      status != TaskStatus.completed &&
      status != TaskStatus.cancelled &&
      endTime.isBefore(DateTime.now());

  /// Check if task is active (in progress and within time range)
  bool get isActive {
    final now = DateTime.now();
    return status == TaskStatus.inProgress &&
        now.isAfter(startTime) &&
        now.isBefore(endTime);
  }

  /// Create a copy of the task with updated fields
  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    TaskStatus? status,
    TaskPriority? priority,
    String? assigneeId,
    String? teamId,
    String? projectId,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      assigneeId: assigneeId ?? this.assigneeId,
      teamId: teamId ?? this.teamId,
      projectId: projectId ?? this.projectId,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  /// Convert task to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'status': status.name,
      'priority': priority.name,
      'assigneeId': assigneeId,
      'teamId': teamId,
      'projectId': projectId,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create task from JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      status: TaskStatus.values.byName(json['status'] as String),
      priority: TaskPriority.values.byName(json['priority'] as String),
      assigneeId: json['assigneeId'] as String,
      teamId: json['teamId'] as String?,
      projectId: json['projectId'] as String,
      tags: List<String>.from(json['tags'] ?? []),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
