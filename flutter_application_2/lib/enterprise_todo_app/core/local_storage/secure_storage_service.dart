import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService(this._storage);

  static const String _hiveEncryptionKey = 'hive_encryption_key';
  static const String _accessTokenKey = 'access_token';

  Future<String?> getHiveEncryptionKey() async {
    return await _storage.read(key: _hiveEncryptionKey);
  }

  Future<void> saveHiveEncryptionKey(String key) async {
    await _storage.write(key: _hiveEncryptionKey, value: key);
  }

  Future<void> deleteHiveEncryptionKey() async {
    await _storage.delete(key: _hiveEncryptionKey);
  }

  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
