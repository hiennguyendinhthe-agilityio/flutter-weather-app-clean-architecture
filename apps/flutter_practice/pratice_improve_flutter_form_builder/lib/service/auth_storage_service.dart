import 'package:shared_preferences/shared_preferences.dart';

class AuthStorageService {
  static const String _savedEmailKey = 'saved_email';
  static const String _savedPasswordKey = 'saved_password';

  Future<void> saveLoginCredentials({
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    if (email.isNotEmpty && password.isNotEmpty) {
      await prefs.setString(_savedEmailKey, email);
      await prefs.setString(_savedPasswordKey, password);
    } else {
      await clearSavedCredentials();
    }
  }

  Future<void> clearSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_savedEmailKey);
    await prefs.remove(_savedPasswordKey);
  }

  Future<Map<String, dynamic>> getSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'email': prefs.getString(_savedEmailKey),
      'password': prefs.getString(_savedPasswordKey),
    };
  }
}
