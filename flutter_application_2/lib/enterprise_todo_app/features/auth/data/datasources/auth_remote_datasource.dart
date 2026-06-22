import 'package:flutter_application_2/enterprise_todo_app/features/auth/domain/entities/user_entity.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String username, String password);
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
      avatarUrl: 'https://api.dicebear.com/7.x/adventurer/svg?seed=admin');
    } else {
      throw Exception('Invalid username or password');
    }
  }
}
