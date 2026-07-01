import 'package:dio/dio.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/core/network/auth_interceptor.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/todo/presentation/providers/todo_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockDio extends Mock implements Dio {}

class MockRequestInterceptorHandler extends Mock
    implements RequestInterceptorHandler {}

class MockErrorInterceptorHandler extends Mock
    implements ErrorInterceptorHandler {}

final authInterceptorProvider = Provider<AuthInterceptor>((ref) {
  return AuthInterceptor(ref);
});

void main() {
  late MockAuthLocalDataSource mockLocalDataSource;
  late MockAuthRepository mockAuthRepository;
  late MockDio mockDio;
  late ProviderContainer container;
  late AuthInterceptor sut;

  const initialUser = UserModel(
    id: 1,
    username: 'admin',
    email: 'admin@enterprise.com',
    token: 'old_token',
    refreshToken: 'refresh_token',
  );

  const refreshedUser = UserModel(
    id: 1,
    username: 'admin',
    email: 'admin@enterprise.com',
    token: 'new_token',
    refreshToken: 'refresh_token',
  );

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

  setUp(() async {
    mockLocalDataSource = MockAuthLocalDataSource();
    mockAuthRepository = MockAuthRepository();
    mockDio = MockDio();

    when(
      () => mockAuthRepository.getAuthenticatedUser(),
    ).thenAnswer((_) async => null);
    when(() => mockAuthRepository.logout()).thenAnswer((_) async {});

    container = ProviderContainer(
      overrides: [
        authLocalDataSourceProvider.overrideWithValue(mockLocalDataSource),
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
        dioProvider.overrideWithValue(mockDio),
      ],
    );

    container.read(authProvider);
    await Future<void>.delayed(Duration.zero);
    sut = container.read(authInterceptorProvider);
  });

  tearDown(() {
    container.dispose();
  });

  group('AuthInterceptor', () {
    test('adds Authorization header when auth data exists', () async {
      when(
        () => mockLocalDataSource.getAuthData(),
      ).thenAnswer((_) async => initialUser);
      final options = RequestOptions(path: '/todos', method: 'GET');
      final handler = MockRequestInterceptorHandler();

      sut.onRequest(options, handler);
      await Future<void>.delayed(Duration.zero);

      expect(options.headers['Authorization'], 'Bearer old_token');
      verify(() => handler.next(options)).called(1);
    });

    test('refreshes token and retries request on 401 error', () async {
      when(
        () => mockLocalDataSource.getAuthData(),
      ).thenAnswer((_) async => initialUser);
      when(
        () => mockAuthRepository.refreshToken(),
      ).thenAnswer((_) async => refreshedUser);
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

      final error = DioException(
        requestOptions: RequestOptions(path: '/todos', method: 'GET'),
        response: Response(
          requestOptions: RequestOptions(path: '/todos', method: 'GET'),
          statusCode: 401,
        ),
        type: DioExceptionType.badResponse,
      );
      final handler = MockErrorInterceptorHandler();

      sut.onError(error, handler);
      await Future<void>.delayed(Duration.zero);

      verify(() => mockAuthRepository.refreshToken()).called(1);
      verify(() => handler.resolve(any())).called(1);
      final authState = container.read(authProvider);
      expect(authState.user?.token, 'new_token');
    });

    test('forces logout when refresh token request fails', () async {
      when(
        () => mockLocalDataSource.getAuthData(),
      ).thenAnswer((_) async => initialUser);
      when(
        () => mockAuthRepository.refreshToken(),
      ).thenThrow(Exception('refresh failed'));
      when(() => mockAuthRepository.logout()).thenAnswer((_) async {});

      final error = DioException(
        requestOptions: RequestOptions(path: '/todos', method: 'GET'),
        response: Response(
          requestOptions: RequestOptions(path: '/todos', method: 'GET'),
          statusCode: 401,
        ),
        type: DioExceptionType.badResponse,
      );
      final handler = MockErrorInterceptorHandler();

      sut.onError(error, handler);
      await Future<void>.delayed(Duration.zero);

      verify(() => mockAuthRepository.logout()).called(1);
      verify(() => handler.next(any())).called(1);
      final authState = container.read(authProvider);
      expect(authState.user, isNull);
    });
  });
}
