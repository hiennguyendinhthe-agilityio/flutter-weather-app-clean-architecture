import 'package:flutter_advanced_course/banking_app/core/constants/app_constants.dart';
import 'package:flutter_advanced_course/banking_app/features/auth/models/user_model.dart';
import 'package:flutter_advanced_course/banking_app/features/auth/providers/auth_provider.dart'
    show AuthStatus;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

part 'auth_notifier.g.dart';

class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

@riverpod
class AuthNotifier extends _$AuthNotifier {
  static const _mockUsers = {
    'demo@bank.com': {
      'password': 'demo123',
      'id': 'usr_demo_001',
      'name': 'Demo User',
    },
  };

  @override
  AuthState build() {
    return const AuthState();
  }

  Future<void> checkStatus() async {
    state = state.copyWith(status: AuthStatus.loading);

    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(AppConstants.keyUserJson);

      if (json != null) {
        final user = UserModel.fromJsonString(json);
        state = state.copyWith(status: AuthStatus.authenticated, user: user);
      } else {
        state = state.copyWith(status: AuthStatus.unauthenticated);
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Failed to check authentication status',
      );
    }
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading, clearError: true);

    await Future.delayed(AppConstants.mockDelay);

    final record = _mockUsers[email.toLowerCase()];
    if (record == null || record['password'] != password) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Invalid email or password',
      );
      return false;
    }

    final user = UserModel(
      id: record['id']!,
      email: email,
      fullName: record['name']!,
      createdAt: DateTime(2024, 1, 15),
    );

    await _persistUser(user);
    state = state.copyWith(status: AuthStatus.authenticated, user: user);
    return true;
  }

  Future<bool> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, clearError: true);

    await Future.delayed(AppConstants.mockDelay);

    if (_mockUsers.containsKey(email.toLowerCase())) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Email already registered',
      );
      return false;
    }

    final user = UserModel(
      id: 'usr_${const Uuid().v4()}',
      email: email,
      fullName: fullName,
      createdAt: DateTime.now(),
    );

    await _persistUser(user);
    state = state.copyWith(status: AuthStatus.authenticated, user: user);
    return true;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.keyIsLoggedIn);
    await prefs.remove(AppConstants.keyUserJson);

    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  Future<void> _persistUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyUserJson, user.toJsonString());
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}
