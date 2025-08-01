import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../core/enums/auth_state.dart';
import '../../core/exceptions/app_exceptions.dart';
import '../../data/models/api_user.dart';
import '../../data/services/auth_service.dart';

@singleton
class UserProvider extends ChangeNotifier {
  UserProvider(this._authService);

  final AuthService _authService;

  // State variables
  ApiUser? _currentUser;
  AuthState _authState = AuthState.initial;
  String? _errorMessage;

  // Getters
  ApiUser? get currentUser => _currentUser;
  AuthState get authState => _authState;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _authState == AuthState.authenticated;
  bool get isLoading => _authState == AuthState.loading;

  /// Initializes the provider and checks authentication status
  Future<void> initialize() async {
    try {
      _setAuthState(AuthState.loading);

      final hasValidSession = await _authService.hasValidSession();
      if (hasValidSession) {
        _currentUser = await _authService.getCurrentUser();
        _setAuthState(AuthState.authenticated);
      } else {
        _setAuthState(AuthState.unauthenticated);
      }
    } catch (e) {
      _setError('Failed to initialize authentication');
      _setAuthState(AuthState.error);
    }
  }

  /// Logs in a user with email and password
  Future<bool> login(String email, String password) async {
    debugPrint('🚀 UserProvider.login() called');
    try {
      _setAuthState(AuthState.loading);
      _clearError();

      final user = await _authService.login(email, password);
      _currentUser = user;
      _setAuthState(AuthState.authenticated);

      debugPrint(
        '✅ UserProvider: Login successful, state set to authenticated',
      );
      return true;
    } on ValidationException catch (e) {
      debugPrint('❌ UserProvider: ValidationException - ${e.message}');
      _setError(e.message);
      _setAuthState(AuthState.unauthenticated);
      return false;
    } on AuthException catch (e) {
      debugPrint('❌ UserProvider: AuthException - ${e.message}');
      _setError(e.message);
      _setAuthState(AuthState.unauthenticated);
      return false;
    } on NetworkException catch (e) {
      debugPrint('❌ UserProvider: NetworkException - ${e.message}');
      _setError(e.message);
      _setAuthState(AuthState.error);
      return false;
    } catch (e) {
      debugPrint('❌ UserProvider: Unexpected error - $e');
      _setError('An unexpected error occurred during login');
      _setAuthState(AuthState.error);
      return false;
    }
  }

  /// Signs up a new user
  Future<bool> signUp(String name, String email, String password) async {
    try {
      _setAuthState(AuthState.loading);
      _clearError();

      await _authService.signUp(name, email, password);
      _setAuthState(AuthState.unauthenticated);

      return true;
    } on ValidationException catch (e) {
      _setError(e.message);
      _setAuthState(AuthState.unauthenticated);
      return false;
    } on AuthException catch (e) {
      _setError(e.message);
      _setAuthState(AuthState.unauthenticated);
      return false;
    } on NetworkException catch (e) {
      _setError(e.message);
      _setAuthState(AuthState.error);
      return false;
    } catch (e) {
      _setError('An unexpected error occurred during sign up');
      _setAuthState(AuthState.error);
      return false;
    }
  }

  /// Logs out the current user
  Future<void> logout() async {
    try {
      _setAuthState(AuthState.loading);

      await _authService.logout();
      _currentUser = null;
      _clearError();
      _setAuthState(AuthState.unauthenticated);
    } catch (e) {
      _setError('Failed to logout');
      _setAuthState(AuthState.error);
    }
  }

  /// Clears any error messages
  void clearError() {
    _clearError();
  }

  // Private helper methods
  void _setAuthState(AuthState state) {
    _authState = state;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
