import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/banking_app/core/constants/app_constants.dart';
import 'package:flutter_advanced_course/banking_app/features/auth/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  AuthStatus _status = AuthStatus.initial;
  UserModel? _user;
  String? _errorMessage;

  AuthStatus get status => _status;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isLoading => _status == AuthStatus.loading;

  // ── Mock credentials ──────────────────────────
  static const _mockUsers = {
    'demo@bank.com': {
      'password': 'demo123',
      'id': 'usr_demo_001',
      'name': 'Demo User',
    },
  };

  // -- Check stored session --
  Future<void> checkStatus() async {
    _setStatus(AuthStatus.loading);
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(AppConstants.keyUserJson);

      if (json != null) {
        _user = UserModel.fromJsonString(json);
        _setStatus(AuthStatus.authenticated);
      } else {
        _setStatus(AuthStatus.unauthenticated);
      }
    } catch (e) {
      _errorMessage = 'Failed to check authentication status';
      _setStatus(AuthStatus.error);
    }
  }

  // ── Login ─────────────────────────────────────
  Future<bool> login(String email, String password) async {
    _clearError();
    _setStatus(AuthStatus.loading);

    await Future.delayed(AppConstants.mockDelay);

    final record = _mockUsers[email.toLowerCase()];
    if (record == null || record['password'] != password) {
      _errorMessage = 'Invalid email or password';
      _setStatus(AuthStatus.error);
      return false;
    }

    _user = UserModel(
      id: record['id']!,
      email: email,
      fullName: record['name']!,
      createdAt: DateTime(2024, 1, 15),
    );

    await _persistUser(_user!);
    _setStatus(AuthStatus.authenticated);
    return true;
  }

  // ── Register ──────────────────────────────────
  Future<bool> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    _clearError();
    _setStatus(AuthStatus.loading);

    await Future.delayed(AppConstants.mockDelay);

    // Check existing
    if (_mockUsers.containsKey(email.toLowerCase())) {
      _errorMessage = 'Email already registered';
      _setStatus(AuthStatus.error);
      return false;
    }

    _user = UserModel(
      id: 'usr_${const Uuid().v4()}',
      email: email,
      fullName: fullName,
      createdAt: DateTime.now(),
    );

    await _persistUser(_user!);
    _setStatus(AuthStatus.authenticated);
    return true;
  }

  // ── Logout ────────────────────────────────────
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.keyIsLoggedIn);
    await prefs.remove(AppConstants.keyUserJson);
    _user = null;
    _setStatus(AuthStatus.unauthenticated);
  }

  // ── Helpers ───────────────────────────────────
  Future<void> _persistUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyUserJson, user.toJsonString());
  }

  void _setStatus(AuthStatus s) {
    _status = s;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }
}
