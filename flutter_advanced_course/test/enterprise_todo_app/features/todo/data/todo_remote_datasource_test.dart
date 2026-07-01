import 'package:dio/dio.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/core/error/app_exception.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/data/datasources/todo_remote_datasource.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/data/models/todo_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late TodoRemoteDatasource sut;

  setUp(() {
    mockDio = MockDio();
    sut = TodoRemoteDatasource(mockDio);
    registerFallbackValue(RequestOptions(path: '/'));
  });

  test('getTodos returns parsed list on success', () async {
    final response = Response(
      requestOptions: RequestOptions(path: '/todos'),
      data: [
        {'id': 1, 'title': 'Task', 'completed': false, 'userId': 1},
      ],
      statusCode: 200,
    );

    when(
      () => mockDio.get(any(), queryParameters: any(named: 'queryParameters')),
    ).thenAnswer((_) async => response);

    final todos = await sut.getTodos();

    expect(todos, isA<List<TodoModel>>());
    expect(todos.first.id, equals(1));
  });

  test(
    'getTodos rethrows AppException when DioException.error is AppException',
    () async {
      final err = DioException(
        requestOptions: RequestOptions(path: '/todos'),
        error: const NotFoundException(message: 'not found'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/todos'),
          statusCode: 404,
        ),
      );

      when(
        () =>
            mockDio.get(any(), queryParameters: any(named: 'queryParameters')),
      ).thenThrow(err);

      expect(
        () async => await sut.getTodos(),
        throwsA(isA<NotFoundException>()),
      );
    },
  );

  test('createTodo returns TodoModel on success', () async {
    final response = Response(
      requestOptions: RequestOptions(path: '/todos'),
      data: {'id': 10, 'title': 'Created', 'completed': false, 'userId': 1},
      statusCode: 201,
    );

    when(
      () => mockDio.post(any(), data: any(named: 'data')),
    ).thenAnswer((_) async => response);

    final created = await sut.createTodo({'title': 'Created'});

    expect(created, isA<TodoModel>());
    expect(created.id, equals(10));
  });
}
