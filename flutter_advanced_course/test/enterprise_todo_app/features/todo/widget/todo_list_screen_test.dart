// test/enterprise_todo_app/features/todo/widget/todo_list_screen_test.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/domain/entities/todo_entity.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/presentation/providers/todo_list_notifier.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/presentation/screens/todo_list_screen.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/presentation/widgets/todo_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTodoListNotifier extends AsyncNotifier<PaginatedState<TodoEntity>>
    with Mock
    implements TodoListNotifier {
  final AsyncValue<PaginatedState<TodoEntity>> _initialState;

  MockTodoListNotifier(this._initialState);

  @override
  Future<PaginatedState<TodoEntity>> build() async {
    if (_initialState is AsyncData) {
      return _initialState.value!;
    } else if (_initialState is AsyncError) {
      throw _initialState.error!;
    } else {
      // Return a never-completing future for loading state
      return Completer<PaginatedState<TodoEntity>>().future;
    }
  }
}

void main() {
  final mockTodos = [
    const TodoEntity(id: 1, title: 'Test Todo 1', isCompleted: false),
    const TodoEntity(id: 2, title: 'Test Todo 2', isCompleted: true),
  ];

  Widget createWidgetUnderTest(
    AsyncValue<PaginatedState<TodoEntity>> state, {
    MockTodoListNotifier? notifier,
  }) {
    return ProviderScope(
      overrides: [
        todoListNotifierProvider.overrideWith(
          () => notifier ?? MockTodoListNotifier(state),
        ),
      ],
      child: const MaterialApp(home: TodoListScreen()),
    );
  }

  group('TodoListScreen Widget Tests', () {
    testWidgets('Displays CircularProgressIndicator when loading', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest(const AsyncLoading()));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Displays list of todos when data is available', (
      WidgetTester tester,
    ) async {
      final state = AsyncData<PaginatedState<TodoEntity>>(
        PaginatedState<TodoEntity>(
          items: mockTodos,
          page: 1,
          hasMore: false,
          isLoadingMore: false,
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest(state));
      await tester.pump();

      expect(find.byType(TodoCard), findsNWidgets(2));
      expect(find.text('Test Todo 1'), findsOneWidget);
      expect(find.text('Test Todo 2'), findsOneWidget);
    });

    testWidgets('Displays "No Todo found" when list is empty', (
      WidgetTester tester,
    ) async {
      final state = const AsyncData<PaginatedState<TodoEntity>>(
        PaginatedState<TodoEntity>(
          items: [],
          page: 1,
          hasMore: false,
          isLoadingMore: false,
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest(state));
      await tester.pump();

      expect(find.text('No Todo found'), findsOneWidget);
    });

    testWidgets('Displays error widget when state is error', (
      WidgetTester tester,
    ) async {
      final state = const AsyncError<PaginatedState<TodoEntity>>(
        'Failed to fetch',
        StackTrace.empty,
      );

      await tester.pumpWidget(createWidgetUnderTest(state));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.wifi_off_rounded), findsOneWidget);
      expect(find.text('Failed to fetch'), findsOneWidget);
      expect(find.text('Refresh'), findsOneWidget);
    });

    testWidgets('Filter chips are displayed correctly', (
      WidgetTester tester,
    ) async {
      final state = AsyncData<PaginatedState<TodoEntity>>(
        PaginatedState<TodoEntity>(
          items: mockTodos,
          page: 1,
          hasMore: false,
          isLoadingMore: false,
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest(state));
      await tester.pumpAndSettle();

      expect(find.text('All'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);
      expect(find.text('Completed'), findsOneWidget);
    });

    testWidgets('Add new todo text field is displayed', (
      WidgetTester tester,
    ) async {
      final state = const AsyncData<PaginatedState<TodoEntity>>(
        PaginatedState<TodoEntity>(
          items: [],
          page: 1,
          hasMore: false,
          isLoadingMore: false,
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest(state));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Add'), findsOneWidget);
    });

    testWidgets('Tapping Add button calls add() on notifier', (
      WidgetTester tester,
    ) async {
      final state = const AsyncData<PaginatedState<TodoEntity>>(
        PaginatedState<TodoEntity>(
          items: [],
          page: 1,
          hasMore: false,
          isLoadingMore: false,
        ),
      );

      final mockNotifier = MockTodoListNotifier(state);
      when(() => mockNotifier.add(any())).thenAnswer((_) async {});

      await tester.pumpWidget(
        createWidgetUnderTest(state, notifier: mockNotifier),
      );
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'New Task');
      await tester.tap(find.text('Add'));
      await tester.pump();

      verify(() => mockNotifier.add('New Task')).called(1);
    });
  });
}
