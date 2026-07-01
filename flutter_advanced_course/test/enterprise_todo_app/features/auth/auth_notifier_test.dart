// test/enterprise_todo_app/features/auth/auth_notifier_test.dart
import 'package:flutter_advanced_course/enterprise_todo_app/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late ProviderContainer container;

  const mockUser = User(
    id: 1,
    username: 'admin',
    email: 'admin@enterprise.com',
    token: 'token',
    refreshToken: 'refresh',
  );

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(mockAuthRepository)],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('AuthNotifier', () {
    test(
      'build() - initial state is loading and then authenticated if user exists',
      () async {
        // Arrange
        when(
          () => mockAuthRepository.getAuthenticatedUser(),
        ).thenAnswer((_) async => mockUser);

        // Act
        final initialState = container.read(authProvider);

        // Assert
        expect(initialState.isLoading, isTrue);

        // Wait for _checkInitialAuth to complete
        await Future.delayed(const Duration(milliseconds: 50));

        final stateAfterCheck = container.read(authProvider);
        expect(stateAfterCheck.isLoading, isFalse);
        expect(stateAfterCheck.user, equals(mockUser));
      },
    );

    test(
      'build() - initial state is loading and then unauthenticated if user does not exist',
      () async {
        // Arrange
        when(
          () => mockAuthRepository.getAuthenticatedUser(),
        ).thenAnswer((_) async => null);

        // Act
        final initialState = container.read(authProvider);

        // Assert
        expect(initialState.isLoading, isTrue);

        // Wait for _checkInitialAuth to complete
        await Future.delayed(const Duration(milliseconds: 50));

        final stateAfterCheck = container.read(authProvider);
        expect(stateAfterCheck.isLoading, isFalse);
        expect(stateAfterCheck.user, isNull);
      },
    );

    test('login() - successful login updates state with user', () async {
      // Arrange
      when(
        () => mockAuthRepository.getAuthenticatedUser(),
      ).thenAnswer((_) async => null);
      when(
        () => mockAuthRepository.login('admin', 'password'),
      ).thenAnswer((_) async => mockUser);

      // Let build() finish
      await Future.delayed(const Duration(milliseconds: 50));

      // Act
      final notifier = container.read(authProvider.notifier);
      final result = await notifier.login('admin', 'password');

      // Assert
      expect(result, isTrue);
      final state = container.read(authProvider);
      expect(state.isLoading, isFalse);
      expect(state.user, equals(mockUser));
      expect(state.errorMessage, isNull);
    });

    test('login() - failed login updates state with error message', () async {
      // Arrange
      when(
        () => mockAuthRepository.getAuthenticatedUser(),
      ).thenAnswer((_) async => null);
      when(
        () => mockAuthRepository.login('admin', 'wrong_password'),
      ).thenAnswer((_) async => throw Exception('Invalid credentials'));

      // Let build() finish
      await Future.delayed(const Duration(milliseconds: 50));

      // Act
      final notifier = container.read(authProvider.notifier);
      final result = await notifier.login('admin', 'wrong_password');

      // Assert
      expect(result, isFalse);
      final state = container.read(authProvider);
      expect(state.isLoading, isFalse);
      expect(state.user, isNull);
      expect(state.errorMessage, equals('Invalid credentials'));
    });

    test('logout() - clears user state and calls repository logout', () async {
      // Arrange
      when(
        () => mockAuthRepository.getAuthenticatedUser(),
      ).thenAnswer((_) async => mockUser);
      when(() => mockAuthRepository.logout()).thenAnswer((_) async {});

      // Let build() finish
      await Future.delayed(const Duration(milliseconds: 50));

      // Act
      final notifier = container.read(authProvider.notifier);
      await notifier.logout();

      // Assert
      verify(() => mockAuthRepository.logout()).called(1);
      final state = container.read(authProvider);
      expect(state.isLoading, isFalse);
      expect(state.user, isNull);
    });

    test('updateAuthenticatedUser() - updates state with new user', () async {
      // Arrange
      when(
        () => mockAuthRepository.getAuthenticatedUser(),
      ).thenAnswer((_) async => null);

      // Let build() finish
      await Future.delayed(const Duration(milliseconds: 50));

      // Act
      final notifier = container.read(authProvider.notifier);
      notifier.updateAuthenticatedUser(mockUser);

      // Assert
      final state = container.read(authProvider);
      expect(state.user, equals(mockUser));
    });

    test(
      'forceLogout() - clears user state and calls repository logout',
      () async {
        // Arrange
        when(
          () => mockAuthRepository.getAuthenticatedUser(),
        ).thenAnswer((_) async => mockUser);
        when(() => mockAuthRepository.logout()).thenAnswer((_) async {});

        // Let build() finish
        await Future.delayed(const Duration(milliseconds: 50));

        // Act
        final notifier = container.read(authProvider.notifier);
        notifier.forceLogout();

        // Assert
        verify(() => mockAuthRepository.logout()).called(1);
        final state = container.read(authProvider);
        expect(state.isLoading, isFalse);
        expect(state.user, isNull);
      },
    );
  });
}
