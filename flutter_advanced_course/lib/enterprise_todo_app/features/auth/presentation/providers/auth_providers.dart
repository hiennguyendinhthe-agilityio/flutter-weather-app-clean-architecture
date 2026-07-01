import 'package:flutter_advanced_course/enterprise_todo_app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_providers.g.dart';

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  throw UnimplementedError(
    'Override this in main() with AuthLocalDatasourceImpl',
  );
});

@riverpod
AuthRemoteDataSource authRemoteDataSource(Ref ref) {
  return MockAuthRemoteDataSourceImpl();
}

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(
    localDataSource: ref.watch(authLocalDataSourceProvider),
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
  );
}

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

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    _checkInitialAuth();
    return const AuthState(isLoading: true);
  }

  Future<void> _checkInitialAuth() async {
    final user = await ref.read(authRepositoryProvider).getAuthenticatedUser();

    state = user != null ? AuthState(user: user) : const AuthState();
  }

  Future<bool> login(String username, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await ref
          .read(authRepositoryProvider)
          .login(username, password);
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
    await ref.read(authRepositoryProvider).logout();
    state = const AuthState();
  }

  void updateAuthenticatedUser(User user) {
    state = AuthState(user: user);
  }

  void forceLogout() {
    ref.read(authRepositoryProvider).logout();
    state = const AuthState();
  }
}
