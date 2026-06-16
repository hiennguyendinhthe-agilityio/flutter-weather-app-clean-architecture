import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/todo_entity.dart';
import 'todo_providers.dart';

class TodoListNotifier extends AsyncNotifier<List<TodoEntity>> {
  @override
  Future<List<TodoEntity>> build() async {
    return ref.read(getTodosUseCaseProvider)();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(getTodosUseCaseProvider)());
  }

  Future<void> add(String title, {String? note}) async {
    final previousState = state;
    try {
      final newTodo = await ref.read(addTodoUseCaseProvider)(title, note: note);

      state = AsyncData([newTodo, ...state.value ?? []]);
    } catch (e) {
      state = previousState;
      rethrow;
    }
  }

  Future<void> toggle(int id) async {
    final previousState = state;
    try {
      final updated = await ref.read(toggleTodoUseCaseProvider)(id);

      state = AsyncData([
        for (final todo in state.value ?? [])
          if (todo.id == id) updated else todo,
      ]);
    } catch (_) {
      state = previousState;
      rethrow;
    }
  }

  Future<void> updateTodo(TodoEntity todo) async {
    final previousState = state;
    try {
      final updated = await ref.read(updateTodoUseCaseProvider)(todo);
      state = AsyncData([
        for (final t in state.value ?? [])
          if (t.id == todo.id) updated else t,
      ]);
    } catch (_) {
      state = previousState;
      rethrow;
    }
  }

  Future<void> delete(int id) async {
    final previousState = state;
    try {
      await ref.read(deleteTodoUseCaseProvider)(id);
      state = AsyncData((state.value ?? []).where((t) => t.id != id).toList());
    } catch (_) {
      state = previousState;
      rethrow;
    }
  }
}

final todoListNotifierProvider =
    AsyncNotifierProvider<TodoListNotifier, List<TodoEntity>>(
      TodoListNotifier.new,
    );
