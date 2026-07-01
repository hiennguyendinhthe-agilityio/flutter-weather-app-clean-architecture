import 'package:flutter/foundation.dart';
import 'package:flutter_advanced_course/devhub/features/auth/models/user_model.dart';

// 🎓 LESSON — Auth State Ownership
// AuthNotifier is the ROOT of the dependency graph.
// It owns TWO things: isLoggedIn + currentUser.
// NO other notifier can change this state — only AuthNotifier itself.
// This is "Single Source of Truth" for authentication.

class AuthNotifier extends ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;

  // 🎓 Derived state: computed from _currentUser, NOT stored separately.
  // If we stored bool _isLoggedIn separately, we'd have two sources of truth.
  bool get isLoggedIn => _currentUser != null;

  // 🎓 These are the ONLY methods that can mutate auth state.
  // Any widget that calls context.read<AuthNotifier>().login() triggers this.
  Future<void> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Hardcoded credentials for demo
    if (email == 'dev@devhub.io' && password == 'password') {
      _currentUser = const User(
        id: 'u_001',
        username: 'flutter_dev',
        email: 'dev@devhub.io',
      );
      notifyListeners(); // ← This triggers the entire reactive chain
    } else {
      throw Exception('Invalid credentials');
    }
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
    // 🎓 After notifyListeners():
    // 1. Every widget watching AuthNotifier will schedule a rebuild
    // 2. ProxyProvider<AuthNotifier, FeedNotifier>.update() will be called
    // 3. ProxyProvider<AuthNotifier, BookmarkNotifier>.update() will be called
    // 4. DevHubApp (which selects isLoggedIn) will rebuild → shows LoginScreen
  }
}
