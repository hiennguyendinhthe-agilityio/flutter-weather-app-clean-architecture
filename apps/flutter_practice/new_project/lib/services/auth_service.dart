import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../core/exceptions/api_exceptions.dart';
import '../models/api_response.dart';
import 'dio_service.dart';
import 'logger_service.dart';

/// Authentication Service
/// Handles user authentication with real API calls
@injectable
class AuthService {
  final DioService _dioService;
  final LoggerService _loggerService;

  AuthService(this._dioService, this._loggerService) {
    _loggerService.logInfo('[AuthService] Initialized');
  }

  /// Login user with username and password
  /// Returns LoginResponse on success, throws ApiException on error
  Future<LoginResponse> login({
    required String username,
    required String password,
  }) async {
    try {
      _loggerService.logInfo('[AuthService] Attempting login for: $username');

      // Validate input
      if (username.isEmpty || password.isEmpty) {
        throw const ValidationException(
          message: 'Username and password cannot be empty',
        );
      }

      // Create request payload
      final request = LoginRequest(username: username, password: password);

      // Make API call
      // Note: JSONPlaceholder doesn't have real auth, so we'll simulate
      final response = await _dioService.dio.post(
        '/posts', // Using posts endpoint for demo
        data: request.toJson(),
      );

      // For demo purposes, we'll create a mock successful response
      // In real app, you would parse the actual API response
      if (response.statusCode == 201) {
        // Simulate successful login response
        final loginResponse = LoginResponse(
          token: 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
          user: UserData(
            id: '1',
            username: username,
            email: '$username@example.com',
            fullName: username.split('@')[0].replaceAll('.', ' ').toUpperCase(),
            isActive: true,
            createdAt: DateTime.now(),
          ),
          expiresIn: 3600, // 1 hour
        );

        // Set auth token for future requests
        _dioService.setAuthToken(loginResponse.token);

        _loggerService.logInfo('[AuthService] Login successful for: $username');
        return loginResponse;
      } else {
        throw const ServerException(
          message: 'Login failed - unexpected response',
        );
      }
    } on DioException catch (e) {
      _loggerService.logError('[AuthService] Login failed: ${e.error}');

      // Re-throw the custom exception from DioService interceptor
      if (e.error is ApiException) {
        throw e.error as ApiException;
      }

      // Fallback for unexpected errors
      throw NetworkException(message: 'Login failed: ${e.message}');
    } catch (e) {
      _loggerService.logError('[AuthService] Unexpected login error: $e');
      throw ApiException(
        message: 'Error during login: $e',
        code: 'UNEXPECTED_ERROR',
      );
    }
  }

  /// Login with real API (example implementation)
  /// This shows how you would implement with a real authentication API
  Future<LoginResponse> loginWithRealAPI({
    required String username,
    required String password,
  }) async {
    try {
      _loggerService.logInfo('[AuthService] Real API login for: $username');

      // Validate input
      _validateLoginInput(username, password);

      // Create request
      final request = LoginRequest(username: username, password: password);

      // Make API call to real authentication endpoint
      final response = await _dioService.dio.post(
        '/auth/login', // Real auth endpoint
        data: request.toJson(),
      );

      // Parse response
      if (response.statusCode == 200) {
        final apiResponse = ApiResponse<LoginResponse>.fromJson(
          response.data,
          (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
        );

        if (apiResponse.success && apiResponse.data != null) {
          final loginResponse = apiResponse.data!;

          // Set auth token
          _dioService.setAuthToken(loginResponse.token);

          _loggerService.logInfo('[AuthService] Real API login successful');
          return loginResponse;
        } else {
          throw ClientException(
            message: apiResponse.message,
            code: 'LOGIN_FAILED',
          );
        }
      } else {
        throw ServerException(
          message: 'Login failed with status: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      _loggerService.logError(
        '[AuthService] Real API login failed: ${e.error}',
      );
      rethrow; // DioService interceptor already converted to ApiException
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      _loggerService.logInfo('[AuthService] Logging out user');

      // In real app, you might want to call logout endpoint
      // await _dioService.dio.post('/auth/logout');

      // Clear auth token
      _dioService.clearAuthToken();

      _loggerService.logInfo('[AuthService] Logout successful');
    } catch (e) {
      _loggerService.logError('[AuthService] Logout error: $e');
      // Even if logout API fails, clear local token
      _dioService.clearAuthToken();
    }
  }

  /// Refresh authentication token
  Future<String> refreshToken(String refreshToken) async {
    try {
      _loggerService.logInfo('[AuthService] Refreshing token');

      final response = await _dioService.dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        final newToken = response.data['access_token'] as String;
        _dioService.setAuthToken(newToken);

        _loggerService.logInfo('[AuthService] Token refreshed successfully');
        return newToken;
      } else {
        throw const UnauthorizedException(message: 'Failed to refresh token');
      }
    } on DioException catch (e) {
      _loggerService.logError('[AuthService] Token refresh failed: ${e.error}');
      rethrow;
    }
  }

  /// Get current user profile
  Future<UserData> getCurrentUser() async {
    try {
      _loggerService.logInfo('[AuthService] Getting current user');

      final response = await _dioService.dio.get('/auth/me');

      if (response.statusCode == 200) {
        final apiResponse = ApiResponse<UserData>.fromJson(
          response.data,
          (json) => UserData.fromJson(json as Map<String, dynamic>),
        );

        if (apiResponse.success && apiResponse.data != null) {
          _loggerService.logInfo('[AuthService] Got current user successfully');
          return apiResponse.data!;
        } else {
          throw ClientException(message: apiResponse.message);
        }
      } else {
        throw ServerException(
          message: 'Failed to get user profile',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      _loggerService.logError('[AuthService] Get user failed: ${e.error}');
      rethrow;
    }
  }

  /// Validate login input
  void _validateLoginInput(String username, String password) {
    final errors = <String, List<String>>{};

    if (username.isEmpty) {
      errors['username'] = ['Username not be empty'];
    } else if (username.length < 3) {
      errors['username'] = ['Username must be at least 3 characters'];
    }

    if (password.isEmpty) {
      errors['password'] = ['Password cannot be empty'];
    } else if (password.length < 6) {
      errors['password'] = ['Password must be at least 6 characters'];
    }

    if (errors.isNotEmpty) {
      throw ValidationException(message: 'Invalid login input', errors: errors);
    }
  }
}
