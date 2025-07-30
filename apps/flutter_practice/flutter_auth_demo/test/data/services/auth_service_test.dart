import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_auth_demo/core/exceptions/app_exceptions.dart';
import 'package:flutter_auth_demo/data/datasources/api_client.dart';
import 'package:flutter_auth_demo/data/models/api_user.dart';
import 'package:flutter_auth_demo/data/services/auth_service.dart';
import 'package:flutter_auth_demo/data/services/storage_service.dart';

// Mock classes
class MockApiClient extends Mock implements ApiClient {}
class MockStorageService extends Mock implements StorageService {}

// Test data
const testUser = ApiUser(
  id: '1',
  name: 'Test User',
  email: 'test@example.com',
  avatar: 'https://example.com/avatar.jpg',
);

const testEmail = 'test@example.com';
const testPassword = 'password123';
const testName = 'Test User';

void main() {
  group('AuthService Tests', () {
    late AuthService authService;
    late MockApiClient mockApiClient;
    late MockStorageService mockStorageService;

    setUp(() {
      mockApiClient = MockApiClient();
      mockStorageService = MockStorageService();
      authService = AuthService(mockApiClient, mockStorageService);
    });

    group('SignUp', () {
      test('should signup successfully when user does not exist', () async {
        // Arrange
        when(() => mockApiClient.getUserByEmail(testEmail))
            .thenAnswer((_) async => []);
        when(() => mockApiClient.createUser(any()))
            .thenAnswer((_) async => testUser);

        // Act
        final result = await authService.signUp(testName, testEmail, testPassword);

        // Assert
        expect(result, testUser);
        verify(() => mockApiClient.getUserByEmail(testEmail)).called(1);
        verify(() => mockApiClient.createUser(any())).called(1);
      });

      test('should throw AuthException when user already exists', () async {
        // Arrange
        when(() => mockApiClient.getUserByEmail(testEmail))
            .thenAnswer((_) async => [testUser]);

        // Act & Assert
        expect(
          () => authService.signUp(testName, testEmail, testPassword),
          throwsA(isA<AuthException>()),
        );
        verify(() => mockApiClient.getUserByEmail(testEmail)).called(1);
        verifyNever(() => mockApiClient.createUser(any()));
      });

      test('should throw ValidationException for invalid name', () async {
        // Act & Assert
        expect(
          () => authService.signUp('', testEmail, testPassword),
          throwsA(isA<ValidationException>()),
        );
        verifyNever(() => mockApiClient.getUserByEmail(any()));
      });

      test('should throw ValidationException for invalid email', () async {
        // Act & Assert
        expect(
          () => authService.signUp(testName, 'invalid-email', testPassword),
          throwsA(isA<ValidationException>()),
        );
        verifyNever(() => mockApiClient.getUserByEmail(any()));
      });

      test('should throw ValidationException for invalid password', () async {
        // Act & Assert
        expect(
          () => authService.signUp(testName, testEmail, '123'),
          throwsA(isA<ValidationException>()),
        );
        verifyNever(() => mockApiClient.getUserByEmail(any()));
      });
    });

    group('Login', () {
      test('should login successfully with valid credentials', () async {
        // Arrange
        when(() => mockApiClient.getUserByEmail(testEmail))
            .thenAnswer((_) async => [testUser]);
        when(() => mockStorageService.saveToken(any()))
            .thenAnswer((_) async {});
        when(() => mockStorageService.saveUser(testUser))
            .thenAnswer((_) async {});

        // Act
        final result = await authService.login(testEmail, testPassword);

        // Assert
        expect(result, testUser);
        verify(() => mockApiClient.getUserByEmail(testEmail)).called(1);
        verify(() => mockStorageService.saveToken(any())).called(1);
        verify(() => mockStorageService.saveUser(testUser)).called(1);
      });

      test('should throw AuthException when user not found', () async {
        // Arrange
        when(() => mockApiClient.getUserByEmail(testEmail))
            .thenAnswer((_) async => []);

        // Act & Assert
        expect(
          () => authService.login(testEmail, testPassword),
          throwsA(isA<AuthException>()),
        );
        verify(() => mockApiClient.getUserByEmail(testEmail)).called(1);
        verifyNever(() => mockStorageService.saveToken(any()));
      });

      test('should throw ValidationException for invalid email', () async {
        // Act & Assert
        expect(
          () => authService.login('invalid-email', testPassword),
          throwsA(isA<ValidationException>()),
        );
        verifyNever(() => mockApiClient.getUserByEmail(any()));
      });

      test('should throw ValidationException for empty password', () async {
        // Act & Assert
        expect(
          () => authService.login(testEmail, ''),
          throwsA(isA<ValidationException>()),
        );
        verifyNever(() => mockApiClient.getUserByEmail(any()));
      });
    });

    group('Logout', () {
      test('should logout successfully', () async {
        // Arrange
        when(() => mockStorageService.clearAll()).thenAnswer((_) async {});

        // Act
        await authService.logout();

        // Assert
        verify(() => mockStorageService.clearAll()).called(1);
      });

      test('should throw AuthException when logout fails', () async {
        // Arrange
        when(() => mockStorageService.clearAll())
            .thenThrow(Exception('Storage error'));

        // Act & Assert
        expect(
          () => authService.logout(),
          throwsA(isA<AuthException>()),
        );
        verify(() => mockStorageService.clearAll()).called(1);
      });
    });

    group('Session Management', () {
      test('should return true when valid session exists', () async {
        // Arrange
        when(() => mockStorageService.hasValidSession())
            .thenAnswer((_) async => true);

        // Act
        final result = await authService.hasValidSession();

        // Assert
        expect(result, true);
        verify(() => mockStorageService.hasValidSession()).called(1);
      });

      test('should return false when no valid session', () async {
        // Arrange
        when(() => mockStorageService.hasValidSession())
            .thenAnswer((_) async => false);

        // Act
        final result = await authService.hasValidSession();

        // Assert
        expect(result, false);
        verify(() => mockStorageService.hasValidSession()).called(1);
      });

      test('should return current user when available', () async {
        // Arrange
        when(() => mockStorageService.getUser())
            .thenAnswer((_) async => testUser);

        // Act
        final result = await authService.getCurrentUser();

        // Assert
        expect(result, testUser);
        verify(() => mockStorageService.getUser()).called(1);
      });

      test('should return null when no current user', () async {
        // Arrange
        when(() => mockStorageService.getUser())
            .thenThrow(Exception('No user found'));

        // Act
        final result = await authService.getCurrentUser();

        // Assert
        expect(result, isNull);
        verify(() => mockStorageService.getUser()).called(1);
      });
    });
  });
}