import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:bazar_books_design/core/models/auth_model/api_user.dart';
import 'package:dio/dio.dart';

abstract class AuthRepository {
  Future<ApiUser?> signIn(String email, String password);

  Future<bool> signUp(String name, String email, String password);

  Future<bool> isLoggedIn();

  Future<ApiUser?> getCurrentUser();
}

class AuthRepositoryImpl implements AuthRepository {
  final ApiService apiService;
  final IsarService isarService;

  AuthRepositoryImpl(this.apiService, {required this.isarService});

  @override
  Future<ApiUser?> signIn(String email, String password) async {
    try {
      final existingIsarUser = await isarService.getLoggedInUser();
      if (existingIsarUser != null) {
        return existingIsarUser.toApiUser();
      }

      final userApi = await apiService.logIn(email, password);
      if (userApi != null) {
        userApi.isLoggedIn = true;

        final userIsar = userApi.toIsarUser();
        await isarService.saveUser(userIsar);

        return userApi;
      }

      return null;
    } catch (e) {
      throw ErrorHandler.handle(e).failure;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      final user = await isarService.getLoggedInUser();
      return user != null && user.isLoggedIn;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<ApiUser?> getCurrentUser() async {
    final userIsar = await isarService.getLoggedInUser();
    return userIsar?.toApiUser();
  }

  Future<void> logOut() async {
    await isarService.logoutUser();
  }

  Future<void> saveUser(ApiUser userApi) async {
    final userIsar = userApi.toIsarUser();
    await isarService.saveUser(userIsar);
  }

  Future<bool> isEmailDuplicateFromAPI(String email) async {
    return await apiService.isEmailExist(email);
  }

  @override
  Future<bool> signUp(String name, String email, String password) async {
    try {
      final response = await apiService.signUp(name, email, password);

      if (response != null) {
        final userApi = ApiUser(
          name: name,
          email: email,
          password: password,
          isLoggedIn: true,
        );

        final userIsar = userApi.toIsarUser();
        await isarService.saveUser(userIsar);
      }
      return response != null;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e).failure;
    }
  }
}
