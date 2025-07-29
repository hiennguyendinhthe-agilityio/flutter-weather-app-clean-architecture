import 'package:injectable/injectable.dart';

import '../../core/exceptions/app_exceptions.dart';
import '../../core/utils/validators.dart';
import '../datasources/api_client.dart';
import '../models/api_user.dart';
import 'storage_service.dart';

@singleton
class AuthService {
  final ApiClient _apiClient;
  final StorageService _storageService;

  AuthService(this._apiClient, this._storageService);

  /// Signs up a new user with the provided information
  Future<ApiUser> signUp(String name, String email, String password) async {
    // Validate input
    final nameError = Validators.validateName(name);
    if (nameError != null) {
      throw ValidationException(nameError);
    }

    final emailError = Validators.validateEmail(email);
    if (emailError != null) {
      throw ValidationException(emailError);
    }

    final passwordError = Validators.validatePassword(password);
    if (passwordError != null) {
      throw ValidationException(passwordError);
    }

    try {
      // Check if user already exists
      final existingUsers = await _apiClient.getUserByEmail(email);
      if (existingUsers.isNotEmpty) {
        throw const AuthException('User with this email already exists');
      }

      // Create new user
      final userData = {
        'name': name.trim(),
        'email': email.trim().toLowerCase(),
      };

      final user = await _apiClient.createUser(userData);
      return user;
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw const AuthException('Failed to create account');
    }
  }

  /// Logs in a user with email and password
  Future<ApiUser> login(String email, String password) async {
    // Validate input
    final emailError = Validators.validateEmail(email);
    if (emailError != null) {
      throw ValidationException(emailError);
    }

    final passwordError = Validators.validatePassword(password);
    if (passwordError != null) {
      throw ValidationException(passwordError);
    }

    try {
      // Find user by email
      final users = await _apiClient.getUserByEmail(email.trim().toLowerCase());
      
      if (users.isEmpty) {
        throw const AuthException('No account found with this email');
      }

      final user = users.first;

      // Simulate password validation (in real app, this would be handled by backend)
      if (!_validatePassword(password)) {
        throw const AuthException('Invalid password');
      }

      // Generate and save authentication token
      final token = _generateToken(user);
      await _storageService.saveToken(token);
      await _storageService.saveUser(user);

      return user;
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw const AuthException('Login failed');
    }
  }

  /// Logs out the current user
  Future<void> logout() async {
    try {
      await _storageService.clearAll();
    } catch (e) {
      throw const AuthException('Failed to logout');
    }
  }

  /// Checks if user has a valid session
  Future<bool> hasValidSession() async {
    return await _storageService.hasValidSession();
  }

  /// Gets the current authenticated user
  Future<ApiUser?> getCurrentUser() async {
    try {
      return await _storageService.getUser();
    } catch (e) {
      return null;
    }
  }

  /// Simulates password validation (in real app, this would be handled by backend)
  bool _validatePassword(String password) {
    // For demo purposes, accept any password that meets validation criteria
    return Validators.validatePassword(password) == null;
  }

  /// Generates a simulated JWT token
  String _generateToken(ApiUser user) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'simulated_jwt_token_${user.id}_$timestamp';
  }
}