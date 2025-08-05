import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

/// A service for securely managing sensitive data storage.
@singleton
class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      // Use AES encryption.
      keyCipherAlgorithm: KeyCipherAlgorithm.RSA_ECB_PKCS1Padding,
      storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
    ),
    iOptions: IOSOptions(
      // Use Keychain on iOS.
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _biometricEnabledKey = 'biometric_enabled';
  static const String _pinCodeKey = 'pin_code';

  /// Saves the access token.
  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  /// Retrieves the access token.
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  /// Saves the refresh token.
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  /// Retrieves the refresh token.
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  /// Saves the user ID.
  Future<void> saveUserId(String userId) async {
    await _storage.write(key: _userIdKey, value: userId);
  }

  /// Retrieves the user ID.
  Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }

  /// Saves the biometric authentication status.
  Future<void> setBiometricEnabled(bool enabled) async {
    await _storage.write(key: _biometricEnabledKey, value: enabled.toString());
  }

  /// Checks if biometric authentication is enabled.
  Future<bool> isBiometricEnabled() async {
    final value = await _storage.read(key: _biometricEnabledKey);
    return value == 'true';
  }

  /// Saves the (hashed) PIN code.
  Future<void> savePinCode(String hashedPin) async {
    await _storage.write(key: _pinCodeKey, value: hashedPin);
  }

  /// Retrieves the (hashed) PIN code.
  Future<String?> getPinCode() async {
    return await _storage.read(key: _pinCodeKey);
  }

  /// Saves custom data for a given [key].
  Future<void> saveCustomData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Retrieves custom data for a given [key].
  Future<String?> getCustomData(String key) async {
    return await _storage.read(key: key);
  }

  /// Deletes a specific [key] from storage.
  Future<void> deleteKey(String key) async {
    await _storage.delete(key: key);
  }

  /// Deletes all data from secure storage (e.g., on logout).
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// Retrieves all stored key-value pairs.
  Future<Map<String, String>> getAllData() async {
    return await _storage.readAll();
  }

  /// Checks if a [key] exists in storage.
  Future<bool> containsKey(String key) async {
    return await _storage.containsKey(key: key);
  }
}
