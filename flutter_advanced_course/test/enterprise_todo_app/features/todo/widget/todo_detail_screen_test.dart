// test/enterprise_todo_app/features/todo/widget/todo_detail_screen_test.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/domain/entities/priority.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/domain/entities/todo_entity.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/domain/repositories/todo_repository.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/presentation/providers/todo_list_notifier.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/presentation/providers/todo_providers.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/presentation/screens/todo_detail_screen.dart';
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
      return Completer<PaginatedState<TodoEntity>>().future;
    }
  }
}

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  late MockTodoRepository mockRepository;

  final mockTodoCompleted = const TodoEntity(
    id: 1,
    title: 'Test Completed Todo',
    note: 'Test note',
    isCompleted: true,
    priority: Priority.high,
  );

  final mockTodoInProgress = const TodoEntity(
    id: 2,
    title: 'Test In Progress Todo',
    isCompleted: false,
    priority: Priority.low,
  );

  setUp(() {
    mockRepository = MockTodoRepository();
    // Register fallback for mocktail if needed
    registerFallbackValue(mockTodoCompleted);
  });

  Widget createWidgetUnderTest(
    int todoId, {
    MockTodoListNotifier? listNotifier,
    bool delayFetch = false,
  }) {
    when(() => mockRepository.getTodoById(todoId)).thenAnswer((_) async {
      if (delayFetch) {
        await Future.delayed(const Duration(milliseconds: 500));
      }
      return todoId == 1 ? mockTodoCompleted : mockTodoInProgress;
    });

    final defaultListNotifier = MockTodoListNotifier(
      AsyncData(PaginatedState.initial()),
    );

    return ProviderScope(
      overrides: [
        todoRepositoryProvider.overrideWithValue(mockRepository),
        todoListNotifierProvider.overrideWith(
          () => listNotifier ?? defaultListNotifier,
        ),
      ],
      child: MaterialApp(home: TodoDetailScreen(todoId: todoId)),
    );
  }

  group('TodoDetailScreen Widget Tests', () {
    testWidgets('Displays CircularProgressIndicator when loading', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest(1, delayFetch: true));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle(); // Finish the loading
    });

    testWidgets('Displays title and note in TextFields', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest(1));
      await tester.pumpAndSettle();

      expect(find.text('Test Completed Todo'), findsOneWidget);
      expect(find.text('Test note'), findsOneWidget);
    });

    testWidgets('Displays "Completed" banner when isCompleted is true', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest(1));
      await tester.pumpAndSettle();

      expect(find.text('Completed'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    });

    testWidgets('Displays "In progress" banner when isCompleted is false', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest(2));
      await tester.pumpAndSettle();

      expect(find.text('In progress'), findsOneWidget);
      expect(find.byIcon(Icons.pending_rounded), findsOneWidget);
    });

    testWidgets('Save button is hidden when there are no changes', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest(1));
      await tester.pumpAndSettle();

      expect(find.text('Save'), findsNothing);
    });

    testWidgets('Save button appears after editing title', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest(1));
      await tester.pumpAndSettle();

      // Find the title text field and enter new text
      await tester.enterText(find.byType(TextField).first, 'Updated Title');
      await tester.pump();

      expect(find.text('Save'), findsOneWidget);
    });

    testWidgets('Priority selector displays 3 options', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest(1));
      await tester.pumpAndSettle();

      expect(find.text('Low'), findsWidgets);
      expect(find.text('Medium'), findsWidgets);
      expect(find.text('High'), findsWidgets);
    });

    testWidgets('Tapping Save button calls updateTodo on notifier', (
      WidgetTester tester,
    ) async {
      final mockNotifier = MockTodoListNotifier(
        AsyncData(PaginatedState.initial()),
      );
      when(() => mockNotifier.updateTodo(any())).thenAnswer((_) async {});

      await tester.pumpWidget(
        createWidgetUnderTest(1, listNotifier: mockNotifier),
      );
      await tester.pumpAndSettle();

      // Edit title to reveal the Save button
      await tester.enterText(find.byType(TextField).first, 'Updated Title');
      await tester.pump();

      // Tap Save
      await tester.tap(find.text('Save'));
      await tester.pump();

      // Verify that updateTodo was called with the updated entity
      final captured = verify(
        () => mockNotifier.updateTodo(captureAny()),
      ).captured;
      expect(captured.length, 1);
      final updatedTodo = captured.first as TodoEntity;
      expect(updatedTodo.title, 'Updated Title');
    });
  });
}
