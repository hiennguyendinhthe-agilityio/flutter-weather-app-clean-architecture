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
  Rx<bool> isLoading = false.obs;

  final AuthStorageService _authStorage = AuthStorageService();

  LoginController();

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
          );
          Get.offAllNamed(
            Routes.home,
          );
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
}
