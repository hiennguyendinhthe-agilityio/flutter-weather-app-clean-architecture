import 'package:flutter_advanced_course/enterprise_todo_app/features/auth/domain/entities/user_entity.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String username, String password);
  Future<UserModel> refreshToken(String refreshToken);
}

class MockAuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> login(String username, String password) async {
    await Future.delayed(const Duration(milliseconds: 1500));

    if (username == 'admin' && password == 'password123') {
      return const UserModel(
        id: 1,
        username: 'admin',
        email: 'admin@enterprise.com',
        token: 'mock_jwt_token_for_admin_user_12345',
        refreshToken: 'mock_refresh_token_for_admin_user_12345',
        avatarUrl: 'https://api.dicebear.com/7.x/adventurer/svg?seed=admin',
      );
    } else {
      throw Exception('Invalid username or password');
    }
  }

  @override
  Future<UserModel> refreshToken(String refreshToken) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    if (refreshToken == 'mock_refresh_token_admin_user_12345') {
      return const UserModel(
        id: 1,
        username: 'admin',
        email: 'admin@enterprise.com',
        token: 'new_jwt_token_123456',
        refreshToken: 'mock_refresh_token_admin_user_12345',
        avatarUrl: 'https://api.dicebear.com/7.x/adventurer/svg?seed=admin',
      );
    }
    throw Exception('Invalid refresh token');
  }
}
