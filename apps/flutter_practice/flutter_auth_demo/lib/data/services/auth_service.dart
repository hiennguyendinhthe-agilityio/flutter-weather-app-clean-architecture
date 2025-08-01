import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../core/exceptions/app_exceptions.dart';
import '../../core/utils/validators.dart';
import '../datasources/api_client.dart';
import '../models/api_user.dart';
import 'storage_service.dart';

@singleton
class AuthService {
  AuthService(this._apiClient, this._storageService);
  final ApiClient _apiClient;
  final StorageService _storageService;

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

      // Create new user (in demo, we don't store password for security)
      final userData = {
        'name': name.trim(),
        'email': email.trim().toLowerCase(),
        // In real app, password would be hashed and stored securely
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
    try {
      debugPrint('🔐 AuthService.login() called with email: $email');

      // Validate input format first
      final emailError = Validators.validateEmail(email);
      if (emailError != null) {
        throw ValidationException(emailError);
      }
      if (password.isEmpty) {
        throw const ValidationException('Password is required');
      }

      // Find user by email
      final users = await _apiClient.getUserByEmail(email.trim().toLowerCase());

      if (users.isEmpty) {
        debugPrint('❌ AuthService: No user found for email $email');
        throw const AuthException('Email and password are incorrect.');
      }
      final user = users.first;
      debugPrint('✅ User found: ${user.name} (${user.email})');

      // *** THIS IS THE CRITICAL FIX ***
      // For this demo, we simulate checking against a hardcoded correct password.
      // In a real app, this would be a secure hash comparison handled by the backend.
      const String correctPasswordForDemo = 'password123';
      if (password != correctPasswordForDemo) {
        debugPrint(
          '❌ AuthService: Password validation failed for user ${user.email}',
        );
        throw const AuthException('Email and password are incorrect.');
      }
      debugPrint('✅ Password validation passed');

      // Generate and save authentication token
      final token = _generateToken(user);
      await _storageService.saveToken(token);
      await _storageService.saveUser(user);
      debugPrint('✅ Login successful! Token saved.');
      return user;
    } catch (e) {
      debugPrint('❌ Login error: $e');
      if (e is AppException) {
        rethrow;
      }
      throw const AuthException('An unexpected error occurred during login.');
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

  /// Generates a simulated JWT token
  String _generateToken(ApiUser user) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'simulated_jwt_token_${user.id}_$timestamp';
  }
}
