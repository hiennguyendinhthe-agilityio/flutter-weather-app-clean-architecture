import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pratice_improve_flutter_form_builder/controllers/login_controller.dart';
import 'package:pratice_improve_flutter_form_builder/data/constants/constants.dart';
import 'package:pratice_improve_flutter_form_builder/data/models/auth_model/api_user.dart';
import 'package:pratice_improve_flutter_form_builder/data/network/error_handler.dart';

/// Initialize any authentication services here.
///
/// This method should be called before running the app.
///
/// Returns the same instance of [AuthService] that called this method.
class AuthService extends GetxService {
  final Dio _dio = Dio();
  Future<ApiUser?> logIn(String email, String password) async {
    try {
      final response = await _dio.get('${Constants.apiUrlUser}user');
      if (response.statusCode == 200) {
        final List users = response.data;
        for (var user in users) {
          if (user['email'] == email && user['password'] == password) {
            return ApiUser.fromJson(user);
          }
        }
      }
      return null;
    } catch (e) {
      debugPrint('API call failed: $e');
      throw ErrorHandler.handle(e).failure;
    }
  }

  Future<AuthService> init() async {
    // Initialize any authentication services here
    return this;
  }

  @override
  void onReady() {
    Get.put(LoginController());
    super.onReady();
  }
}
