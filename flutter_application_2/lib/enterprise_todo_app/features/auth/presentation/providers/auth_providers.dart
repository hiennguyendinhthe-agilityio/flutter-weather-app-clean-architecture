import 'package:flutter_application_2/enterprise_todo_app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:flutter_application_2/enterprise_todo_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_application_2/enterprise_todo_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_application_2/enterprise_todo_app/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_application_2/enterprise_todo_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  throw UnimplementedError('authLocalDataSourceProvider is not implemented');
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return MockAuthRemoteDataSourceImpl();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    localDataSource: ref.watch(authLocalDataSourceProvider),
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
  );
});

class AuthState {
  final bool isLoading;
  final User? user;
  final String? errorMessage;

  const AuthState({this.isLoading = false, this.user, this.errorMessage});

  AuthState copyWith({bool? isLoading, User? user, String? errorMessage}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AuthState()) {
    _checkInitialAuth();
  }

  Future<void> _checkInitialAuth() async {
    state = state.copyWith(isLoading: true);
    final user = await _repository.getAuthenticatedUser();
    if (user != null) {
      state = AuthState(user: user);
    } else {
      state = const AuthState();
    }
  }

  Future<bool> login(String username, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _repository.login(username, password);
      state = AuthState(user: user);
      return true;
    } catch (e) {
      state = AuthState(
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    await _repository.logout();
    state = const AuthState();
  }

  void updateAuthenticatedUser(User user) {
    state = AuthState(user: user);
  }

  void forceLogout() {
    _repository.logout();
    state = const AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});
