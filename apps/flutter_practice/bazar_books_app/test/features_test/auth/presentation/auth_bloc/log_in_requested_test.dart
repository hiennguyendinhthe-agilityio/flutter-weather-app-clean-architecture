import 'package:bazar_books_app/features/auth/blocs/auth_bloc.dart';
import 'package:bazar_books_design/core/network/failure.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../auth_mocks.dart';

void main() {
  late AuthBloc authBloc;
  late MockAuthRepositoryImpl mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepositoryImpl();
    authBloc = AuthBloc(mockAuthRepository);
  });

  tearDown(() {
    authBloc.close();
  });

  group('LogInRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthenticationLoading, AuthenticationSuccess] when login is successful',
      setUp: () {
        when(() => mockAuthRepository.signIn(
                AuthMocks.getMockEmail, AuthMocks.getMockPassword))
            .thenAnswer((_) async => AuthMocks.getMockApiUser);
      },
      build: () => authBloc,
      act: (bloc) => bloc.add(
          LogInRequested(AuthMocks.getMockEmail, AuthMocks.getMockPassword)),
      expect: () =>
          [AuthenticationLoading(), Authenticated(AuthMocks.getMockApiUser)],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthenticationLoading, AuthenticationFailure] when login fails',
      setUp: () {
        when(() => mockAuthRepository.signIn(
                AuthMocks.getMockEmail, AuthMocks.getMockPassword))
            .thenAnswer((_) async => null);
      },
      build: () => authBloc,
      act: (bloc) => bloc.add(
          LogInRequested(AuthMocks.getMockEmail, AuthMocks.getMockPassword)),
      expect: () => [
        AuthenticationLoading(),
        AuthenticationFailure('Invalid email or password')
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthenticationLoading, AuthenticationFailure] when an error occurs',
      setUp: () {
        when(() => mockAuthRepository.signIn(
                AuthMocks.getMockEmail, AuthMocks.getMockPassword))
            .thenThrow(DioException(
                requestOptions: RequestOptions(),
                response: Response(
                  statusMessage: 'Invalid email or password',
                  data: Failure(501, message: 'Invalid email or password'),
                  statusCode: 501,
                  requestOptions: RequestOptions(),
                )));
      },
      build: () => authBloc,
      act: (bloc) => bloc.add(
          LogInRequested(AuthMocks.getMockEmail, AuthMocks.getMockPassword)),
      expect: () => [
        AuthenticationLoading(),
        AuthenticationFailure('Invalid email or password.')
      ],
    );
  });
}
