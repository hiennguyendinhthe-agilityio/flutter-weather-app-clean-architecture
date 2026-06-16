import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/todo_entity.dart';
import 'todo_list_notifier.dart';

enum TodoFilter { all, active, completed }

class TodoFilterNotifier extends Notifier<TodoFilter> {
  @override
  TodoFilter build() => TodoFilter.all;

  void setFilter(TodoFilter filter) => state = filter;
}

final todoFilterProvider = NotifierProvider<TodoFilterNotifier, TodoFilter>(
  TodoFilterNotifier.new,
);

final filteredTodosProvider = Provider<List<TodoEntity>>((ref) {
  final todosAsync = ref.watch(todoListNotifierProvider);
  final filter = ref.watch(todoFilterProvider);

  return todosAsync.when(
    data: (todos) => switch (filter) {
      TodoFilter.all => todos,
      TodoFilter.active => todos.where((t) => !t.isCompleted).toList(),
      TodoFilter.completed => todos.where((t) => t.isCompleted).toList(),
    },
    loading: () => [],
    error: (error, stackTrace) => [],
  );
});

final activeCountProvider = Provider<int>((ref) {
  return ref.watch(
    todoListNotifierProvider.select(
      (state) => state.value?.where((t) => !t.isCompleted).length ?? 0,
    ),
  );
});
