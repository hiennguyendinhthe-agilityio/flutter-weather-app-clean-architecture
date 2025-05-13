// lib/domain/entities/task.dart
class Task {
  final String id;
  final String title;
  final String projectName;
  final String assignee;
  final List<String> tags;
  final DateTime createdAt;
  final Duration timeSpent;
  final bool isActive;
  final bool isCompleted;
  final String projectColor;
  final bool isArchived;
  Task({
    required this.id,
    required this.title,
    required this.projectName,
    required this.assignee,
    required this.tags,
    required this.createdAt,
    required this.timeSpent,
    required this.isActive,
    this.isCompleted = false,
    required this.projectColor,
    this.isArchived = false,
  });

  Task copyWith({
    String? id,
    String? title,
    String? projectName,
    String? assignee,
    List<String>? tags,
    DateTime? createdAt,
    Duration? timeSpent,
    bool? isActive,
    bool? isCompleted,
    String? projectColor,
    bool? isArchived,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      projectName: projectName ?? this.projectName,
      assignee: assignee ?? this.assignee,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      timeSpent: timeSpent ?? this.timeSpent,
      isActive: isActive ?? this.isActive,
      isCompleted: isCompleted ?? this.isCompleted,
      projectColor: projectColor ?? this.projectColor,
      isArchived: isArchived ?? this.isArchived,
    );
  }
}
