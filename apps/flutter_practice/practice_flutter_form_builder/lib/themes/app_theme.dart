import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light() {
    const Color primaryColor = Color(0xFF3366FF);
    final ColorScheme lightColorScheme = const ColorScheme.light(
      primary: primaryColor,
      secondary: primaryColor,
      surface: Colors.white,
      outline: Color(0xFFDCDCDC),
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black87,
      onError: Colors.white,
    );

    return ThemeData(
      primaryColor: const Color(0xFF3366FF),
      colorScheme: lightColorScheme,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xFF3366FF), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF3366FF),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black87,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
