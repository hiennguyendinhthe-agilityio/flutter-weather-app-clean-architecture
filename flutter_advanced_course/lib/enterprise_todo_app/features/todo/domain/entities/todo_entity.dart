import 'package:equatable/equatable.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/domain/entities/priority.dart';

class TodoEntity extends Equatable {
  final int id;
  final String title;
  final bool isCompleted;
  final Priority priority;
  final String? note;
  final DateTime? createdAt;

  const TodoEntity({
    required this.id,
    required this.title,
    required this.isCompleted,
    this.priority = Priority.medium,
    this.note,
    this.createdAt,
  });

  TodoEntity copyWith({
    int? id,
    String? title,
    bool? isCompleted,
    Priority? priority,
    String? note,
    DateTime? createdAt,
  }) {
    return TodoEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    isCompleted,
    priority,
    note,
    createdAt,
  ];
}
