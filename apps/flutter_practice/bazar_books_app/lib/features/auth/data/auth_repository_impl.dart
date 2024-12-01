import 'package:bazar_books_app/features/auth/data/auth_repository.dart';
import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:dio/dio.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiService apiService;
  final IsarService isarService;

  AuthRepositoryImpl(this.apiService, {required this.isarService});

  @override
  Future<User?> logIn(String email, String password) async {
    try {
      final existingUser = await isarService.getLoggedInUser();
      if (existingUser != null) {
        return existingUser;
      }

      final user = await apiService.logIn(email, password);

      if (user != null) {
        user.isLoggedIn = true;

        final userInIsar = await isarService.getLoggedInUser();
        if (userInIsar == null) {
          await isarService.saveUser(user);
        }
      }

      return user;
    } catch (e) {
      throw ErrorHandler.handle(e).failure;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    final user = await isarService.getLoggedInUser();
    return user != null && user.isLoggedIn;
  }

  @override
  Future<User?> getCurrentUser() async {
    return await isarService.getLoggedInUser();
  }

  Future<void> logOut() async {
    await isarService.logoutUser();
  }

  Future<void> saveUser(User user) async {
    await isarService.saveUser(user);
  }

  Future<bool> isEmailDuplicateFromAPI(String email) async {
    return await apiService.isEmailExist(email);
  }

  @override
  Future<bool> signUp(String name, String email, String password) async {
    try {
      final response = await apiService.signUp(name, email, password);

      if (response) {
        final user = User(
          name: name,
          email: email,
          password: password,
          isLoggedIn: true,
        );

        await isarService.saveUser(user);
      }
      return response;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e).failure;
    }
  }
}
