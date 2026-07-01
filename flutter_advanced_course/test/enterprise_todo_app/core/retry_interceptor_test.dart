import 'package:dio/dio.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/core/network/retry_interceptor.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/presentation/providers/todo_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

class MockErrorInterceptorHandler extends Mock
    implements ErrorInterceptorHandler {}

final retryInterceptorProvider = Provider<RetryInterceptor>((ref) {
  return RetryInterceptor(ref, maxRetries: 3, retryDelay: Duration.zero);
});

void main() {
  late MockDio mockDio;
  late ProviderContainer container;
  late RetryInterceptor sut;

  setUpAll(() {
    registerFallbackValue(RequestOptions(path: '/'));
    registerFallbackValue(Options(method: 'GET'));
    registerFallbackValue(
      Response<dynamic>(requestOptions: RequestOptions(path: '/')),
    );
    registerFallbackValue(
      DioException(requestOptions: RequestOptions(path: '/')),
    );
  });

  setUp(() {
    mockDio = MockDio();
    container = ProviderContainer(
      overrides: [dioProvider.overrideWithValue(mockDio)],
    );
    sut = container.read(retryInterceptorProvider);
  });

  test('retries on timeout and resolves with successful response', () async {
    when(
      () => mockDio.request(
        any(),
        data: any(named: 'data'),
        queryParameters: any(named: 'queryParameters'),
        options: any(named: 'options'),
      ),
    ).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/todos'),
        statusCode: 200,
        data: {'ok': true},
      ),
    );

    final requestOptions = RequestOptions(path: '/todos', method: 'GET');
    final error = DioException(
      requestOptions: requestOptions,
      type: DioExceptionType.connectionTimeout,
    );
    final handler = MockErrorInterceptorHandler();

    sut.onError(error, handler);
    await Future<void>.delayed(Duration.zero);

    verify(
      () => mockDio.request(
        any(),
        data: any(named: 'data'),
        queryParameters: any(named: 'queryParameters'),
        options: any(named: 'options'),
      ),
    ).called(1);
    verify(() => handler.resolve(any())).called(1);
  });

  test('does not retry when max retries are exceeded', () async {
    final requestOptions = RequestOptions(
      path: '/todos',
      method: 'GET',
      extra: {'retry_attempt': 2},
    );
    final error = DioException(
      requestOptions: requestOptions,
      type: DioExceptionType.connectionTimeout,
    );
    final handler = MockErrorInterceptorHandler();

    sut.onError(error, handler);
    await Future<void>.delayed(Duration.zero);

    verifyNever(
      () => mockDio.request(
        any(),
        data: any(named: 'data'),
        queryParameters: any(named: 'queryParameters'),
        options: any(named: 'options'),
      ),
    );
    verify(() => handler.next(error)).called(1);
  });
}
