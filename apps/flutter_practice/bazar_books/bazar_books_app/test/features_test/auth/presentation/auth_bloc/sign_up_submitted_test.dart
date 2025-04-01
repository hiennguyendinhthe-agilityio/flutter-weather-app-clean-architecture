import 'package:bazar_books_app/features/auth/blocs/auth_bloc.dart';
import 'package:bazar_books_design/core/core.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../auth_mocks.dart';

void main() {
  late AuthBloc authBloc;
  late MockAuthRepositoryImpl mockAuthRepository;
  late MockLocalAuth mockLocalAuth;
  setUpAll(() {
    registerFallbackValue(
      AuthMocks.getMockCurrentUser,
    );
  });
  setUp(() {
    mockAuthRepository = MockAuthRepositoryImpl();
    mockLocalAuth = MockLocalAuth();
    authBloc = AuthBloc(mockAuthRepository, mockLocalAuth);
  });

  tearDown(() {
    authBloc.close();
  });

  group('SignUpSubmitted successful', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthenticationLoading, Authenticated] when sign-up is fails',
      build: () {
        when(() => mockAuthRepository.isEmailDuplicateFromAPI(
            AuthMocks.getMockEmail)).thenAnswer((_) async => false);
        when(() => mockAuthRepository.signUp(
              AuthMocks.getMockName,
              AuthMocks.getMockEmail,
              AuthMocks.getMockPassword,
            )).thenAnswer((_) async => true);
        when(() => mockAuthRepository.saveUser(AuthMocks.getMockApiUser))
            .thenAnswer((_) async {});
        return authBloc;
      },
      act: (bloc) => bloc.add(SignUpSubmitted(
        AuthMocks.getMockName,
        AuthMocks.getMockEmail,
        AuthMocks.getMockPassword,
      )),
      expect: () => [
        AuthenticationLoading(),
        SignUpFailure('Email already exists, please check again!'),
      ],
    );
  });

  group('SignUpSubmitted failed', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthenticationLoading, SignUpFailure] when sign-up is duplicate',
      build: () {
        when(() => mockAuthRepository.isEmailDuplicateFromAPI(
            AuthMocks.getMockEmail)).thenAnswer((_) async => true);
        when(() => mockAuthRepository.signUp(
              AuthMocks.getMockName,
              AuthMocks.getMockEmail,
              AuthMocks.getMockPassword,
            )).thenAnswer((_) async => true);
        when(() => mockAuthRepository.saveUser(AuthMocks.getMockApiUser))
            .thenAnswer((_) async {});
        return authBloc;
      },
      act: (bloc) => bloc.add(SignUpSubmitted(
        AuthMocks.getMockName,
        AuthMocks.getMockEmail,
        AuthMocks.getMockPassword,
      )),
      expect: () => [
        AuthenticationLoading(),
        SignUpFailure('Email already exists, please check again!'),
      ],
    );
    blocTest<AuthBloc, AuthState>(
      'emits SignUpFailure when sign-up fails',
      setUp: () {
        when(() => mockAuthRepository.isEmailDuplicateFromAPI(
              AuthMocks.getMockEmail,
            )).thenAnswer((_) async => false);
        when(() => mockAuthRepository.signUp(
              AuthMocks.getMockName,
              AuthMocks.getMockEmail,
              AuthMocks.getMockPassword,
            )).thenThrow(
          Failure(ResponseCode.BAD_REQUEST, message: 'Sign up failed'),
        );
      },
      build: () => authBloc,
      act: (bloc) => bloc.add(SignUpSubmitted(AuthMocks.getMockName,
          AuthMocks.getMockEmail, AuthMocks.getMockPassword)),
      expect: () => [
        AuthenticationLoading(),
        SignUpFailure('Sign up failed'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits AuthenticationFailure when an error occurs',
      setUp: () {
        when(() => mockAuthRepository.isEmailDuplicateFromAPI(
              AuthMocks.getMockEmail,
            )).thenAnswer((_) async => false);
        when(() => mockAuthRepository.signUp(AuthMocks.getMockName,
                AuthMocks.getMockEmail, AuthMocks.getMockPassword))
            .thenThrow(
                Failure(ResponseCode.BAD_REQUEST, message: 'Default error'));
      },
      build: () => authBloc,
      act: (bloc) => bloc.add(SignUpSubmitted(AuthMocks.getMockName,
          AuthMocks.getMockEmail, AuthMocks.getMockPassword)),
      expect: () => [
        AuthenticationLoading(),
        SignUpFailure('Default error'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits SignUpFailure when Timeout error is thrown',
      build: () {
        when(() => mockAuthRepository.isEmailDuplicateFromAPI(
              AuthMocks.getMockEmail,
            )).thenAnswer((_) async => false);
        when(() => mockAuthRepository.signUp(any(), any(), any()))
            .thenThrow(Failure(
          ResponseCode.BAD_REQUEST,
          message: "Timeout in connection with API server",
        ));
        return authBloc;
      },
      act: (bloc) => bloc.add(SignUpSubmitted(
        AuthMocks.getMockName,
        AuthMocks.getMockEmail,
        AuthMocks.getMockPassword,
      )),
      expect: () => [
        AuthenticationLoading(),
        SignUpFailure("Timeout in connection with API server"),
      ],
    );
    blocTest<AuthBloc, AuthState>(
      'emits SignUpFailure when SendTimeout error is thrown',
      build: () {
        when(() => mockAuthRepository.isEmailDuplicateFromAPI(
              AuthMocks.getMockEmail,
            )).thenAnswer((_) async => false);
        when(() => mockAuthRepository.signUp(any(), any(), any())).thenThrow(
          Failure(
            ResponseCode.BAD_REQUEST,
            message: "Send timeout in connection with API server",
          ),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(SignUpSubmitted(
        AuthMocks.getMockName,
        AuthMocks.getMockEmail,
        AuthMocks.getMockPassword,
      )),
      expect: () => [
        AuthenticationLoading(),
        SignUpFailure("Send timeout in connection with API server"),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits SignUpFailure when NOT_FOUND error is thrown',
      build: () {
        when(() => mockAuthRepository.isEmailDuplicateFromAPI(
              AuthMocks.getMockEmail,
            )).thenAnswer((_) async => false);
        when(() => mockAuthRepository.signUp(any(), any(), any())).thenThrow(
          Failure(
            ResponseCode.BAD_REQUEST,
            message: "Request was cancelled.",
          ),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(SignUpSubmitted(
        AuthMocks.getMockName,
        AuthMocks.getMockEmail,
        AuthMocks.getMockPassword,
      )),
      expect: () => [
        AuthenticationLoading(),
        SignUpFailure("Request was cancelled."),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits SignUpFailure when badResponse error is thrown',
      build: () {
        when(() => mockAuthRepository.isEmailDuplicateFromAPI(
              AuthMocks.getMockEmail,
            )).thenAnswer((_) async => false);
        when(() => mockAuthRepository.signUp(any(), any(), any())).thenThrow(
          Failure(
            ResponseCode.BAD_REQUEST,
            message: "Invalid response received from server.",
          ),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(SignUpSubmitted(
        AuthMocks.getMockName,
        AuthMocks.getMockEmail,
        AuthMocks.getMockPassword,
      )),
      expect: () => [
        AuthenticationLoading(),
        SignUpFailure("Invalid response received from server."),
      ],
    );
  });
}
