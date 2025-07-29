import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:new_project/core/exceptions/api_exceptions.dart';
import 'package:new_project/models/user_model.dart';
import 'package:new_project/providers/user_provider.dart';
import 'package:new_project/services/auth_service.dart';

import '../mocks/mock_services.dart';

void main() {
  group('UserProvider Tests', () {
    late UserProvider userProvider;
    late MockUserService mockUserService;
    late MockUserApiService mockUserApiService;
    late MockLoggerService mockLoggerService;

    setUp(() {
      mockUserService = MockSetupHelper.setupMockUserService();
      mockUserApiService = MockSetupHelper.setupMockUserApiService();
      mockLoggerService = MockSetupHelper.setupMockLogger();

      userProvider = UserProvider(
        mockUserService,
        MockAuthService(), // We'll create this
        mockUserApiService,
        mockLoggerService,
      );

      // Register fallback values for mocktail
      registerFallbackValue(const CreateUserRequest(name: '', email: ''));
      registerFallbackValue(const UpdateUserRequest());
    });

    group('Initial State', () {
      test('should have correct initial state', () {
        // Assert
        expect(userProvider.isLoggedIn, isFalse);
        expect(userProvider.currentUser, isNull);
        expect(userProvider.mockApiUser, isNull);
        expect(userProvider.isLoading, isFalse);
        expect(userProvider.hasError, isFalse);
        expect(userProvider.users, isEmpty);
        expect(userProvider.apiUsers, isEmpty);
        expect(userProvider.userCount, equals(0));
      });
    });

    group('Login', () {
      test('should login successfully with valid credentials', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'ValidPass123!';
        final mockUser = MockSetupHelper.createMockApiUser(email: email);
        final mockLoginResponse = MockLoginResponse(
          token: 'mock_token',
          user: mockUser,
          expiresIn: 3600,
        );

        when(
          () => mockUserApiService.simulateLogin(
            email: email,
            password: password,
          ),
        ).thenAnswer((_) async => mockLoginResponse);

        // Act
        await userProvider.login(email, password);

        // Assert
        expect(userProvider.isLoggedIn, isTrue);
        expect(userProvider.currentUser, isNotNull);
        expect(userProvider.currentUser!.email, equals(email));
        expect(userProvider.authToken, equals('mock_token'));
        expect(userProvider.hasError, isFalse);
        expect(userProvider.isLoading, isFalse);

        // Verify API was called
        verify(
          () => mockUserApiService.simulateLogin(
            email: email,
            password: password,
          ),
        ).called(1);
      });

      test('should handle validation error during login', () async {
        // Arrange
        const email = '';
        const password = '';

        when(
          () => mockUserApiService.simulateLogin(
            email: email,
            password: password,
          ),
        ).thenThrow(
          const ValidationException(
            message: 'Email và password không được để trống',
          ),
        );

        // Act
        await userProvider.login(email, password);

        // Assert
        expect(userProvider.isLoggedIn, isFalse);
        expect(userProvider.currentUser, isNull);
        expect(userProvider.hasError, isTrue);
        expect(
          userProvider.errorMessage,
          equals('Email và password không được để trống'),
        );
        expect(userProvider.isLoading, isFalse);
      });

      test('should handle network error during login', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'ValidPass123!';

        when(
          () => mockUserApiService.simulateLogin(
            email: email,
            password: password,
          ),
        ).thenThrow(
          const NetworkException(message: 'Network connection failed'),
        );

        // Act
        await userProvider.login(email, password);

        // Assert
        expect(userProvider.isLoggedIn, isFalse);
        expect(userProvider.hasError, isTrue);
        expect(
          userProvider.errorMessage,
          equals('Lỗi kết nối mạng. Vui lòng kiểm tra internet và thử lại.'),
        );
      });

      test('should handle unauthorized error during login', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'WrongPassword';

        when(
          () => mockUserApiService.simulateLogin(
            email: email,
            password: password,
          ),
        ).thenThrow(const UnauthorizedException());

        // Act
        await userProvider.login(email, password);

        // Assert
        expect(userProvider.isLoggedIn, isFalse);
        expect(userProvider.hasError, isTrue);
        expect(
          userProvider.errorMessage,
          equals('Sai tên đăng nhập hoặc mật khẩu'),
        );
      });

      test('should set loading state during login', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'ValidPass123!';
        final mockUser = MockSetupHelper.createMockApiUser(email: email);
        final mockLoginResponse = MockLoginResponse(
          token: 'mock_token',
          user: mockUser,
          expiresIn: 3600,
        );

        // Create a completer to control when the mock returns
        final completer = Completer<MockLoginResponse>();
        when(
          () => mockUserApiService.simulateLogin(
            email: email,
            password: password,
          ),
        ).thenAnswer((_) => completer.future);

        // Act - start login (don't await yet)
        final loginFuture = userProvider.login(email, password);

        // Assert - should be loading
        expect(userProvider.isLoading, isTrue);

        // Complete the mock
        completer.complete(mockLoginResponse);
        await loginFuture;

        // Assert - should not be loading anymore
        expect(userProvider.isLoading, isFalse);
      });
    });

    group('Logout', () {
      test('should logout successfully', () async {
        // Arrange - first login
        const email = 'test@example.com';
        final mockUser = MockSetupHelper.createMockApiUser(email: email);
        final mockLoginResponse = MockLoginResponse(
          token: 'mock_token',
          user: mockUser,
          expiresIn: 3600,
        );

        when(
          () => mockUserApiService.simulateLogin(
            email: email,
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => mockLoginResponse);

        await userProvider.login(email, 'password');
        expect(userProvider.isLoggedIn, isTrue);

        // Act - logout
        await userProvider.logout();

        // Assert
        expect(userProvider.isLoggedIn, isFalse);
        expect(userProvider.currentUser, isNull);
        expect(userProvider.mockApiUser, isNull);
        expect(userProvider.authToken, isNull);
        expect(userProvider.hasError, isFalse);

        // Verify services were called
        verify(() => mockUserService.logout()).called(1);
      });
    });

    group('Load Users', () {
      test('should load users successfully', () async {
        // Arrange
        final mockUsers = [
          MockSetupHelper.createMockApiUser(id: '1', name: 'User 1'),
          MockSetupHelper.createMockApiUser(id: '2', name: 'User 2'),
        ];

        when(
          () => mockUserApiService.getUsers(),
        ).thenAnswer((_) async => mockUsers);

        // Act
        await userProvider.loadUsers();

        // Assert
        expect(userProvider.apiUsers.length, equals(2));
        expect(userProvider.users.length, equals(2));
        expect(userProvider.userCount, equals(2));
        expect(userProvider.hasError, isFalse);
        expect(userProvider.isLoadingUsers, isFalse);

        // Verify API was called
        verify(() => mockUserApiService.getUsers()).called(1);
      });

      test('should handle error when loading users', () async {
        // Arrange
        when(
          () => mockUserApiService.getUsers(),
        ).thenThrow(const NetworkException(message: 'Failed to load users'));

        // Act
        await userProvider.loadUsers();

        // Assert
        expect(userProvider.apiUsers, isEmpty);
        expect(userProvider.hasError, isTrue);
        expect(
          userProvider.errorMessage,
          equals('Lỗi kết nối mạng. Vui lòng kiểm tra internet và thử lại.'),
        );
        expect(userProvider.isLoadingUsers, isFalse);
      });
    });

    group('Add User', () {
      test('should add user successfully', () async {
        // Arrange
        const name = 'New User';
        const email = 'newuser@example.com';
        final mockNewUser = MockSetupHelper.createMockApiUser(
          id: '3',
          name: name,
          email: email,
        );

        when(
          () => mockUserApiService.createUser(any()),
        ).thenAnswer((_) async => mockNewUser);

        // Act
        await userProvider.addUser(name, email);

        // Assert
        expect(userProvider.apiUsers.length, equals(1));
        expect(userProvider.apiUsers.first.name, equals(name));
        expect(userProvider.apiUsers.first.email, equals(email));
        expect(userProvider.hasError, isFalse);

        // Verify API was called with correct data
        verify(
          () => mockUserApiService.createUser(
            any(
              that: isA<CreateUserRequest>()
                  .having((req) => req.name, 'name', name)
                  .having((req) => req.email, 'email', email),
            ),
          ),
        ).called(1);
      });

      test('should handle validation error when adding user', () async {
        // Arrange
        const name = '';
        const email = '';

        // Act
        await userProvider.addUser(name, email);

        // Assert
        expect(userProvider.apiUsers, isEmpty);
        expect(userProvider.hasError, isTrue);
        expect(
          userProvider.errorMessage,
          equals('Name và email không được để trống'),
        );

        // Verify API was not called
        verifyNever(() => mockUserApiService.createUser(any()));
      });
    });

    group('Remove User', () {
      test('should remove user successfully', () async {
        // Arrange
        const userId = '1';
        final mockUser = MockSetupHelper.createMockApiUser(id: userId);

        // Add user first
        when(
          () => mockUserApiService.getUsers(),
        ).thenAnswer((_) async => [mockUser]);
        await userProvider.loadUsers();
        expect(userProvider.apiUsers.length, equals(1));

        // Setup delete mock
        when(
          () => mockUserApiService.deleteUser(userId),
        ).thenAnswer((_) async {});

        // Act
        await userProvider.removeUser(userId);

        // Assert
        expect(userProvider.apiUsers, isEmpty);
        expect(userProvider.users, isEmpty);
        expect(userProvider.hasError, isFalse);

        // Verify API was called
        verify(() => mockUserApiService.deleteUser(userId)).called(1);
      });
    });

    group('Clear Error', () {
      test('should clear error message', () async {
        // Arrange - create an error first
        when(
          () => mockUserApiService.getUsers(),
        ).thenThrow(const NetworkException(message: 'Network error'));
        await userProvider.loadUsers();
        expect(userProvider.hasError, isTrue);

        // Act
        userProvider.clearError();

        // Assert
        expect(userProvider.hasError, isFalse);
        expect(userProvider.errorMessage, isNull);
      });
    });
  });
}

// Mock AuthService for testing
class MockAuthService extends Mock implements AuthService {}
