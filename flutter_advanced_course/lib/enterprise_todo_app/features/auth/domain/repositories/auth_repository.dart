import 'package:flutter_advanced_course/enterprise_todo_app/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<User> login(String username, String password);
  Future<User> refreshToken();
  Future<void> logout();
  Future<User?> getAuthenticatedUser();
}
