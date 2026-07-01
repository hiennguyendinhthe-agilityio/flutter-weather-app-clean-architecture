import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/domain/entities/priority.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/domain/entities/todo_entity.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/domain/repositories/todo_repository.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/domain/usecases/add_todo_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  late AddTodoUseCase sut;
  late MockTodoRepository mockRepository;

  const fakeTodo = TodoEntity(
    id: 1,
    title: 'Test Todo',
    isCompleted: false,
    priority: Priority.medium,
  );

  setUp(() {
    mockRepository = MockTodoRepository();
    sut = AddTodoUseCase(mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(fakeTodo);
  });

  group('AddTodoUseCase - Validation', () {
    test('should throw ArgumentError when title is empty', () async {
      expect(() async => await sut(''), throwsA(isA<ArgumentError>()));
      verifyNever(() => mockRepository.addTodo(any()));
    });

    test('should throw ArgumentError when title is only whitespace', () async {
      expect(() async => await sut('   '), throwsA(isA<ArgumentError>()));
      verifyNever(() => mockRepository.addTodo(any()));
    });

    test(
      'should throw ArgumentError when title exceeds 200 characters',
      () async {
        final longTitle = 'A' * 201;
        expect(() async => await sut(longTitle), throwsA(isA<ArgumentError>()));
        verifyNever(() => mockRepository.addTodo(any()));
      },
    );

    test('should trim whitespace before calling repository', () async {
      when(
        () => mockRepository.addTodo('Valid Title', note: any(named: 'note')),
      ).thenAnswer((_) async => fakeTodo);

      await sut('  Valid Title  ');

      verify(
        () => mockRepository.addTodo('Valid Title', note: any(named: 'note')),
      ).called(1);
    });
  });

  group('AddTodoUseCase - Happy Path', () {
    test('should call repository and return TodoEntity on success', () async {
      when(
        () => mockRepository.addTodo('Test Todo', note: null),
      ).thenAnswer((_) async => fakeTodo);

      final result = await sut('Test Todo');

      expect(result, equals(fakeTodo));
      verify(() => mockRepository.addTodo('Test Todo', note: null)).called(1);
    });

    test('should pass note to repository when provided', () async {
      when(
        () => mockRepository.addTodo('Test Todo', note: 'My note'),
      ).thenAnswer((_) async => fakeTodo);

      await sut('Test Todo', note: 'My note');

      verify(
        () => mockRepository.addTodo('Test Todo', note: 'My note'),
      ).called(1);
    });

    test('should trim note whitespace', () async {
      when(
        () => mockRepository.addTodo('Test Todo', note: 'My note'),
      ).thenAnswer((_) async => fakeTodo);

      await sut('Test Todo', note: '  My note  ');

      verify(
        () => mockRepository.addTodo('Test Todo', note: 'My note'),
      ).called(1);
    });

    test('should accept title with exactly 200 characters', () async {
      final maxTitle = 'A' * 200;
      when(
        () => mockRepository.addTodo(maxTitle, note: null),
      ).thenAnswer((_) async => fakeTodo);

      final result = await sut(maxTitle);

      expect(result, equals(fakeTodo));
    });
  });
}
