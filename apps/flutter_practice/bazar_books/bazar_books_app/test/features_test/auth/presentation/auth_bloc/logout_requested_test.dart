import 'package:bazar_books_app/features/auth/blocs/auth_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../auth_mocks.dart';

void main() {
  late AuthBloc authBloc;
  late MockAuthRepositoryImpl mockAuthRepository;
  late MockLocalAuth mockLocalAuth;

  setUp(() {
    mockAuthRepository = MockAuthRepositoryImpl();
    mockLocalAuth = MockLocalAuth();
    authBloc = AuthBloc(mockAuthRepository, mockLocalAuth);
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc', () {
    // Test LogoutRequested event
    blocTest<AuthBloc, AuthState>(
      'emits [AuthenticationLoading, Unauthenticated] when LogoutRequested is added',
      setUp: () {
        when(() => mockAuthRepository.logOut()).thenAnswer((_) async {
          return;
        });
      },
      build: () => authBloc,
      act: (bloc) => bloc.add(LogoutRequested()),
      expect: () => [AuthenticationLoading(), Unauthenticated()],
    );
  });
}
