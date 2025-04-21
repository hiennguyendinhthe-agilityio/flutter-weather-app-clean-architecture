import 'package:shared_preferences/shared_preferences.dart';

class AuthStorageService {
  static const String _savedEmailKey = 'saved_email';
  static const String _savedPasswordKey = 'saved_password';
  static const String _biometricEnabledKey = 'biometric_enabled';
  static const String _isRememberMeKey = 'is_remember_me';

  Future<void> saveLoginCredentials({
    required String email,
    required String password,
    required bool isRememberMe,
    required bool biometricEnabled,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    if (isRememberMe) {
      await prefs.setString(_savedEmailKey, email);
      await prefs.setString(_savedPasswordKey, password);
      await prefs.setBool(_biometricEnabledKey, biometricEnabled);
    } else {
      await clearSavedCredentials();
    }
    await prefs.setBool(_isRememberMeKey, isRememberMe);
  }

  Future<void> clearSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_savedEmailKey);
    await prefs.remove(_savedPasswordKey);
    await prefs.remove(_biometricEnabledKey);
    await prefs.remove(_isRememberMeKey);
  }

  Future<Map<String, dynamic>> getSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'email': prefs.getString(_savedEmailKey),
      'password': prefs.getString(_savedPasswordKey),
      'biometricEnabled': prefs.getBool(_biometricEnabledKey) ?? false,
      'isRememberMe': prefs.getBool(_isRememberMeKey) ?? false,
    };
  }
}
