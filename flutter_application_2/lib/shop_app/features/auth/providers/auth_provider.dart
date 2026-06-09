import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

class AuthUser {
  final String email;
  final String name;

  const AuthUser({required this.email, required this.name});
}

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  @override
  AuthUser? build() => null;

  Future<void> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 1500));

    if (password != '123456') {
      throw Exception('Error Password: 123456');
    }

    state = AuthUser(email: email, name: email.split('@').first);
  }

  void logout() {
    state = null;
  }
}
