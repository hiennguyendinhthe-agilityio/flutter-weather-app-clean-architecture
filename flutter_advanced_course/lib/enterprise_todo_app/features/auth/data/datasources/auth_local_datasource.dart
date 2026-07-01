import 'dart:convert';

import 'package:flutter_advanced_course/enterprise_todo_app/features/auth/domain/entities/user_entity.dart';
import 'package:hive/hive.dart';

abstract class AuthLocalDataSource {
  Future<void> saveAuthData(UserModel user);
  Future<void> clearAuthData();
  Future<UserModel?> getAuthData();
  Future<String?> getToken();
  Future<String?> getRefreshToken();
}

class AuthLocalDatasourceImpl implements AuthLocalDataSource {
  final Box _settingsBox;
  static const _authKey = 'auth_data_key';

  const AuthLocalDatasourceImpl(this._settingsBox);

  @override
  Future<void> saveAuthData(UserModel user) async {
    final userJson = jsonEncode(user.toJson());
    await _settingsBox.put(_authKey, userJson);
  }

  @override
  Future<void> clearAuthData() async {
    await _settingsBox.delete(_authKey);
  }

  @override
  Future<UserModel?> getAuthData() async {
    final data = _settingsBox.get(_authKey);
    if (data == null) return null;
    try {
      final decoded = jsonDecode(data as String) as Map<String, dynamic>;
      return UserModel.fromJson(decoded);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String?> getToken() async {
    final user = await getAuthData();
    return user?.token;
  }

  @override
  Future<String?> getRefreshToken() async {
    final user = await getAuthData();
    return user?.refreshToken;
  }
}
