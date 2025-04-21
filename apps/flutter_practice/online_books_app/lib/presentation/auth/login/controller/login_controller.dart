import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:online_books_app/data/models/auth_model/api_user.dart';
import 'package:online_books_app/presentation/auth/service/auth_service.dart';
import 'package:online_books_app/presentation/auth/service/auth_storage_service.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  LocalAuthentication get localAuth => _localAuth;
  final LocalAuthentication _localAuth = LocalAuthentication();
  final formKey = GlobalKey<FormState>();
  Rx<bool> isShowPassword = true.obs;
  Rx<bool> isRememberMe = false.obs;
  Rx<bool> isLoading = false.obs;

  // Error states
  final RxString emailError = RxString('');
  final RxString passwordError = RxString('');

  final AuthStorageService _authStorage = AuthStorageService();
  final RxBool _biometricEnabled = false.obs;
  bool get biometricEnabled => _biometricEnabled.value;

  final RxBool _isBiometricSupported = false.obs;
  bool get isBiometricSupported => _isBiometricSupported.value;

  LoginController();

  // Validate email input
  bool validateEmail(String value) {
    emailError.value = '';

    if (value.isEmpty) {
      emailError.value = 'Required';
      return false;
    }

    if (!GetUtils.isEmail(value)) {
      emailError.value = 'Invalid email format';
      return false;
    }

    return true;
  }

  // Validate password input
  bool validatePassword(String value) {
    passwordError.value = '';

    if (value.isEmpty) {
      passwordError.value = 'Required';
      return false;
    }

    if (value.length < 8) {
      passwordError.value = 'Password must be at least 8 characters';
      return false;
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      passwordError.value =
          'Password must contain at least one lowercase letter';
      return false;
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      passwordError.value = 'Password must contain at least one number';
      return false;
    }

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      passwordError.value =
          'Password must contain at least one special character';
      return false;
    }

    return true;
  }

  // Computed property to check if all fields are valid
  bool get isFormValid {
    return emailController.text.isNotEmpty &&
        GetUtils.isEmail(emailController.text) &&
        passwordController.text.isNotEmpty;
  }

  @override
  void onInit() {
    super.onInit();
    checkBiometricStatus();
    _loadSavedCredentials();
    _checkBiometricSupport();
  }

  Future<void> _checkBiometricSupport() async {
    try {
      _isBiometricSupported.value = await _localAuth.isDeviceSupported();
    } catch (e) {
      _isBiometricSupported.value = false;
      debugPrint('Error checking biometric support: $e');
    }
  }

  Future<void> _loadSavedCredentials() async {
    final credentials = await _authStorage.getSavedCredentials();
    if (credentials['email'] != null && credentials['password'] != null) {
      emailController.text = credentials['email']!;
      passwordController.text = credentials['password']!;
      isRememberMe.value = credentials['isRememberMe']!;
      _biometricEnabled.value = credentials['biometricEnabled']!;
    }
  }

  Future<void> toggleBiometric(bool value) async {
    _biometricEnabled.value = value;
    if (isRememberMe.value) {
      await _authStorage.saveLoginCredentials(
        email: emailController.text,
        password: passwordController.text,
        isRememberMe: isRememberMe.value,
        biometricEnabled: value,
      );
    }
  }

  Future<void> checkBiometricStatus() async {
    final credentials = await _authStorage.getSavedCredentials();
    _biometricEnabled.value = credentials['biometricEnabled']!;
  }

  Future<bool> authenticateWithBiometrics() async {
    try {
      if (!_isBiometricSupported.value) return false;

      return await _localAuth.authenticate(
        localizedReason: 'Authenticate to login',
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
        ),
      );
    } catch (e) {
      debugPrint('Biometric error: $e');
      return false;
    }
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      ApiUser? user = await AuthService()
          .logIn(emailController.text, passwordController.text);

      if (user != null) {
        await _authStorage.saveLoginCredentials(
          email: emailController.text,
          password: passwordController.text,
          isRememberMe: isRememberMe.value,
          biometricEnabled: _biometricEnabled.value,
        );

        Get.offAllNamed('/home_initial_page');
      } else {
        Get.snackbar("Error", "Invalid credentials");
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Login failed: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _authStorage.clearSavedCredentials();
    isRememberMe.value = false;
    _biometricEnabled.value = false;
    emailController.clear();
    passwordController.clear();
  }
}
