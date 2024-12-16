import 'package:bazar_books_app/features/auth/blocs/auth_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../auth_mocks.dart';

void main() {
  group('AuthEvent', () {
    test('LogInRequested event should initialize correctly', () {
      final event =
          LogInRequested(AuthMocks.getMockEmail, AuthMocks.getMockPassword);

      expect(event.email, AuthMocks.getMockEmail);
      expect(event.password, AuthMocks.getMockPassword);

      expect(event.props, [AuthMocks.getMockEmail, AuthMocks.getMockPassword]);
    });

    test('SignUpSubmitted event should initialize correctly', () {
      final event = SignUpSubmitted(AuthMocks.getMockName,
          AuthMocks.getMockEmail, AuthMocks.getMockPassword);

      expect(event.name, AuthMocks.getMockName);
      expect(event.email, AuthMocks.getMockEmail);
      expect(event.password, AuthMocks.getMockPassword);

      expect(event.props, [
        AuthMocks.getMockName,
        AuthMocks.getMockEmail,
        AuthMocks.getMockPassword
      ]);
    });

    test('PasswordValidationChanged event should initialize correctly', () {
      final event = PasswordValidationChanged(AuthMocks.getMockPassword);

      expect(event.password, AuthMocks.getMockPassword);

      expect(event.props, [AuthMocks.getMockPassword]);
    });

    test('TogglePasswordVisibilityEvent should not have any props', () {
      final event = TogglePasswordVisibilityEvent();

      expect(event.props, []);
    });
  });
}
