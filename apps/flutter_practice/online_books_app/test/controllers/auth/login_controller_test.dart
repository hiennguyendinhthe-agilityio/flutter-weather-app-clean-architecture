import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:online_books_app/presentation/auth/login/controller/login_controller.dart';
import 'package:online_books_app/presentation/auth/service/auth_service.dart';
import 'package:online_books_app/presentation/auth/service/auth_storage_service.dart';

class MockAuthService extends Mock implements AuthService {}

class MockAuthStorageService extends Mock implements AuthStorageService {}

void main() {
  late LoginController loginController;
  late MockAuthService mockAuthService;
  late MockAuthStorageService mockAuthStorageService;

  setUp(() {
    mockAuthService = MockAuthService();
    mockAuthStorageService = MockAuthStorageService();
    loginController = LoginController();
  });

  group('LoginController Tests', () {
    test('validate empty email returns false', () {
      expect(loginController.validateEmail(''), false);
      expect(loginController.emailError.value, 'Required');
    });

    test('validate invalid email format returns false', () {
      expect(loginController.validateEmail('invalid-email'), false);
      expect(loginController.emailError.value, 'Invalid email format');
    });

    test('validate valid email returns true', () {
      expect(loginController.validateEmail('test@example.com'), true);
      expect(loginController.emailError.value, '');
    });

    test('validate empty password returns false', () {
      expect(loginController.validatePassword(''), false);
      expect(loginController.passwordError.value, 'Required');
    });

    test('validate password with less than 8 characters returns false', () {
      expect(loginController.validatePassword('abc123!'), false);
      expect(loginController.passwordError.value,
          'Password must be at least 8 characters');
    });

    test('validate password without lowercase letter returns false', () {
      expect(loginController.validatePassword('ABC123!@#'), false);
      expect(loginController.passwordError.value,
          'Password must contain at least one lowercase letter');
    });

    test('validate password without number returns false', () {
      expect(loginController.validatePassword('abcdef!@#'), false);
      expect(loginController.passwordError.value,
          'Password must contain at least one number');
    });

    test('validate password without special character returns false', () {
      expect(loginController.validatePassword('abcdef123'), false);
      expect(loginController.passwordError.value,
          'Password must contain at least one special character');
    });

    test('validate valid password returns true', () {
      expect(loginController.validatePassword('abcDEF123!@#'), true);
      expect(loginController.passwordError.value, '');
    });

    test('isFormValid returns false when fields are empty', () {
      loginController.emailController.text = '';
      loginController.passwordController.text = '';
      expect(loginController.isFormValid, false);
    });

    test('isFormValid returns true when fields are valid', () {
      loginController.emailController.text = 'test@example.com';
      loginController.passwordController.text = 'Password123!';
      expect(loginController.isFormValid, true);
    });

    test('toggleBiometric updates biometric state', () async {
      await loginController.toggleBiometric(true);
      expect(loginController.biometricEnabled, true);

      await loginController.toggleBiometric(false);
      expect(loginController.biometricEnabled, false);
    });
  });
}
