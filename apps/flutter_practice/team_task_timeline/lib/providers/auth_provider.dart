import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

/// Authentication provider managing user state and authentication
class AuthProvider with ChangeNotifier {
  User? _currentUser;
  List<Team> _teams = [];
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  List<Team> get teams => _teams;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;

  /// Initialize authentication state from storage
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('current_user');

      if (userJson != null) {
        // In a real app, you would validate the stored session
        _currentUser = User.fromJson({
          'id': 'user_1',
          'name': 'John Doe',
          'email': 'john@example.com',
          'teamIds': ['team_1', 'team_2'],
        });
        await _loadTeams();
      }
    } catch (e) {
      debugPrint('Error initializing auth: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sign in with email and password (mock implementation)
  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Mock authentication - in real app, call your auth service
      await Future.delayed(const Duration(seconds: 1));

      if (email.isNotEmpty && password.isNotEmpty) {
        _currentUser = User(
          id: 'user_1',
          name: email.split('@')[0].replaceAll('.', ' ').toUpperCase(),
          email: email,
          teamIds: ['team_1', 'team_2'],
        );

        await _loadTeams();
        await _saveUserToStorage();

        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint('Error signing in: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  /// Sign out the current user
  Future<void> signOut() async {
    _currentUser = null;
    _teams = [];

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user');

    notifyListeners();
  }

  /// Load teams for the current user (mock implementation)
  Future<void> _loadTeams() async {
    if (_currentUser == null) return;

    // Mock teams data
    _teams = [
      Team(
        id: 'team_1',
        name: 'Development Team',
        description: 'Frontend and Backend Development',
        memberIds: ['user_1', 'user_2', 'user_3'],
        ownerId: 'user_1',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      Team(
        id: 'team_2',
        name: 'Design Team',
        description: 'UI/UX Design and Branding',
        memberIds: ['user_1', 'user_4', 'user_5'],
        ownerId: 'user_4',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
    ];
  }

  /// Save user to local storage
  Future<void> _saveUserToStorage() async {
    if (_currentUser == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_user', _currentUser!.toJson().toString());
  }

  /// Get team by ID
  Team? getTeamById(String teamId) {
    try {
      return _teams.firstWhere((team) => team.id == teamId);
    } catch (e) {
      return null;
    }
  }
}
