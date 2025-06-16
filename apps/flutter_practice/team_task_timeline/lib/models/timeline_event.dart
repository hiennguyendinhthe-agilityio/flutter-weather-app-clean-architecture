import 'package:flutter/material.dart';

import 'task.dart';

/// Timeline event representing a task positioned on the timeline
class TimelineEvent {
  final Task task;
  final int column;
  final double topPosition;
  final double height;

  const TimelineEvent({
    required this.task,
    required this.column,
    required this.topPosition,
    required this.height,
  });

  /// Create a copy with updated fields
  TimelineEvent copyWith({
    Task? task,
    int? column,
    double? topPosition,
    double? height,
  }) {
    return TimelineEvent(
      task: task ?? this.task,
      column: column ?? this.column,
      topPosition: topPosition ?? this.topPosition,
      height: height ?? this.height,
    );
  }
}

/// Project model for organizing tasks
class Project {
  final String id;
  final String name;
  final String description;
  final Color color;
  final String? teamId;
  final DateTime createdAt;

  const Project({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    this.teamId,
    required this.createdAt,
  });

  /// Create a copy with updated fields
  Project copyWith({
    String? id,
    String? name,
    String? description,
    Color? color,
    String? teamId,
    DateTime? createdAt,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      color: color ?? this.color,
      teamId: teamId ?? this.teamId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'color': color.value,
      'teamId': teamId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create from JSON
  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      color: Color(json['color'] as int),
      teamId: json['teamId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
