import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../core/exceptions/api_exceptions.dart';
import '../models/api_response.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/logger_service.dart';
import '../services/user_api_service.dart';
import '../services/user_service.dart';

/// Model cho User data
class User {
  final String id;
  final String name;
  final String email;
  final bool isActive;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.isActive = true,
  });

  User copyWith({String? id, String? name, String? email, bool? isActive}) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() =>
      'User(id: $id, name: $name, email: $email, isActive: $isActive)';
}

/// UserProvider - Quản lý trạng thái user authentication và profile
@injectable
class UserProvider extends ChangeNotifier {
  final UserService _userService;
  final AuthService _authService;
  final UserApiService _userApiService;
  final LoggerService _loggerService;

  // Authentication state
  User? _currentUser;
  UserData? _apiUserData; // Data from old API
  ApiUser? _mockApiUser; // Data from MockAPI
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _errorMessage;
  String? _authToken;

  // User list state (real API data)
  List<ApiUser> _apiUsers = [];
  List<User> _users = []; // Keep for compatibility
  bool _isLoadingUsers = false;

  // Search state
  List<ApiUser> _searchResults = [];
  bool _isSearching = false;
  String _searchQuery = '';
  String? _searchError;

  UserProvider(
    this._userService,
    this._authService,
    this._userApiService,
    this._loggerService,
  ) {
    _loggerService.logInfo('[UserProvider] Initialized with MockAPI');
  }

  // Getters
  User? get currentUser => _currentUser;
  UserData? get apiUserData => _apiUserData;
  ApiUser? get mockApiUser => _mockApiUser;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  String? get authToken => _authToken;

  List<User> get users => List.unmodifiable(_users);
  List<ApiUser> get apiUsers => List.unmodifiable(_apiUsers);
  bool get isLoadingUsers => _isLoadingUsers;
  int get userCount => _apiUsers.length;

  List<ApiUser> get searchResults => List.unmodifiable(_searchResults);
  bool get isSearching => _isSearching;
  String get searchQuery => _searchQuery;
  String? get searchError => _searchError;

  Future<void> searchUsers(String query) async {
    _searchQuery = query;

    if (query.isEmpty) {
      _searchResults = [];
      _isSearching = false;
      _searchError = null;
      notifyListeners();
      return;
    }

    _isSearching = true;
    _searchError = null;
    notifyListeners();

    try {
      final results = await _userApiService.searchUsers(query);
      _searchResults = results;
      _loggerService.logInfo(
        '[UserProvider] Found ${results.length} users for query: $query',
      );
    } on ApiException catch (e) {
      _searchError = 'Error searching users: ${e.message}';
      _searchResults = [];
      _loggerService.logError('[UserProvider] Search error: ${e.message}');
    } catch (e) {
      _searchError = 'Unexpected error searching users: $e';
      _searchResults = [];
      _loggerService.logError('[UserProvider] Unexpected search error: $e');
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  /// Login user with MockAPI
  Future<void> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      _loggerService.logInfo(
        '[UserProvider] Attempting MockAPI login for: $email',
      );

      // Call UserApiService for MockAPI login
      final loginResponse = await _userApiService.simulateLogin(
        email: email,
        password: password,
      );

      // Store MockAPI user data
      _mockApiUser = loginResponse.user;
      _authToken = loginResponse.token;

      // Create local user model for compatibility
      _currentUser = User(
        id: loginResponse.user.id,
        name: loginResponse.user.name,
        email: loginResponse.user.email,
        isActive: true,
      );

      _isLoggedIn = true;
      _loggerService.logInfo(
        '[UserProvider] MockAPI login successful: ${_currentUser!.name}',
      );
    } on ValidationException catch (e) {
      _errorMessage = e.message;
      _loggerService.logError(
        '[UserProvider] Validation error: $_errorMessage',
      );
    } on NetworkException catch (e) {
      _errorMessage =
          'Lỗi kết nối mạng. Vui lòng kiểm tra internet và thử lại.';
      _loggerService.logError('[UserProvider] Network error: ${e.message}');
    } on TimeoutException catch (e) {
      _errorMessage = 'Kết nối quá chậm. Vui lòng thử lại.';
      _loggerService.logError('[UserProvider] Timeout error: ${e.message}');
    } on ServerException catch (e) {
      _errorMessage = 'Lỗi server. Vui lòng thử lại sau.';
      _loggerService.logError('[UserProvider] Server error: ${e.message}');
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _loggerService.logError('[UserProvider] API error: ${e.message}');
    } catch (e) {
      _errorMessage = 'Đã xảy ra lỗi không mong muốn. Vui lòng thử lại.';
      _loggerService.logError('[UserProvider] Unexpected error: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Logout user
  Future<void> logout() async {
    _loggerService.logInfo(
      '[UserProvider] Logging out user: ${_currentUser?.name}',
    );

    try {
      // Call API logout
      await _authService.logout();
    } catch (e) {
      _loggerService.logError('[UserProvider] Logout API error: $e');
      // Continue with local logout even if API fails
    }

    // Clear local state
    _userService.logout();
    _currentUser = null;
    _apiUserData = null;
    _mockApiUser = null;
    _authToken = null;
    _isLoggedIn = false;
    _clearError();

    notifyListeners();
  }

  /// Load users from MockAPI
  Future<void> loadUsers() async {
    _setLoadingUsers(true);
    _clearError();

    try {
      _loggerService.logInfo('[UserProvider] Loading users from MockAPI...');

      // Get users from real API
      _apiUsers = await _userApiService.getUsers();

      // Convert to local User model for compatibility
      _users = _apiUsers
          .map(
            (apiUser) => User(
              id: apiUser.id,
              name: apiUser.name,
              email: apiUser.email,
              isActive: true,
            ),
          )
          .toList();

      _loggerService.logInfo(
        '[UserProvider] Loaded ${_apiUsers.length} users from MockAPI',
      );
    } on NetworkException catch (e) {
      _errorMessage =
          'Lỗi kết nối mạng. Vui lòng kiểm tra internet và thử lại.';
      _loggerService.logError(
        '[UserProvider] Network error loading users: ${e.message}',
      );
    } on ServerException catch (e) {
      _errorMessage = 'Lỗi server. Vui lòng thử lại sau.';
      _loggerService.logError(
        '[UserProvider] Server error loading users: ${e.message}',
      );
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _loggerService.logError(
        '[UserProvider] API error loading users: ${e.message}',
      );
    } catch (e) {
      _errorMessage = 'Đã xảy ra lỗi không mong muốn khi tải danh sách users.';
      _loggerService.logError(
        '[UserProvider] Unexpected error loading users: $e',
      );
    } finally {
      _setLoadingUsers(false);
    }
  }

  /// Add new user to MockAPI
  Future<void> addUser(String name, String email) async {
    if (name.isEmpty || email.isEmpty) {
      _errorMessage = 'Name và email không được để trống';
      notifyListeners();
      return;
    }

    try {
      _loggerService.logInfo('[UserProvider] Adding user to MockAPI: $name');

      final request = CreateUserRequest(
        name: name,
        email: email,
        avatar: 'https://via.placeholder.com/150',
      );

      final newApiUser = await _userApiService.createUser(request);

      // Add to local lists
      _apiUsers.add(newApiUser);
      _users.add(
        User(
          id: newApiUser.id,
          name: newApiUser.name,
          email: newApiUser.email,
          isActive: true,
        ),
      );

      _clearError();
      _loggerService.logInfo(
        '[UserProvider] Added user to MockAPI: ${newApiUser.name}',
      );
      notifyListeners();
    } on ValidationException catch (e) {
      _errorMessage = e.message;
      _loggerService.logError(
        '[UserProvider] Validation error adding user: ${e.message}',
      );
      notifyListeners();
    } on ApiException catch (e) {
      _errorMessage = 'Lỗi khi thêm user: ${e.message}';
      _loggerService.logError(
        '[UserProvider] API error adding user: ${e.message}',
      );
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Đã xảy ra lỗi không mong muốn khi thêm user.';
      _loggerService.logError(
        '[UserProvider] Unexpected error adding user: $e',
      );
      notifyListeners();
    }
  }

  /// Remove user from MockAPI
  Future<void> removeUser(String userId) async {
    try {
      _loggerService.logInfo(
        '[UserProvider] Removing user from MockAPI: $userId',
      );

      await _userApiService.deleteUser(userId);

      // Remove from local lists
      _apiUsers.removeWhere((user) => user.id == userId);
      _users.removeWhere((user) => user.id == userId);

      _loggerService.logInfo(
        '[UserProvider] Removed user from MockAPI: $userId',
      );
      notifyListeners();
    } on ApiException catch (e) {
      _errorMessage = 'Lỗi khi xóa user: ${e.message}';
      _loggerService.logError(
        '[UserProvider] API error removing user: ${e.message}',
      );
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Đã xảy ra lỗi không mong muốn khi xóa user.';
      _loggerService.logError(
        '[UserProvider] Unexpected error removing user: $e',
      );
      notifyListeners();
    }
  }

  /// Toggle user active status (update via API)
  Future<void> toggleUserStatus(String userId) async {
    try {
      final apiUserIndex = _apiUsers.indexWhere((user) => user.id == userId);
      if (apiUserIndex == -1) return;

      final currentUser = _apiUsers[apiUserIndex];

      _loggerService.logInfo(
        '[UserProvider] Toggling status for user: $userId',
      );

      // For demo, we'll just update the name to indicate status change
      final request = UpdateUserRequest(
        name: currentUser.name.contains('(Inactive)')
            ? currentUser.name.replaceAll(' (Inactive)', '')
            : '${currentUser.name} (Inactive)',
        email: currentUser.email,
        avatar: currentUser.avatar,
        phone: currentUser.phone,
        address: currentUser.address,
      );

      final updatedUser = await _userApiService.updateUser(userId, request);

      // Update local lists
      _apiUsers[apiUserIndex] = updatedUser;

      final localUserIndex = _users.indexWhere((user) => user.id == userId);
      if (localUserIndex != -1) {
        _users[localUserIndex] = _users[localUserIndex].copyWith(
          name: updatedUser.name,
          isActive: !updatedUser.name.contains('(Inactive)'),
        );
      }

      _loggerService.logInfo('[UserProvider] Toggled status for user: $userId');
      notifyListeners();
    } on ApiException catch (e) {
      _errorMessage = 'Lỗi khi cập nhật user: ${e.message}';
      _loggerService.logError(
        '[UserProvider] API error toggling user status: ${e.message}',
      );
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Đã xảy ra lỗi không mong muốn khi cập nhật user.';
      _loggerService.logError(
        '[UserProvider] Unexpected error toggling user status: $e',
      );
      notifyListeners();
    }
  }

  // Private helper methods
  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  void _setLoadingUsers(bool loading) {
    if (_isLoadingUsers != loading) {
      _isLoadingUsers = loading;
      notifyListeners();
    }
  }

  void _clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  void clearError() {
    _clearError();
  }

  @override
  void dispose() {
    _loggerService.logInfo('[UserProvider] Disposed');
    super.dispose();
  }
}
