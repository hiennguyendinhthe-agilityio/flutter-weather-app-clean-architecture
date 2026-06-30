import 'package:flutter/material.dart';

// 🎓 LESSON — Global vs Feature State
// SettingsNotifier is a good example of TRULY global state.
// ThemeMode affects the entire app from the MaterialApp root.
// It must live at the top of the provider tree.
//
// Contrast with FilterNotifier (only affects Feed screen) —
// that could theoretically be scoped closer to FeedScreen.
// In this project both live at root for simplicity.

class SettingsNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    notifyListeners();
    // 🎓 This notifyListeners() causes DevHubApp (which watches themeMode)
    // to rebuild → MaterialApp receives new themeMode → entire tree re-themes.
    // This is intentional — theme IS a root-level concern.
  }
}
