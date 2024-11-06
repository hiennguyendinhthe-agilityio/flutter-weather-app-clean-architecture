import 'package:bazar_books_design/core/core.dart';

abstract class AuthRepository {
  Future<User?> logIn(String email, String password);
}
