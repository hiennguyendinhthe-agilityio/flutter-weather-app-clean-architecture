import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pratice_improve_flutter_form_builder/config/routes/app_pages.dart';
import 'package:pratice_improve_flutter_form_builder/data/models/auth_model/api_user.dart';
import 'package:pratice_improve_flutter_form_builder/service/auth_service.dart';
import 'package:pratice_improve_flutter_form_builder/service/auth_storage_service.dart';

class LoginController extends GetxController {
  LocalAuthentication get localAuth => _localAuth;
  final LocalAuthentication _localAuth = LocalAuthentication();
  final formKey = GlobalKey<FormBuilderState>();
  Rx<bool> isShowPassword = true.obs;
  Rx<bool> isRememberMe = false.obs;
  Rx<bool> isLoading = false.obs;

  final AuthStorageService _authStorage = AuthStorageService();
  final RxBool _biometricEnabled = false.obs;
  bool get biometricEnabled => _biometricEnabled.value;

  final RxBool _isBiometricSupported = false.obs;
  bool get isBiometricSupported => _isBiometricSupported.value;

  LoginController();

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
      isRememberMe.value = credentials['isRememberMe'] ?? false;
      _biometricEnabled.value = credentials['biometricEnabled'] ?? false;
    }
  }

  Future<void> toggleBiometric(bool value) async {
    _biometricEnabled.value = value;
    if (isRememberMe.value && formKey.currentState != null) {
      if (formKey.currentState!.saveAndValidate()) {
        final currentEmail = formKey.currentState!.value['email'];
        final currentPassword = formKey.currentState!.value['password'];
        await _authStorage.saveLoginCredentials(
          email: currentEmail,
          password: currentPassword,
          isRememberMe: isRememberMe.value,
          biometricEnabled: value,
        );
      }
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
    if (formKey.currentState == null) {
      Get.snackbar(
        "Error",
        "Form key is null. Please check your form setup.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (formKey.currentState!.saveAndValidate()) {
      isLoading.value = true;
      try {
        final formData = formKey.currentState!.value;
        final email = formData['email'] as String?;
        final password = formData['password'] as String?;

        if (email == null || password == null) {
          Get.snackbar(
            "Error",
            "Email or password is null.",
            snackPosition: SnackPosition.BOTTOM,
          );
          isLoading.value = false;
          return;
        }

        ApiUser? user = await AuthService().logIn(email, password);

        if (user != null) {
          await _authStorage.saveLoginCredentials(
            email: email,
            password: password,
            isRememberMe: isRememberMe.value,
            biometricEnabled: _biometricEnabled.value,
          );
          Get.offAllNamed(Routes.home);
        } else {
          Get.snackbar("Error", "Login failed.",
              snackPosition: SnackPosition.BOTTOM);
        }
      } catch (e) {
        Get.snackbar(
          "Error",
          "Login failed: ${e.toString()}",
          snackPosition: SnackPosition.BOTTOM,
        );
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.snackbar("Error", "Form is invalid",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> logout() async {
    await _authStorage.clearSavedCredentials();
    isRememberMe.value = false;
    _biometricEnabled.value = false;

    Get.offAllNamed(Routes.login);
  }
}
