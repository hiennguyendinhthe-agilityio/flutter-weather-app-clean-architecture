import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefUtils {
  static SharedPreferences? _sharedPreferences;

  static final PrefUtils _instance = PrefUtils._internal();
  factory PrefUtils() => _instance;

  PrefUtils._internal();

  Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    debugPrint('SharedPreferences Initialized');
  }

  Future<void> clearPreferencesData() async {
    if (_sharedPreferences != null) {
      await _sharedPreferences!.clear();
    }
  }

  Future<void> setThemeData(String value) async {
    if (_sharedPreferences != null) {
      await _sharedPreferences!.setString('themeData', value);
    }
  }

  String getThemeData() {
    return _sharedPreferences?.getString('themeData') ?? 'primary';
  }
}
