import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const _primarySeed = Color(0xFF5E6AD2);
  static const _errorColor = Color(0xFFE53E3E);
  static const _successColor = Color(0xFF38A169);
  static const _warningColor = Color(0xFFD69E2E);

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primarySeed,
      brightness: Brightness.light,
    ),
    fontFamily: 'Roboto',

    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 1,
      backgroundColor: Colors.white,
      foregroundColor: Color(0xFF1A202C),
      titleTextStyle: TextStyle(
        color: Color(0xFF1A202C),
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
    ),

    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      color: Colors.white,
    ),

    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF7FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _primarySeed, width: 2),
      ),
      hintStyle: const TextStyle(color: Color(0xFFA0AEC0), fontSize: 14),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),

    scaffoldBackgroundColor: const Color(0xFFF7FAFC),
    dividerColor: const Color(0xFFE2E8F0),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primarySeed,
      brightness: Brightness.dark,
    ),
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: const Color(0xFF0F1117),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF2D3748)),
      ),
      color: const Color(0xFF1A1F2E),
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
      backgroundColor: Color(0xFF0F1117),
      foregroundColor: Colors.white,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),
  );

  static Color get error => _errorColor;
  static Color get success => _successColor;
  static Color get warning => _warningColor;

  static Color priorityColor(String priority) {
    return switch (priority.toLowerCase()) {
      'high' => _errorColor,
      'medium' => _warningColor,
      'low' => _successColor,
      _ => const Color(0xFF718096),
    };
  }
}
