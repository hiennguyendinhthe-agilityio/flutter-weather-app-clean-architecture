// ignore_for_file: deprecated_member_use

import 'package:flutter_advanced_course/enterprise_todo_app/core/local_storage/hive_storage_service.dart';
import 'package:flutter_advanced_course/enterprise_todo_app/core/local_storage/secure_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final flutterSecureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.unlocked_this_device,
    ),
  );
});

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  final storage = ref.watch(flutterSecureStorageProvider);
  return SecureStorageService(storage);
});

final hiveStorageServiceProvider = Provider<HiveStorageService>((ref) {
  final secureStorageService = ref.watch(secureStorageServiceProvider);
  return HiveStorageService(secureStorageService);
});
