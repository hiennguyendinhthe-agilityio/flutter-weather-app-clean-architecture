import 'dart:async';

import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/domain/entities/todo_entity.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/presentation/providers/todo_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaginatedState<T> {
  final List<T> items;
  final int page;
  final bool hasMore;
  final bool isLoadingMore;
  final String? errorMessage;

  const PaginatedState({
    required this.items,
    required this.page,
    required this.hasMore,
    required this.isLoadingMore,
    this.errorMessage,
  });

  factory PaginatedState.initial() {
    return const PaginatedState(
      items: [],
      page: 1,
      hasMore: true,
      isLoadingMore: false,
    );
  }

  PaginatedState<T> copyWith({
    List<T>? items,
    int? page,
    bool? hasMore,
    bool? isLoadingMore,
    String? errorMessage,
  }) {
    return PaginatedState(
      items: items ?? this.items,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage,
    );
  }
}

class TodoListNotifier extends AsyncNotifier<PaginatedState<TodoEntity>> {
  static const int _limit = 15;

  @override
  Future<PaginatedState<TodoEntity>> build() async {
    final useCase = ref.read(getPaginatedTodosUseCaseProvider);
    final items = await useCase(page: 1, limit: _limit);
    return PaginatedState(
      items: items,
      page: 1,
      hasMore: items.length >= _limit,
      isLoadingMore: false,
    );
  }

  Future<void> fetchNextPage() async {
    final currentState = state.value;
    if (currentState == null ||
        !currentState.hasMore ||
        currentState.isLoadingMore) {
      return;
    }

    state = AsyncData(
      currentState.copyWith(isLoadingMore: true, errorMessage: null),
    );

    try {
      final nextPage = currentState.page + 1;
      final useCase = ref.read(getPaginatedTodosUseCaseProvider);
      final newItems = await useCase(page: nextPage, limit: _limit);

      state = AsyncData(
        currentState.copyWith(
          items: [...currentState.items, ...newItems],
          page: nextPage,
          hasMore: newItems.length >= _limit,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      state = AsyncData(
        currentState.copyWith(
          isLoadingMore: false,
          errorMessage: e.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final useCase = ref.read(getPaginatedTodosUseCaseProvider);
      final items = await useCase(page: 1, limit: _limit);
      return PaginatedState(
        items: items,
        page: 1,
        hasMore: items.length >= _limit,
        isLoadingMore: false,
      );
    });
  }

  Future<void> add(String title, {String? note}) async {
    final previousState = state;
    try {
      final newTodo = await ref.read(addTodoUseCaseProvider)(title, note: note);

      if (state.hasValue) {
        final current = state.value!;
        state = AsyncData(current.copyWith(items: [newTodo, ...current.items]));
      }
    } catch (e) {
      state = previousState;
      rethrow;
    }
  }

  Future<void> toggle(int id) async {
    final previousState = state;
    try {
      final updated = await ref.read(toggleTodoUseCaseProvider)(id);

      if (state.hasValue) {
        final current = state.value!;
        state = AsyncData(
          current.copyWith(
            items: [
              for (final todo in current.items)
                if (todo.id == id) updated else todo,
            ],
          ),
        );
      }
    } catch (_) {
      state = previousState;
      rethrow;
    }
  }

  Future<void> updateTodo(TodoEntity todo) async {
    final previousState = state;
    try {
      final updated = await ref.read(updateTodoUseCaseProvider)(todo);

      if (state.hasValue) {
        final current = state.value!;
        state = AsyncData(
          current.copyWith(
            items: [
              for (final t in current.items)
                if (t.id == todo.id) updated else t,
            ],
          ),
        );
      }
    } catch (_) {
      state = previousState;
      rethrow;
    }
  }

  Future<void> delete(int id) async {
    final previousState = state;
    try {
      await ref.read(deleteTodoUseCaseProvider)(id);

      if (state.hasValue) {
        final current = state.value!;
        state = AsyncData(
          current.copyWith(
            items: current.items.where((t) => t.id != id).toList(),
          ),
        );
      }
    } catch (_) {
      state = previousState;
      rethrow;
    }
  }
}

final todoListNotifierProvider =
    AsyncNotifierProvider<TodoListNotifier, PaginatedState<TodoEntity>>(
      TodoListNotifier.new,
    );
