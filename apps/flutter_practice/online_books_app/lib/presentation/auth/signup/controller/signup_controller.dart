import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:online_books_app/data/constants/constants.dart';
import 'package:online_books_app/data/models/auth_model/api_user.dart';
import 'package:online_books_app/data/network/error_handler.dart';
import 'package:online_books_app/presentation/auth/signup/model/signup_model.dart';
import 'package:online_books_app/routes/app_routes.dart';

class SignupController extends GetxController {
  TextEditingController firstNameInputController = TextEditingController();
  TextEditingController lastNameInputController = TextEditingController();
  TextEditingController emailInputController = TextEditingController();
  TextEditingController dateOfBirthInputController = TextEditingController();
  TextEditingController passwordInputController = TextEditingController();

  final formKey = GlobalKey<FormBuilderState>();

  final Dio _dio = Dio();

  Rx<SignupModel> signupModelObj = SignupModel().obs;
  Rx<bool> isShowPassword = true.obs;
  Rx<bool> termAgreementCheckBox = false.obs;

  Rx<bool> isLoading = false.obs;

  Future<void> signUp() async {
    if (formKey.currentState == null || !formKey.currentState!.validate()) {
      return;
    }

    String firstName = firstNameInputController.text;
    String lastName = lastNameInputController.text;
    String email = emailInputController.text;
    String password = passwordInputController.text;

    String name = '$firstName $lastName';

    bool emailExists = await isEmailExist(email);
    if (emailExists) {
      Get.snackbar("Email already exists", "This email is already in use.");
      return;
    }

    isLoading.value = true;

    try {
      ApiUser? user = await signUpAPI(name, email, password);

      if (user != null) {
        Get.snackbar("Success", "Account created successfully!");
        Get.offAllNamed(AppRoutes.homeInitialPage);
      } else {
        Get.snackbar("Sign Up Failed", "Error creating account");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong. Please try again later.");
    } finally {
      isLoading.value = false;
    }
  }

  Future<ApiUser?> signUpAPI(String name, String email, String password) async {
    try {
      final response = await _dio.post(
        '${Constants.apiUrlUser}user',
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 201) {
        return ApiUser.fromJson(response.data);
      } else {
        throw DioException(
          response: response,
          requestOptions: response.requestOptions,
        );
      }
    } catch (e) {
      throw ErrorHandler.handle(e).failure;
    }
  }

  Future<bool> isEmailExist(String email) async {
    try {
      final response = await _dio.get(
        '${Constants.apiUrlUser}user?email=$email',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.isNotEmpty;
      }

      return false;
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 404) {
        return false;
      }
      throw ErrorHandler.handle(e).failure;
    }
  }
}
