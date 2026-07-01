import 'package:dio/dio.dart';
import 'package:flutter_advanced_course/api_management/core/local_storage/token_storage.dart';
import 'package:flutter_advanced_course/api_management/features/auth/models/token_model.dart';

class AuthApiService {
  final Dio dio;
  final TokenStorage _tokenStorage;

  AuthApiService(this.dio, this._tokenStorage);

  // In a real app, you would make an API call here.
  // We use Future.delayed to mock a network call.
  Future<TokenModel> login(String username, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    // Simulate successful login
    if (username == 'admin' && password == '123456') {
      final token = TokenModel(
        accessToken:
            'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
        refreshToken:
            'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
      );
      await _tokenStorage.saveTokens(
        accessToken: token.accessToken,
        refreshToken: token.refreshToken,
      );
      return token;
    } else {
      throw Exception('Invalid credentials');
    }
  }

  // Mock refresh token API
  Future<TokenModel> refreshToken(String refreshToken) async {
    // Note: Do not use the same Dio instance that has AuthInterceptor here,
    // otherwise it might cause an infinite loop if this refresh call returns 401.
    // Usually we use a separate Dio instance or remove the interceptor for this specific call.
    // We will simulate it.
    await Future.delayed(const Duration(seconds: 1));

    if (refreshToken.startsWith('mock_refresh_token')) {
      final newToken = TokenModel(
        accessToken:
            'mock_access_token_refreshed_${DateTime.now().millisecondsSinceEpoch}',
        refreshToken:
            'mock_refresh_token_refreshed_${DateTime.now().millisecondsSinceEpoch}',
      );
      await _tokenStorage.saveTokens(
        accessToken: newToken.accessToken,
        refreshToken: newToken.refreshToken,
      );
      return newToken;
    } else {
      throw Exception('Invalid refresh token');
    }
  }

  Future<void> logout() async {
    await _tokenStorage.clearTokens();
  }
}
