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

  group('signUp', () {
    test('Returns true when sign-up is successful', () async {
      when(() => mockApiService.signUp(
          AuthMocks.getMockName,
          AuthMocks.getMockEmail,
          AuthMocks.getMockPassword)).thenAnswer((_) async => true);

      final result = await authRepository.signUp(AuthMocks.getMockName,
          AuthMocks.getMockEmail, AuthMocks.getMockPassword);

      expect(result, isTrue);

      verify(() => mockApiService.signUp(AuthMocks.getMockName,
          AuthMocks.getMockEmail, AuthMocks.getMockPassword)).called(1);
    });

    test('Returns false when sign-up fails', () async {
      when(() => mockApiService.signUp(
          AuthMocks.getMockName,
          AuthMocks.getMockEmail,
          AuthMocks.getMockPassword)).thenAnswer((_) async => false);

      final result = await authRepository.signUp(AuthMocks.getMockName,
          AuthMocks.getMockEmail, AuthMocks.getMockPassword);

      expect(result, isFalse);

      verify(() => mockApiService.signUp(AuthMocks.getMockName,
          AuthMocks.getMockEmail, AuthMocks.getMockPassword)).called(1);
    });

    test('Throws Exception when signUp encounters an error', () async {
      when(() => mockApiService.signUp(
          AuthMocks.getMockName,
          AuthMocks.getMockEmail,
          AuthMocks.getMockPassword)).thenThrow(AuthMocks.failureMock);

      await expectLater(
        authRepository.signUp(AuthMocks.getMockName, AuthMocks.getMockEmail,
            AuthMocks.getMockPassword),
        throwsA(isA<Failure>()),
      );

      verify(() => mockApiService.signUp(AuthMocks.getMockName,
          AuthMocks.getMockEmail, AuthMocks.getMockPassword)).called(1);
    });
  });
}
