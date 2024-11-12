import 'package:bazar_books_app/features/auth/data/auth_repository_impl.dart';
import 'package:bazar_books_design/core/network/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../auth_mocks.dart';

void main() {
  late AuthRepositoryImpl authRepository;
  late MockApiService mockApiService;
  late MockIsarService mockIsarService;

  setUp(() {
    mockApiService = MockApiService();
    mockIsarService = MockIsarService();
    authRepository =
        AuthRepositoryImpl(mockApiService, isarService: mockIsarService);
  });

  group('AuthRepositoryImpl - logIn', () {
    test('Should return a User when login is successful', () async {
      when(() => mockApiService.logIn(
              AuthMocks.getMockEmail, AuthMocks.getMockPassword))
          .thenAnswer((_) => Future.value(AuthMocks.getMockCurrentUser));

      when(() => mockIsarService.saveUser(AuthMocks.getMockCurrentUser))
          .thenAnswer((_) async {
        return;
      });

      final result = await authRepository.logIn(
          AuthMocks.getMockEmail, AuthMocks.getMockPassword);

      expect(result, isNotNull);
      expect(result, AuthMocks.getMockCurrentUser);
      expect(result!.isLoggedIn, true);

      verify(() => mockApiService.logIn(
          AuthMocks.getMockEmail, AuthMocks.getMockPassword)).called(1);
      verify(() => mockIsarService.saveUser(AuthMocks.getMockCurrentUser))
          .called(1);
    });

    test('Should return null when apiService.logIn returns null', () async {
      when(() => mockApiService.logIn(
              AuthMocks.getMockEmail, AuthMocks.getMockPassword))
          .thenAnswer((_) async => null);

      final result = await authRepository.logIn(
          AuthMocks.getMockEmail, AuthMocks.getMockPassword);

      expect(result, isNull);

      verify(() => mockApiService.logIn(
          AuthMocks.getMockEmail, AuthMocks.getMockPassword)).called(1);
      verifyNever(() => mockIsarService.saveUser(AuthMocks.getMockCurrentUser));
    });

    test('Handling exceptions when API encounters errors', () async {
      when(() => mockApiService.logIn(
              AuthMocks.getMockEmail, AuthMocks.getMockPassword))
          .thenThrow(AuthMocks.failureMock);

      await expectLater(
        authRepository.logIn(AuthMocks.getMockEmail, AuthMocks.getMockPassword),
        throwsA(isA<Failure>()),
      );

      verifyNever(() => mockIsarService.saveUser(AuthMocks.getMockCurrentUser));
    });
  });
}
