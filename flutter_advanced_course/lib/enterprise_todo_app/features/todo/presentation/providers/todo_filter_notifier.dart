import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/domain/entities/todo_entity.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/presentation/providers/todo_list_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    data: (paginatedState) => switch (filter) {
      TodoFilter.all => paginatedState.items,
      TodoFilter.active =>
        paginatedState.items.where((t) => !t.isCompleted).toList(),
      TodoFilter.completed =>
        paginatedState.items.where((t) => t.isCompleted).toList(),
    },
    loading: () => [],
    error: (error, stackTrace) => [],
  );
});

final activeCountProvider = Provider<int>((ref) {
  return ref.watch(
    todoListNotifierProvider.select(
      (state) => state.value?.items.where((t) => !t.isCompleted).length ?? 0,
    ),
  );
});
