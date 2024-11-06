import 'package:bazar_books_design/constants.dart';
import 'package:bazar_books_design/core/models/auth_model/user.dart';
import 'package:bazar_books_design/core/network/error_handler.dart';
import 'package:dio/dio.dart';

import 'isar_service.dart';

class UserService {
  final IsarService isarService;
  final Dio _dio;

  UserService(this._dio, {required this.isarService});

  Future<bool> logIn(String email, String password) async {
    try {
      final response = await _dio.get('${Constants.apiUrlUser}user');
      if (response.statusCode == 200) {
        final List users = response.data;

        for (var userJson in users) {
          if (userJson['email'] == email && userJson['password'] == password) {
            final user = User.fromJson(userJson);
            user.isLoggedIn = true;

            await isarService.saveUser(user);
            return true;
          }
        }
      }
      return false;
    } catch (e) {
      throw ErrorHandler.handle(e).failure;
    }
  }

  Future<bool> isLoggedIn() async {
    return await isarService.isLoggedIn();
  }

  Future<void> logout() async {
    await isarService.logout();
  }

  Future<User?> getCurrentUser() async {
    return await isarService.getUser();
  }
}
