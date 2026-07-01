import 'package:flutter_advanced_course/enterprise_todo_app/core/error/app_exception.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<User> login(String username, String password) async {
    final userModel = await remoteDataSource.login(username, password);
    await localDataSource.saveAuthData(userModel);
    return userModel;
  }

  @override
  Future<void> logout() async {
    await localDataSource.clearAuthData();
  }

  @override
  Future<User?> getAuthenticatedUser() async {
    return await localDataSource.getAuthData();
  }

  @override
  Future<User> refreshToken() async {
    final token = await localDataSource.getRefreshToken();
    if (token == null) {
      throw const UnauthorizedException(
        message: 'No refresh token found, please login again',
      );
    }
    final userModel = await remoteDataSource.refreshToken(token);
    await localDataSource.saveAuthData(userModel);
    return userModel;
  }
}
