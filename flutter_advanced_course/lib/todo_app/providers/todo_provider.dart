import 'package:flutter_advanced_course/todo_app/models/todo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'todo_provider.g.dart';

const _uuid = Uuid();

enum TodoFilter { all, active, completed }

@riverpod
class TodoFilterState extends _$TodoFilterState {
  @override
  TodoFilter build() => TodoFilter.all;

  void changeFilter(TodoFilter filter) {
    state = filter;
  }
}

@riverpod
class TodoList extends _$TodoList {
  @override
  List<Todo> build() {
    return [
      Todo(id: _uuid.v4(), description: 'Buy groceries'),
      Todo(id: _uuid.v4(), description: 'Learn Riverpod', isCompleted: true),
      Todo(id: _uuid.v4(), description: 'Build a Flutter app'),
    ];
  }

  void add(String description) {
    state = [...state, Todo(id: _uuid.v4(), description: description)];
  }

  void toggle(String id) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          todo.copyWith(isCompleted: !todo.isCompleted)
        else
          todo,
    ];
  }

  void edit(String id, String newDescription) {
    state = [
      for (final todo in state)
        if (todo.id == id) todo.copyWith(description: newDescription) else todo,
    ];
  }

  void remove(String id) {
    state = state.where((todo) => todo.id != id).toList();
  }
}

@riverpod
List<Todo> filteredTodos(Ref ref) {
  final todos = ref.watch(todoListProvider);
  final filter = ref.watch(todoFilterStateProvider);

  switch (filter) {
    case TodoFilter.completed:
      return todos.where((todo) => todo.isCompleted).toList();
    case TodoFilter.active:
      return todos.where((todo) => !todo.isCompleted).toList();
    case TodoFilter.all:
      return todos;
  }
}
