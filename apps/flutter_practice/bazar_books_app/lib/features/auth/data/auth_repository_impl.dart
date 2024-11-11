import 'package:bazar_books_app/features/auth/data/auth_repository.dart';
import 'package:bazar_books_design/bazar_books_design.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiService apiService;
  final IsarService isarService;

  AuthRepositoryImpl(this.apiService, {required this.isarService});

  @override
  Future<User?> logIn(String email, String password) async {
    try {
      final user = await apiService.logIn(email, password);

      if (user != null) {
        user.isLoggedIn = true;

        await isarService.saveUser(user);
      }

      return user;
    } catch (e) {
      throw ErrorHandler.handle(e).failure;
    }
  }

  Future<bool> isLoggedIn() async {
    final user = await isarService.getUser();
    return user != null && user.isLoggedIn;
  }

  Future<User?> getCurrentUser() async {
    return await isarService.getUser();
  }

  Future<void> logOut() async {
    await isarService.logoutDB();
  }

  Future<bool> signUp(String name, String email, String password) async {
    try {
      final response = await apiService.signUp(name, email, password);
      return response;
    } catch (e) {
      throw ErrorHandler.handle(e).failure;
    }
  }
}
