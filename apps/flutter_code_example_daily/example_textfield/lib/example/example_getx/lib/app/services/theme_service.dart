import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService {
  final GetStorage _box = GetStorage();
  final String _key = 'isDarkMode';

  ThemeMode getTheme() {
    return _box.read(_key) ?? false ? ThemeMode.dark : ThemeMode.light;
  }

  void switchTheme() {
    final bool isDarkMode = !(_box.read(_key) ?? false);
    _box.write(_key, isDarkMode);
    Get.changeThemeMode(isDarkMode ? ThemeMode.dark : ThemeMode.light);
  }
}
