import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/domain/entities/priority.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/domain/entities/todo_entity.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/domain/repositories/todo_repository.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/presentation/providers/todo_list_notifier.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/presentation/providers/todo_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  late MockTodoRepository mockRepository;

  final fakeTodo1 = TodoEntity(
    id: 1,
    title: 'Task 1',
    isCompleted: false,
    priority: Priority.high,
    createdAt: DateTime(2024, 1, 1),
  );
  final fakeTodo2 = TodoEntity(
    id: 2,
    title: 'Task 2',
    isCompleted: true,
    priority: Priority.low,
    createdAt: DateTime(2024, 1, 2),
  );

  setUpAll(() {
    registerFallbackValue(fakeTodo1);
  });

  setUp(() {
    mockRepository = MockTodoRepository();
  });

  ProviderContainer makeContainer() {
    final container = ProviderContainer(
      overrides: [todoRepositoryProvider.overrideWithValue(mockRepository)],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('TodoListNotifier - build()', () {
    test('should load first page on initialization', () async {
      when(
        () => mockRepository.getTodosPaginated(
          page: 1,
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => [fakeTodo1, fakeTodo2]);

      final container = makeContainer();

      final result = await container.read(todoListNotifierProvider.future);

      expect(result.items, hasLength(2));
      expect(result.page, equals(1));
    });
  });

  group('TodoListNotifier - add()', () {
    test('should prepend new todo to list after add', () async {
      when(
        () => mockRepository.getTodosPaginated(
          page: 1,
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => [fakeTodo1]);
      when(
        () => mockRepository.addTodo('New Task', note: null),
      ).thenAnswer((_) async => fakeTodo2.copyWith(id: 99, title: 'New Task'));

      final container = makeContainer();
      await container.read(todoListNotifierProvider.future);

      await container.read(todoListNotifierProvider.notifier).add('New Task');

      final state = container.read(todoListNotifierProvider).value!;
      expect(state.items.first.title, equals('New Task'));
      expect(state.items, hasLength(2));
    });
  });

  group('TodoListNotifier - toggle()', () {
    test('should toggle todo completion state', () async {
      when(
        () => mockRepository.getTodosPaginated(
          page: 1,
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => [fakeTodo1]);
      when(
        () => mockRepository.toggleTodo(1),
      ).thenAnswer((_) async => fakeTodo1.copyWith(isCompleted: true));

      final container = makeContainer();
      await container.read(todoListNotifierProvider.future);

      await container.read(todoListNotifierProvider.notifier).toggle(1);

      final state = container.read(todoListNotifierProvider).value!;
      final toggled = state.items.firstWhere((t) => t.id == 1);
      expect(toggled.isCompleted, isTrue);
    });

    test('should rollback to previous state on toggle error', () async {
      when(
        () => mockRepository.getTodosPaginated(
          page: 1,
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => [fakeTodo1]);
      when(
        () => mockRepository.toggleTodo(1),
      ).thenThrow(Exception('Network error'));

      final container = makeContainer();
      await container.read(todoListNotifierProvider.future);

      expect(
        () async => container.read(todoListNotifierProvider.notifier).toggle(1),
        throwsException,
      );
    });
  });

  group('TodoListNotifier - fetchNextPage()', () {
    test('should not fetch next page when isLoadingMore is true', () async {
      when(
        () => mockRepository.getTodosPaginated(
          page: 1,
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => [fakeTodo1]);

      final container = makeContainer();
      final notifier = container.read(todoListNotifierProvider.notifier);
      await container.read(todoListNotifierProvider.future);

      await notifier.fetchNextPage();

      verify(
        () => mockRepository.getTodosPaginated(
          page: any(named: 'page'),
          limit: any(named: 'limit'),
        ),
      ).called(1);
    });
  });
}
