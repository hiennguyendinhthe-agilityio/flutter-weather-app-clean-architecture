import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:online_books_app/data/models/auth_model/api_user.dart';
import 'package:online_books_app/presentation/auth/service/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  LocalAuthentication get localAuth => _localAuth;
  final LocalAuthentication _localAuth = LocalAuthentication();
  final formKey = GlobalKey<FormBuilderState>();
  Rx<bool> isShowPassword = true.obs;
  Rx<bool> isRememberMe = false.obs;
  Rx<bool> isLoading = false.obs;

  LoginController();

  final RxBool _isAuthenticated = false.obs;
  final RxBool _biometricEnabled = false.obs;

  bool get isAuthenticated => _isAuthenticated.value;
  bool get biometricEnabled => _biometricEnabled.value;

  final RxBool _isBiometricSupported = false.obs;
  bool get isBiometricSupported => _isBiometricSupported.value;

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

  Future<void> clearSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('saved_email');
    await prefs.remove('saved_password');
    await prefs.setBool('biometric_enabled', false);
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('saved_email');
    final password = prefs.getString('saved_password');
    final biometricEnabled = prefs.getBool('biometric_enabled') ?? false;

    if (email != null && password != null) {
      emailController.text = email;
      passwordController.text = password;
      isRememberMe.value = true;
      _biometricEnabled.value = biometricEnabled;
    }
  }

  Future<void> toggleBiometric(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('biometric_enabled', value);
    _biometricEnabled.value = value;
  }

  Future<void> checkBiometricStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _biometricEnabled.value = prefs.getBool('biometric_enabled') ?? false;
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

  Future<void> loginWithCredentials(String email, String password) async {
    isLoading.value = true;
    try {
      ApiUser? user = await AuthService().logIn(email, password);
      if (user != null) {
        Get.offAllNamed('/home_initial_page');
      } else {
        Get.snackbar("Error", "Auto-login failed");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to auto-login: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      ApiUser? user = await AuthService()
          .logIn(emailController.text, passwordController.text);

      if (user != null) {
        final prefs = await SharedPreferences.getInstance();

        if (isRememberMe.value) {
          await prefs.setString('saved_email', emailController.text);
          await prefs.setString('saved_password', passwordController.text);
        } else {
          await prefs.remove('saved_email');
          await prefs.remove('saved_password');
          await prefs.setBool('biometric_enabled', false);
        }

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
}
