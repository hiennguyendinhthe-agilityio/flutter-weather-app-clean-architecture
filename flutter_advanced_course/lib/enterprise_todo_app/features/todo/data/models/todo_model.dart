import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/domain/entities/priority.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/domain/entities/todo_entity.dart';

class TodoModel extends TodoEntity {
  final int? userId;

  const TodoModel({
    required super.id,
    required super.title,
    required super.isCompleted,
    super.priority,
    super.note,
    super.createdAt,
    this.userId,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'] as int,
      title: json['title'] as String,
      isCompleted: json['completed'] as bool,
      userId: json['userId'] as int?,

      priority: Priority.medium,
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'completed': isCompleted,
    'userId': userId ?? 1,
  };

  factory TodoModel.fromHive(Map map) {
    return TodoModel(
      id: map['id'] as int,
      title: map['title'] as String,
      isCompleted: map['isCompleted'] as bool,
      userId: map['userId'] as int?,
      priority: Priority.fromString(map['priority'] as String? ?? 'medium'),
      note: map['note'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toHive() => {
    'id': id,
    'title': title,
    'isCompleted': isCompleted,
    'userId': userId,
    'priority': priority.name,
    'note': note,
    'createdAt': createdAt?.toIso8601String(),
  };

  factory TodoModel.fromEntity(TodoEntity entity) {
    return TodoModel(
      id: entity.id,
      title: entity.title,
      isCompleted: entity.isCompleted,
      priority: entity.priority,
      note: entity.note,
      createdAt: entity.createdAt,
    );
  }

  @override
  TodoModel copyWith({
    int? id,
    String? title,
    bool? isCompleted,
    Priority? priority,
    String? note,
    DateTime? createdAt,
    int? userId,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
    );
  }
}
