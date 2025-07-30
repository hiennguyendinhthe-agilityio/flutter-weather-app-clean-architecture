import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_auth_demo/core/enums/auth_state.dart';
import 'package:flutter_auth_demo/core/exceptions/app_exceptions.dart';
import 'package:flutter_auth_demo/data/models/api_user.dart';
import 'package:flutter_auth_demo/data/services/auth_service.dart';
import 'package:flutter_auth_demo/presentation/providers/user_provider.dart';

// Mock classes
class MockAuthService extends Mock implements AuthService {}

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
  group('UserProvider Tests', () {
    late UserProvider userProvider;
    late MockAuthService mockAuthService;

    setUp(() {
      mockAuthService = MockAuthService();
      userProvider = UserProvider(mockAuthService);
    });

    tearDown(() {
      userProvider.dispose();
    });

    group('Initial State', () {
      test('should have initial auth state and null user', () {
        expect(userProvider.authState, AuthState.initial);
        expect(userProvider.currentUser, isNull);
        expect(userProvider.errorMessage, isNull);
        expect(userProvider.isAuthenticated, false);
        expect(userProvider.isLoading, false);
      });
    });

    group('Initialize', () {
      test('should set authenticated state when valid session exists', () async {
        // Arrange
        when(() => mockAuthService.hasValidSession())
            .thenAnswer((_) async => true);
        when(() => mockAuthService.getCurrentUser())
            .thenAnswer((_) async => testUser);

        // Act
        await userProvider.initialize();

        // Assert
        expect(userProvider.authState, AuthState.authenticated);
        expect(userProvider.currentUser, testUser);
        expect(userProvider.errorMessage, isNull);
        verify(() => mockAuthService.hasValidSession()).called(1);
        verify(() => mockAuthService.getCurrentUser()).called(1);
      });

      test('should set unauthenticated state when no valid session', () async {
        // Arrange
        when(() => mockAuthService.hasValidSession())
            .thenAnswer((_) async => false);

        // Act
        await userProvider.initialize();

        // Assert
        expect(userProvider.authState, AuthState.unauthenticated);
        expect(userProvider.currentUser, isNull);
        expect(userProvider.errorMessage, isNull);
        verify(() => mockAuthService.hasValidSession()).called(1);
        verifyNever(() => mockAuthService.getCurrentUser());
      });

      test('should set error state when initialization fails', () async {
        // Arrange
        when(() => mockAuthService.hasValidSession())
            .thenThrow(Exception('Network error'));

        // Act
        await userProvider.initialize();

        // Assert
        expect(userProvider.authState, AuthState.error);
        expect(userProvider.currentUser, isNull);
        expect(userProvider.errorMessage, 'Failed to initialize authentication');
        verify(() => mockAuthService.hasValidSession()).called(1);
      });
    });

    group('Login', () {
      test('should login successfully and set authenticated state', () async {
        // Arrange
        when(() => mockAuthService.login(testEmail, testPassword))
            .thenAnswer((_) async => testUser);

        // Act
        final result = await userProvider.login(testEmail, testPassword);

        // Assert
        expect(result, true);
        expect(userProvider.authState, AuthState.authenticated);
        expect(userProvider.currentUser, testUser);
        expect(userProvider.errorMessage, isNull);
        verify(() => mockAuthService.login(testEmail, testPassword)).called(1);
      });

      test('should handle validation exception during login', () async {
        // Arrange
        const errorMessage = 'Invalid email format';
        when(() => mockAuthService.login(testEmail, testPassword))
            .thenThrow(const ValidationException(errorMessage));

        // Act
        final result = await userProvider.login(testEmail, testPassword);

        // Assert
        expect(result, false);
        expect(userProvider.authState, AuthState.unauthenticated);
        expect(userProvider.currentUser, isNull);
        expect(userProvider.errorMessage, errorMessage);
        verify(() => mockAuthService.login(testEmail, testPassword)).called(1);
      });

      test('should handle auth exception during login', () async {
        // Arrange
        const errorMessage = 'Invalid credentials';
        when(() => mockAuthService.login(testEmail, testPassword))
            .thenThrow(const AuthException(errorMessage));

        // Act
        final result = await userProvider.login(testEmail, testPassword);

        // Assert
        expect(result, false);
        expect(userProvider.authState, AuthState.unauthenticated);
        expect(userProvider.currentUser, isNull);
        expect(userProvider.errorMessage, errorMessage);
        verify(() => mockAuthService.login(testEmail, testPassword)).called(1);
      });

      test('should handle network exception during login', () async {
        // Arrange
        const errorMessage = 'Network connection failed';
        when(() => mockAuthService.login(testEmail, testPassword))
            .thenThrow(const NetworkException(errorMessage));

        // Act
        final result = await userProvider.login(testEmail, testPassword);

        // Assert
        expect(result, false);
        expect(userProvider.authState, AuthState.error);
        expect(userProvider.currentUser, isNull);
        expect(userProvider.errorMessage, errorMessage);
        verify(() => mockAuthService.login(testEmail, testPassword)).called(1);
      });

      test('should handle unexpected exception during login', () async {
        // Arrange
        when(() => mockAuthService.login(testEmail, testPassword))
            .thenThrow(Exception('Unexpected error'));

        // Act
        final result = await userProvider.login(testEmail, testPassword);

        // Assert
        expect(result, false);
        expect(userProvider.authState, AuthState.error);
        expect(userProvider.currentUser, isNull);
        expect(userProvider.errorMessage, 'An unexpected error occurred during login');
        verify(() => mockAuthService.login(testEmail, testPassword)).called(1);
      });
    });

    group('SignUp', () {
      test('should signup successfully and set unauthenticated state', () async {
        // Arrange
        when(() => mockAuthService.signUp(testName, testEmail, testPassword))
            .thenAnswer((_) async => testUser);

        // Act
        final result = await userProvider.signUp(testName, testEmail, testPassword);

        // Assert
        expect(result, true);
        expect(userProvider.authState, AuthState.unauthenticated);
        expect(userProvider.currentUser, isNull);
        expect(userProvider.errorMessage, isNull);
        verify(() => mockAuthService.signUp(testName, testEmail, testPassword)).called(1);
      });

      test('should handle validation exception during signup', () async {
        // Arrange
        const errorMessage = 'Password must be at least 6 characters';
        when(() => mockAuthService.signUp(testName, testEmail, testPassword))
            .thenThrow(const ValidationException(errorMessage));

        // Act
        final result = await userProvider.signUp(testName, testEmail, testPassword);

        // Assert
        expect(result, false);
        expect(userProvider.authState, AuthState.unauthenticated);
        expect(userProvider.currentUser, isNull);
        expect(userProvider.errorMessage, errorMessage);
        verify(() => mockAuthService.signUp(testName, testEmail, testPassword)).called(1);
      });

      test('should handle auth exception during signup', () async {
        // Arrange
        const errorMessage = 'User already exists';
        when(() => mockAuthService.signUp(testName, testEmail, testPassword))
            .thenThrow(const AuthException(errorMessage));

        // Act
        final result = await userProvider.signUp(testName, testEmail, testPassword);

        // Assert
        expect(result, false);
        expect(userProvider.authState, AuthState.unauthenticated);
        expect(userProvider.currentUser, isNull);
        expect(userProvider.errorMessage, errorMessage);
        verify(() => mockAuthService.signUp(testName, testEmail, testPassword)).called(1);
      });

      test('should handle network exception during signup', () async {
        // Arrange
        const errorMessage = 'Network connection failed';
        when(() => mockAuthService.signUp(testName, testEmail, testPassword))
            .thenThrow(const NetworkException(errorMessage));

        // Act
        final result = await userProvider.signUp(testName, testEmail, testPassword);

        // Assert
        expect(result, false);
        expect(userProvider.authState, AuthState.error);
        expect(userProvider.currentUser, isNull);
        expect(userProvider.errorMessage, errorMessage);
        verify(() => mockAuthService.signUp(testName, testEmail, testPassword)).called(1);
      });

      test('should handle unexpected exception during signup', () async {
        // Arrange
        when(() => mockAuthService.signUp(testName, testEmail, testPassword))
            .thenThrow(Exception('Unexpected error'));

        // Act
        final result = await userProvider.signUp(testName, testEmail, testPassword);

        // Assert
        expect(result, false);
        expect(userProvider.authState, AuthState.error);
        expect(userProvider.currentUser, isNull);
        expect(userProvider.errorMessage, 'An unexpected error occurred during sign up');
        verify(() => mockAuthService.signUp(testName, testEmail, testPassword)).called(1);
      });
    });

    group('Logout', () {
      test('should logout successfully and clear user data', () async {
        // Arrange - Set initial authenticated state
        when(() => mockAuthService.login(testEmail, testPassword))
            .thenAnswer((_) async => testUser);
        await userProvider.login(testEmail, testPassword);
        
        when(() => mockAuthService.logout()).thenAnswer((_) async {});

        // Act
        await userProvider.logout();

        // Assert
        expect(userProvider.authState, AuthState.unauthenticated);
        expect(userProvider.currentUser, isNull);
        expect(userProvider.errorMessage, isNull);
        verify(() => mockAuthService.logout()).called(1);
      });

      test('should handle exception during logout', () async {
        // Arrange
        when(() => mockAuthService.logout())
            .thenThrow(Exception('Logout failed'));

        // Act
        await userProvider.logout();

        // Assert
        expect(userProvider.authState, AuthState.error);
        expect(userProvider.errorMessage, 'Failed to logout');
        verify(() => mockAuthService.logout()).called(1);
      });
    });

    group('Error Handling', () {
      test('should clear error message', () async {
        // Arrange - Set an error first
        when(() => mockAuthService.login('invalid', 'invalid'))
            .thenThrow(const ValidationException('Invalid credentials'));
        await userProvider.login('invalid', 'invalid');
        
        // Act
        userProvider.clearError();

        // Assert
        expect(userProvider.errorMessage, isNull);
      });
    });

    group('State Changes', () {
      test('should notify listeners when auth state changes', () async {
        // Arrange
        var notificationCount = 0;
        userProvider.addListener(() {
          notificationCount++;
        });

        when(() => mockAuthService.login(testEmail, testPassword))
            .thenAnswer((_) async => testUser);

        // Act
        await userProvider.login(testEmail, testPassword);

        // Assert
        expect(notificationCount, greaterThan(0));
      });

      test('should have correct loading state during operations', () async {
        // Arrange
        when(() => mockAuthService.login(testEmail, testPassword))
            .thenAnswer((_) async {
          // Simulate delay
          await Future.delayed(const Duration(milliseconds: 100));
          return testUser;
        });

        // Act & Assert
        final loginFuture = userProvider.login(testEmail, testPassword);
        
        // Should be loading initially
        expect(userProvider.isLoading, true);
        expect(userProvider.authState, AuthState.loading);
        
        await loginFuture;
        
        // Should not be loading after completion
        expect(userProvider.isLoading, false);
        expect(userProvider.authState, AuthState.authenticated);
      });
    });
  });
}