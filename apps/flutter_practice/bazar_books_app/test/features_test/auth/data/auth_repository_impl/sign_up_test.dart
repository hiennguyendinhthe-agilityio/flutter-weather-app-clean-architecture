import 'package:bazar_books_app/features/auth/data/auth_repository_impl.dart';
import 'package:bazar_books_design/core/network/error_handler.dart';
import 'package:bazar_books_design/core/network/failure.dart';
import 'package:dio/dio.dart';
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
    group('SignUp success', () {
      test('should save user when sign up is successful', () async {
        // Arrange

        when(() => authRepository.isEmailDuplicateFromAPI(
              AuthMocks.getMockEmail,
            )).thenAnswer((_) async => false);
        when(() => mockApiService.signUp(
            AuthMocks.getMockName,
            AuthMocks.getMockEmail,
            AuthMocks.getMockPassword)).thenAnswer((_) async => true);

        // Act
        final result = await mockApiService.signUp(AuthMocks.getMockName,
            AuthMocks.getMockEmail, AuthMocks.getMockPassword);

        // Assert
        expect(result, true);
      });
    });
    group('SignUp fails', () {
      test('Returns false when sign-up fails', () async {
        when(() => authRepository.isEmailDuplicateFromAPI(
              AuthMocks.getMockEmail,
            )).thenAnswer((_) async => false);
        when(() => mockApiService.signUp(
              AuthMocks.getMockName,
              AuthMocks.getMockEmail,
              AuthMocks.getMockPassword,
            )).thenAnswer((_) async => false);

        final result = await authRepository.signUp(AuthMocks.getMockName,
            AuthMocks.getMockEmail, AuthMocks.getMockPassword);

        expect(result, isFalse);

        verify(() => mockApiService.signUp(AuthMocks.getMockName,
            AuthMocks.getMockEmail, AuthMocks.getMockPassword)).called(1);
      });

      test('signUp should return false when the email is empty', () async {
        when(() => authRepository.isEmailDuplicateFromAPI(
              AuthMocks.getMockEmail,
            )).thenAnswer((_) async => false);
        // Arrange
        when(() => mockApiService.signUp(
              AuthMocks.getMockName,
              AuthMocks.getMockEmpty,
              AuthMocks.getMockPassword,
            )).thenAnswer((_) async => false);

        // Act
        final result = await mockApiService.signUp(
          AuthMocks.getMockName,
          AuthMocks.getMockEmpty,
          AuthMocks.getMockPassword,
        );

        // Assert
        expect(result, false);
      });

      test('signUp should return false when the password is empty', () async {
        when(() => authRepository.isEmailDuplicateFromAPI(
              AuthMocks.getMockEmail,
            )).thenAnswer((_) async => false);
        // Arrange
        when(() => mockApiService.signUp(
              AuthMocks.getMockName,
              AuthMocks.getMockEmail,
              AuthMocks.getMockEmpty,
            )).thenAnswer((_) async => false);

        // Act
        final result = await mockApiService.signUp(
          AuthMocks.getMockName,
          AuthMocks.getMockEmail,
          AuthMocks.getMockEmpty,
        );

        // Assert
        expect(result, false);
      });

      test('signUp should return false when the email and password are empty',
          () async {
        when(() => authRepository.isEmailDuplicateFromAPI(
              AuthMocks.getMockEmail,
            )).thenAnswer((_) async => false);
        // Arrange
        when(() => mockApiService.signUp(
              AuthMocks.getMockName,
              AuthMocks.getMockEmpty,
              AuthMocks.getMockEmpty,
            )).thenAnswer((_) async => false);

        // Act
        final result = await mockApiService.signUp(AuthMocks.getMockName,
            AuthMocks.getMockEmpty, AuthMocks.getMockEmpty);

        // Assert
        expect(result, false);
      });

      test(
          'should throw Error when DioException occurs during email duplicate check',
          () async {
        when(() => authRepository.isEmailDuplicateFromAPI(
              AuthMocks.getMockEmail,
            )).thenThrow(AuthMocks.dioExceptionMock);

        expect(
          () async => await authRepository.signUp(
            AuthMocks.getMockName,
            AuthMocks.getMockEmail,
            AuthMocks.getMockPassword,
          ),
          throwsA(isA<Failure>()),
        );
        verify(() => authRepository.isEmailDuplicateFromAPI(
              AuthMocks.getMockEmail,
            )).called(1);
        verifyNever(() => mockApiService.signUp(
              AuthMocks.getMockName,
              AuthMocks.getMockEmail,
              AuthMocks.getMockPassword,
            ));
      });

      test('throws Failure when API returns 404 for resource not found',
          () async {
        when(() => authRepository.isEmailDuplicateFromAPI(
              AuthMocks.getMockEmail,
            )).thenAnswer((_) async => true);

        when(() => mockApiService.signUp(any(), any(), any()))
            .thenThrow(DioException(
          requestOptions: RequestOptions(),
          response: Response(
            statusCode: 404,
            statusMessage: 'Not Found',
            requestOptions: RequestOptions(),
          ),
        ));

        expect(
          () async => await authRepository.signUp(
            AuthMocks.getMockName,
            AuthMocks.getMockEmail,
            AuthMocks.getMockPassword,
          ),
          throwsA(isA<Failure>()),
        );
      });

      test('Throws Failure when API returns 400 for invalid data format',
          () async {
        when(() => authRepository.isEmailDuplicateFromAPI(
              AuthMocks.getMockEmail,
            )).thenAnswer((_) async => true);

        when(() => mockApiService.signUp(any(), any(), any()))
            .thenThrow(DioException(
          requestOptions: RequestOptions(),
          response: Response(
            statusCode: 400,
            statusMessage: 'API rejected request',
            requestOptions: RequestOptions(),
          ),
        ));

        expect(
          authRepository.signUp(
            AuthMocks.getMockName,
            AuthMocks.getMockEmail,
            AuthMocks.getMockPassword,
          ),
          throwsA(isA<Failure>()),
        );
      });

      test('Throws Failure when there is no internet connection', () async {
        when(() => authRepository.isEmailDuplicateFromAPI(
              AuthMocks.getMockEmail,
            )).thenAnswer((_) async => true);
        when(() => mockApiService.signUp(any(), any(), any()))
            .thenThrow(Failure(
          ResponseCode.NO_INTERNET_CONNECTION,
          message: 'No internet connection',
        ));

        expect(
          authRepository.signUp(
            AuthMocks.getMockName,
            AuthMocks.getMockEmail,
            AuthMocks.getMockPassword,
          ),
          throwsA(isA<Failure>()),
        );
      });
    });
  });
}
