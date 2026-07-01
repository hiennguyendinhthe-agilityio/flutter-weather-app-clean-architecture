import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_advanced_course/enterprise_todo_app/core/local_storage/secure_storage_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveStorageService {
  final SecureStorageService _secureStorage;

  HiveStorageService(this._secureStorage);

  static const String _userBoxName = 'encrypted_user_box';

  Future<void> init() async {
    await Hive.initFlutter();

    final encryptionKey = await _getOrGeneratedEncryptionKey();

    await Hive.openBox(
      _userBoxName,
      encryptionCipher: HiveAesCipher(encryptionKey),
    );
  }

  Future<Uint8List> _getOrGeneratedEncryptionKey() async {
    final existingKeyString = await _secureStorage.getHiveEncryptionKey();

    if (existingKeyString != null) {
      return base64Url.decode(existingKeyString);
    } else {
      final newKeyBytes = Hive.generateSecureKey();

      final newKeyString = base64Url.encode(newKeyBytes);

      await _secureStorage.saveHiveEncryptionKey(newKeyString);

      return Uint8List.fromList(newKeyBytes);
    }
  }

  Box getUserBox() {
    return Hive.box(_userBoxName);
  }

  Future<void> wipeAllData() async {
    await Hive.deleteBoxFromDisk(_userBoxName);

    await _secureStorage.deleteAll();
  }
}
