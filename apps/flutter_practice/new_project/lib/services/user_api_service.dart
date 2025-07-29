import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../core/exceptions/api_exceptions.dart';
import '../models/user_model.dart';
import 'dio_service.dart';
import 'logger_service.dart';

/// User API Service
/// Handles all user-related API operations with MockAPI
@injectable
class UserApiService {
  final DioService _dioService;
  final LoggerService _loggerService;

  UserApiService(this._dioService, this._loggerService) {
    _loggerService.logInfo(
      '[UserApiService] Initialized with password security',
    );
  }

  /// Get all users
  Future<List<ApiUser>> getUsers() async {
    try {
      _loggerService.logInfo('[UserApiService] Fetching all users');

      final response = await _dioService.dio.get('/user');

      // Tối ưu: Dio sẽ tự động throw DioException cho status code ngoài 2xx.
      // Interceptor của chúng ta sẽ chuyển nó thành ApiException.
      // Vì vậy, nếu code chạy đến đây, nghĩa là đã thành công (status 200).
      final List<dynamic> data = response.data;
      final users = data.map((json) => ApiUser.fromJson(json)).toList();
      _loggerService.logInfo('[UserApiService] Fetched ${users.length} users');
      return users;
    } on DioException catch (e) {
      _loggerService.logError('[UserApiService] Get users failed: ${e.error}');
      rethrow; // DioService interceptor already converted to ApiException
    }
  }

  /// Get user by ID
  Future<ApiUser> getUserById(String id) async {
    try {
      _loggerService.logInfo('[UserApiService] Fetching user: $id');

      final response = await _dioService.dio.get('/user/$id');

      final user = ApiUser.fromJson(response.data);
      _loggerService.logInfo('[UserApiService] Fetched user: ${user.name}');
      return user;
    } on DioException catch (e) {
      _loggerService.logError('[UserApiService] Get user failed: ${e.error}');
      rethrow;
    }
  }

  /// Create new user
  Future<ApiUser> createUser(CreateUserRequest request) async {
    try {
      _loggerService.logInfo('[UserApiService] Creating user: ${request.name}');

      final response = await _dioService.dio.post(
        '/user',
        data: request.toJson(),
      );

      // Tối ưu: Logic tương tự, chỉ khác status code là 201 (Dio vẫn xử lý là success)
      final user = ApiUser.fromJson(response.data);
      _loggerService.logInfo('[UserApiService] Created user: ${user.name}');
      return user;
    } on DioException catch (e) {
      _loggerService.logError(
        '[UserApiService] Create user failed: ${e.error}',
      );
      rethrow;
    }
  }

  /// Update user
  Future<ApiUser> updateUser(String id, UpdateUserRequest request) async {
    try {
      _loggerService.logInfo('[UserApiService] Updating user: $id');

      final response = await _dioService.dio.put(
        '/user/$id',
        data: request.toJson(),
      );

      // Tối ưu: Logic tương tự
      final user = ApiUser.fromJson(response.data);
      _loggerService.logInfo('[UserApiService] Updated user: ${user.name}');
      return user;
    } on DioException catch (e) {
      _loggerService.logError(
        '[UserApiService] Update user failed: ${e.error}',
      );
      rethrow;
    }
  }

  /// Delete user
  Future<void> deleteUser(String id) async {
    try {
      _loggerService.logInfo('[UserApiService] Deleting user: $id');

      await _dioService.dio.delete('/user/$id');

      // Tối ưu: Nếu không có lỗi, nghĩa là đã thành công.
      _loggerService.logInfo('[UserApiService] Deleted user: $id');
    } on DioException catch (e) {
      _loggerService.logError(
        '[UserApiService] Delete user failed: ${e.error}',
      );
      rethrow;
    }
  }

  /// Simulate login (MockAPI doesn't have real authentication)
  /// This searches for user by email and simulates login
  Future<MockLoginResponse> simulateLogin({
    required String email,
    required String password,
  }) async {
    try {
      _loggerService.logInfo('[UserApiService] Simulating login for: $email');

      // Validate input
      _validateLoginInput(email, password);

      // Tối ưu: Thay vì lấy tất cả users, hãy để API lọc giúp.
      // MockAPI hỗ trợ lọc theo query parameter.
      final response = await _dioService.dio.get(
        '/user',
        queryParameters: {'email': email.toLowerCase()},
      );

      final List<dynamic> matchingUsersData = response.data;
      final user = matchingUsersData.isNotEmpty
          ? ApiUser.fromJson(matchingUsersData.first)
          : null;

      if (user == null) {
        // If user doesn't exist, create a new one for demo
        // Tái sử dụng hàm createUser đã có, không viết lại logic
        final newUser = await createUser(
          CreateUserRequest(
            name: email.split('@')[0].replaceAll('.', ' ').toUpperCase(),
            email: email,
            avatar: 'https://via.placeholder.com/150',
          ),
        );

        final loginResponse = MockLoginResponse(
          token: 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
          user: newUser,
          expiresIn: 3600,
        );

        _loggerService.logInfo(
          '[UserApiService] Login successful (new user): ${newUser.name}',
        );
        return loginResponse;
      } else {
        // User exists, simulate successful login
        final loginResponse = MockLoginResponse(
          token: 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
          user: user,
          expiresIn: 3600,
        );

        _loggerService.logInfo(
          '[UserApiService] Login successful (existing user): ${user.name}',
        );
        return loginResponse;
      }
    } on DioException catch (e) {
      _loggerService.logError('[UserApiService] Login failed: ${e.error}');
      rethrow;
    } catch (e) {
      _loggerService.logError('[UserApiService] Unexpected login error: $e');
      throw ApiException(
        message: 'Đã xảy ra lỗi không mong muốn: $e',
        code: 'UNEXPECTED_ERROR',
      );
    }
  }

  /// Helper method for login input validation
  void _validateLoginInput(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      throw const ValidationException(
        message: 'Email và password không được để trống',
      );
    }

    if (!email.contains('@')) {
      throw const ValidationException(message: 'Email không hợp lệ');
    }

    if (password.length < 6) {
      throw const ValidationException(
        message: 'Password phải có ít nhất 6 ký tự',
      );
    }
  }

  /// Search users by name or email
  Future<List<ApiUser>> searchUsers(String query) async {
    try {
      _loggerService.logInfo('[UserApiService] Searching users: $query');

      // Tối ưu: Sử dụng query parameter 'search' của MockAPI
      final response = await _dioService.dio.get(
        '/user',
        queryParameters: {'search': query},
      );

      final List<dynamic> data = response.data;
      final filteredUsers = data.map((json) => ApiUser.fromJson(json)).toList();

      _loggerService.logInfo(
        '[UserApiService] Found ${filteredUsers.length} users matching "$query"',
      );
      return filteredUsers;
    } catch (e) {
      _loggerService.logError('[UserApiService] Search failed: $e');
      rethrow;
    }
  }
}
