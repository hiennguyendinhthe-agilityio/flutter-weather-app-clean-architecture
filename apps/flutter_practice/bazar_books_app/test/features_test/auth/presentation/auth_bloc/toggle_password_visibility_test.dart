import 'package:bazar_books_app/features/auth/blocs/auth_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

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

  group('AppStarted', () {
    // Test TogglePasswordVisibilityEvent
    blocTest<AuthBloc, AuthState>(
      'emits [PasswordVisibilityChanged] when TogglePasswordVisibilityEvent is added',
      build: () => authBloc,
      act: (bloc) => bloc.add(TogglePasswordVisibilityEvent()),
      expect: () => [PasswordVisibilityChanged(false)],
    );

    // Test case: Initializes PasswordVisibilityChanged state if not in this state already
    blocTest<AuthBloc, AuthState>(
      'emits [PasswordVisibilityChanged(false)] when PasswordVisibilityChanged state does not exist',
      build: () => authBloc,
      act: (bloc) => bloc.add(TogglePasswordVisibilityEvent()),
      expect: () => [
        PasswordVisibilityChanged(false)
      ], // Sets initial state to not hidden
    );
  });
}
