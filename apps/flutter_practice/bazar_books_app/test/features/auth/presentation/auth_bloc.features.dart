import 'package:bazar_books_app/features/auth/blocs/auth_bloc.dart';
import 'package:bazar_books_app/features/auth/blocs/auth_event.dart';
import 'package:bazar_books_app/features/auth/blocs/auth_state.dart';

import '../../../helper/utils.dart';

class AuthBlocPasswordVisibilityToggledScenario
    extends BazBlocTestScenario<AuthBloc, AuthState> {
  AuthBlocPasswordVisibilityToggledScenario()
      : super(
          description: '''
          Scenario: Test AuthBloc when password visibility is toggled
            Given AuthBloc has state PasswordVisibilityChanged(isObscured: false)
            When TogglePasswordVisibilityEvent is added
            Then AuthBloc should emit PasswordVisibilityChanged with isObscured as true''',
          setUp: () => {},
          build: () => AuthBloc(),
          act: (bloc) => bloc.add(TogglePasswordVisibilityEvent()),
          expect: () => [
            PasswordVisibilityChanged(true),
          ],
        );
}
