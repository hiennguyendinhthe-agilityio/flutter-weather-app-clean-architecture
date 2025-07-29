import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/exceptions/app_exceptions.dart';
import '../models/api_user.dart';

@singleton
class StorageService {
  final SharedPreferences _prefs;

  static const String _userKey = 'user_data';
  static const String _tokenKey = 'auth_token';

  StorageService(this._prefs);

  Future<void> saveUser(ApiUser user) async {
    try {
      final userJson = jsonEncode(user.toJson());
      await _prefs.setString(_userKey, userJson);
    } catch (e) {
      throw const StorageException('Failed to save user data');
    }
  }

  Future<ApiUser?> getUser() async {
    try {
      final userJson = _prefs.getString(_userKey);
      if (userJson == null) return null;
      
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return ApiUser.fromJson(userMap);
    } catch (e) {
      throw const StorageException('Failed to retrieve user data');
    }
  }

  Future<void> saveToken(String token) async {
    try {
      await _prefs.setString(_tokenKey, token);
    } catch (e) {
      throw const StorageException('Failed to save authentication token');
    }
  }

  Future<String?> getToken() async {
    try {
      return _prefs.getString(_tokenKey);
    } catch (e) {
      throw const StorageException('Failed to retrieve authentication token');
    }
  }

  Future<void> clearAll() async {
    try {
      await _prefs.remove(_userKey);
      await _prefs.remove(_tokenKey);
    } catch (e) {
      throw const StorageException('Failed to clear stored data');
    }
  }

  Future<bool> hasValidSession() async {
    try {
      final user = await getUser();
      final token = await getToken();
      return user != null && token != null;
    } catch (e) {
      return false;
    }
  }
}