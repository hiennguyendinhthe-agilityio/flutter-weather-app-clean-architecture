import 'package:equatable/equatable.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/domain/entities/priority.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/domain/entities/todo_entity.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/presentation/providers/todo_list_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodoStats extends Equatable {
  final int total;
  final int completed;
  final int active;
  final double completionRate;
  final Map<Priority, int> byPriority;

  const TodoStats({
    required this.total,
    required this.completed,
    required this.active,
    required this.completionRate,
    required this.byPriority,
  });

  factory TodoStats.fromList(List<TodoEntity> todos) {
    if (todos.isEmpty) {
      return TodoStats(
        total: 0,
        completed: 0,
        active: 0,
        completionRate: 0,
        byPriority: {for (final p in Priority.values) p: 0},
      );
    }

    final completed = todos.where((t) => t.isCompleted).length;
    final byPriority = <Priority, int>{};
    for (final p in Priority.values) {
      byPriority[p] = todos.where((t) => t.priority == p).length;
    }

    return TodoStats(
      total: todos.length,
      completed: completed,
      active: todos.length - completed,
      completionRate: completed / todos.length,
      byPriority: byPriority,
    );
  }

  @override
  List<Object?> get props => [
    total,
    completed,
    active,
    completionRate,
    byPriority,
  ];
}

final todoStatsProvider = Provider<TodoStats>((ref) {
  final todos = ref.watch(
    todoListNotifierProvider.select(
      (state) => state.value?.items ?? <TodoEntity>[],
    ),
  );
  return TodoStats.fromList(todos);
});
