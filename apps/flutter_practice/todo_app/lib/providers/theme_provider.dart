import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/theme.dart';

/// Enhanced theme provider with persistence and comprehensive theme management
class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'isDarkMode';
  
  bool _isDarkMode = false;
  bool _isSystemTheme = false;
  
  ThemeProvider() {
    _loadThemePreference();
  }

  // === GETTERS ===
  
  bool get isDarkMode => _isDarkMode;
  bool get isSystemTheme => _isSystemTheme;
  Brightness get brightness => _isDarkMode ? Brightness.dark : Brightness.light;
  
  // Theme data getters
  ThemeData get materialTheme => AppTheme.getTheme(_isDarkMode);
  CupertinoThemeData get cupertinoTheme => AppTheme.getCupertinoTheme(_isDarkMode);
  
  // Color getters for easy access
  Color get primaryColor => _isDarkMode ? AppTheme.primaryLightColor : AppTheme.primaryColor;
  Color get backgroundColor => AppTheme.getBackgroundColor(_isDarkMode);
  Color get surfaceColor => AppTheme.getSurfaceColor(_isDarkMode);
  Color get textColor => AppTheme.getTextColor(_isDarkMode);
  Color get secondaryTextColor => _isDarkMode 
      ? AppTheme.textSecondaryDarkColor 
      : AppTheme.textSecondaryColor;
  
  // Status colors (same for both themes)
  Color get errorColor => AppTheme.errorColor;
  Color get successColor => AppTheme.successColor;
  Color get warningColor => AppTheme.warningColor;
  Color get infoColor => AppTheme.infoColor;

  // === THEME MANAGEMENT ===
  
  /// Toggle between light and dark theme
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _isSystemTheme = false;
    _saveThemePreference();
    notifyListeners();
  }
  
  /// Set specific theme mode
  void setThemeMode(bool isDark) {
    if (_isDarkMode != isDark) {
      _isDarkMode = isDark;
      _isSystemTheme = false;
      _saveThemePreference();
      notifyListeners();
    }
  }
  
  /// Use system theme setting
  void useSystemTheme(Brightness systemBrightness) {
    _isSystemTheme = true;
    final newIsDarkMode = systemBrightness == Brightness.dark;
    
    if (_isDarkMode != newIsDarkMode) {
      _isDarkMode = newIsDarkMode;
      _saveThemePreference();
      notifyListeners();
    }
  }
  
  /// Update theme based on system brightness change
  void updateSystemTheme(Brightness systemBrightness) {
    if (_isSystemTheme) {
      final newIsDarkMode = systemBrightness == Brightness.dark;
      if (_isDarkMode != newIsDarkMode) {
        _isDarkMode = newIsDarkMode;
        notifyListeners();
      }
    }
  }

  // === PERSISTENCE ===
  
  /// Load theme preference from SharedPreferences
  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool(_themeKey) ?? false;
      _isSystemTheme = prefs.getBool('${_themeKey}_system') ?? false;
      notifyListeners();
    } catch (e) {
      // Handle error gracefully, use default theme
      debugPrint('Error loading theme preference: $e');
    }
  }
  
  /// Save theme preference to SharedPreferences
  Future<void> _saveThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, _isDarkMode);
      await prefs.setBool('${_themeKey}_system', _isSystemTheme);
    } catch (e) {
      // Handle error gracefully
      debugPrint('Error saving theme preference: $e');
    }
  }

  // === UTILITY METHODS ===
  
  /// Get theme mode as string for display
  String get themeModeString {
    if (_isSystemTheme) return 'System';
    return _isDarkMode ? 'Dark' : 'Light';
  }
  
  /// Check if current theme is light
  bool get isLightMode => !_isDarkMode;
  
  /// Get appropriate icon for current theme
  IconData get themeIcon {
    if (_isSystemTheme) return CupertinoIcons.device_phone_portrait;
    return _isDarkMode ? CupertinoIcons.moon_fill : CupertinoIcons.sun_max_fill;
  }
  
  /// Get theme description for settings
  String get themeDescription {
    if (_isSystemTheme) return 'Follows system setting';
    return _isDarkMode ? 'Dark mode enabled' : 'Light mode enabled';
  }
}
