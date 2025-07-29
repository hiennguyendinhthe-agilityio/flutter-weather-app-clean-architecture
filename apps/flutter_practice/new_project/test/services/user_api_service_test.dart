import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_project/core/exceptions/api_exceptions.dart';
import 'package:new_project/models/user_model.dart';
import 'package:new_project/services/user_api_service.dart';

import '../mocks/mock_services.dart';

void main() {
  group('UserApiService Tests', () {
    late UserApiService userApiService;
    late MockDioService mockDioService;
    late MockLoggerService mockLoggerService;
    late MockDio mockDio;

    setUp(() {
      mockDioService = MockDioService();
      mockLoggerService = MockSetupHelper.setupMockLogger();
      mockDio = MockDio();

      // Setup DioService to return mock Dio
      when(() => mockDioService.dio).thenReturn(mockDio);

      userApiService = UserApiService(mockDioService, mockLoggerService);

      // Register fallback values
      registerFallbackValue(RequestOptions(path: ''));
      registerFallbackValue(const CreateUserRequest(name: '', email: ''));
      registerFallbackValue(const UpdateUserRequest());
    });

    group('Get Users', () {
      test('should return list of users on successful API call', () async {
        // Arrange
        final mockResponseData = [
          {
            'id': '1',
            'name': 'User 1',
            'email': 'user1@example.com',
            'avatar': 'https://example.com/avatar1.jpg',
          },
          {
            'id': '2',
            'name': 'User 2',
            'email': 'user2@example.com',
            'avatar': 'https://example.com/avatar2.jpg',
          },
        ];

        final mockResponse = Response(
          data: mockResponseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/user'),
        );

        when(() => mockDio.get('/user')).thenAnswer((_) async => mockResponse);

        // Act
        final result = await userApiService.getUsers();

        // Assert
        expect(result, isA<List<ApiUser>>());
        expect(result.length, equals(2));
        expect(result[0].id, equals('1'));
        expect(result[0].name, equals('User 1'));
        expect(result[0].email, equals('user1@example.com'));
        expect(result[1].id, equals('2'));

        // Verify API was called
        verify(() => mockDio.get('/user')).called(1);
      });

      test('should throw ServerException on API error', () async {
        // Arrange
        final mockResponse = Response(
          data: null,
          statusCode: 500,
          requestOptions: RequestOptions(path: '/user'),
        );

        when(() => mockDio.get('/user')).thenAnswer((_) async => mockResponse);

        // Act & Assert
        expect(
          () => userApiService.getUsers(),
          throwsA(isA<ServerException>()),
        );
      });

      test('should handle DioException', () async {
        // Arrange
        when(() => mockDio.get('/user')).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/user'),
            type: DioExceptionType.connectionTimeout,
          ),
        );

        // Act & Assert
        expect(() => userApiService.getUsers(), throwsA(isA<DioException>()));
      });
    });

    group('Get User By ID', () {
      test('should return user on successful API call', () async {
        // Arrange
        const userId = '1';
        final mockResponseData = {
          'id': userId,
          'name': 'Test User',
          'email': 'test@example.com',
        };

        final mockResponse = Response(
          data: mockResponseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/user/$userId'),
        );

        when(
          () => mockDio.get('/user/$userId'),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await userApiService.getUserById(userId);

        // Assert
        expect(result, isA<ApiUser>());
        expect(result.id, equals(userId));
        expect(result.name, equals('Test User'));
        expect(result.email, equals('test@example.com'));

        // Verify API was called
        verify(() => mockDio.get('/user/$userId')).called(1);
      });
    });

    group('Create User', () {
      test('should create user successfully', () async {
        // Arrange
        const request = CreateUserRequest(
          name: 'New User',
          email: 'newuser@example.com',
          avatar: 'https://example.com/avatar.jpg',
        );

        final mockResponseData = {
          'id': '3',
          'name': 'New User',
          'email': 'newuser@example.com',
          'avatar': 'https://example.com/avatar.jpg',
          'created_at': '2024-01-01T00:00:00Z',
        };

        final mockResponse = Response(
          data: mockResponseData,
          statusCode: 201,
          requestOptions: RequestOptions(path: '/user'),
        );

        when(
          () => mockDio.post('/user', data: any(named: 'data')),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await userApiService.createUser(request);

        // Assert
        expect(result, isA<ApiUser>());
        expect(result.id, equals('3'));
        expect(result.name, equals('New User'));
        expect(result.email, equals('newuser@example.com'));

        // Verify API was called with correct data
        verify(() => mockDio.post('/user', data: request.toJson())).called(1);
      });
    });

    group('Update User', () {
      test('should update user successfully', () async {
        // Arrange
        const userId = '1';
        const request = UpdateUserRequest(
          name: 'Updated User',
          email: 'updated@example.com',
        );

        final mockResponseData = {
          'id': userId,
          'name': 'Updated User',
          'email': 'updated@example.com',
          'updated_at': '2024-01-01T00:00:00Z',
        };

        final mockResponse = Response(
          data: mockResponseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/user/$userId'),
        );

        when(
          () => mockDio.put('/user/$userId', data: any(named: 'data')),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await userApiService.updateUser(userId, request);

        // Assert
        expect(result, isA<ApiUser>());
        expect(result.id, equals(userId));
        expect(result.name, equals('Updated User'));
        expect(result.email, equals('updated@example.com'));

        // Verify API was called
        verify(
          () => mockDio.put('/user/$userId', data: request.toJson()),
        ).called(1);
      });
    });

    group('Delete User', () {
      test('should delete user successfully', () async {
        // Arrange
        const userId = '1';

        final mockResponse = Response(
          data: null,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/user/$userId'),
        );

        when(
          () => mockDio.delete('/user/$userId'),
        ).thenAnswer((_) async => mockResponse);

        // Act
        await userApiService.deleteUser(userId);

        // Assert - should not throw
        // Verify API was called
        verify(() => mockDio.delete('/user/$userId')).called(1);
      });
    });

    group('Search Users', () {
      test('should search users successfully', () async {
        // Arrange
        const query = 'test';
        final mockResponseData = [
          {'id': '1', 'name': 'Test User', 'email': 'test@example.com'},
        ];

        final mockResponse = Response(
          data: mockResponseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/user'),
        );

        when(
          () => mockDio.get('/user', queryParameters: {'search': query}),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await userApiService.searchUsers(query);

        // Assert
        expect(result, isA<List<ApiUser>>());
        expect(result.length, equals(1));
        expect(result[0].name, equals('Test User'));

        // Verify API was called with search parameter
        verify(
          () => mockDio.get('/user', queryParameters: {'search': query}),
        ).called(1);
      });
    });
  });
}

// Mock Dio class
class MockDio extends Mock implements Dio {}
