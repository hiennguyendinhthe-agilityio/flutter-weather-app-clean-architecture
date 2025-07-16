import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Comprehensive theme configuration for the entire app
/// Supports both Material and Cupertino design systems
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // === COLOR PALETTE ===
  
  /// Primary brand colors
  static const Color primaryColor = Color(0xFF007AFF);
  static const Color primaryDarkColor = Color(0xFF0051D5);
  static const Color primaryLightColor = Color(0xFF64B5F6);
  
  /// Secondary colors
  static const Color secondaryColor = Color(0xFF34C759);
  static const Color secondaryDarkColor = Color(0xFF248A3D);
  static const Color secondaryLightColor = Color(0xFF68D391);
  
  /// Accent colors
  static const Color accentColor = Color(0xFFFF9500);
  static const Color accentDarkColor = Color(0xFFCC7700);
  static const Color accentLightColor = Color(0xFFFFB84D);
  
  /// Neutral colors
  static const Color backgroundColor = Color(0xFFF2F2F7);
  static const Color backgroundDarkColor = Color(0xFF000000);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color surfaceDarkColor = Color(0xFF1C1C1E);
  
  /// Text colors
  static const Color textPrimaryColor = Color(0xFF000000);
  static const Color textPrimaryDarkColor = Color(0xFFFFFFFF);
  static const Color textSecondaryColor = Color(0xFF8E8E93);
  static const Color textSecondaryDarkColor = Color(0xFF8E8E93);
  
  /// Status colors
  static const Color errorColor = Color(0xFFFF3B30);
  static const Color warningColor = Color(0xFFFF9500);
  static const Color successColor = Color(0xFF34C759);
  static const Color infoColor = Color(0xFF007AFF);
  
  // === TYPOGRAPHY ===
  
  /// Text styles using Google Fonts
  static TextTheme get _baseTextTheme => GoogleFonts.interTextTheme();
  
  static TextTheme get lightTextTheme => _baseTextTheme.copyWith(
    displayLarge: _baseTextTheme.displayLarge?.copyWith(
      color: textPrimaryColor,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: _baseTextTheme.displayMedium?.copyWith(
      color: textPrimaryColor,
      fontWeight: FontWeight.w600,
    ),
    displaySmall: _baseTextTheme.displaySmall?.copyWith(
      color: textPrimaryColor,
      fontWeight: FontWeight.w600,
    ),
    headlineLarge: _baseTextTheme.headlineLarge?.copyWith(
      color: textPrimaryColor,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: _baseTextTheme.headlineMedium?.copyWith(
      color: textPrimaryColor,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: _baseTextTheme.headlineSmall?.copyWith(
      color: textPrimaryColor,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: _baseTextTheme.titleLarge?.copyWith(
      color: textPrimaryColor,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: _baseTextTheme.titleMedium?.copyWith(
      color: textPrimaryColor,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: _baseTextTheme.titleSmall?.copyWith(
      color: textSecondaryColor,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: _baseTextTheme.bodyLarge?.copyWith(
      color: textPrimaryColor,
    ),
    bodyMedium: _baseTextTheme.bodyMedium?.copyWith(
      color: textPrimaryColor,
    ),
    bodySmall: _baseTextTheme.bodySmall?.copyWith(
      color: textSecondaryColor,
    ),
    labelLarge: _baseTextTheme.labelLarge?.copyWith(
      color: textPrimaryColor,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: _baseTextTheme.labelMedium?.copyWith(
      color: textSecondaryColor,
    ),
    labelSmall: _baseTextTheme.labelSmall?.copyWith(
      color: textSecondaryColor,
    ),
  );
  
  static TextTheme get darkTextTheme => _baseTextTheme.copyWith(
    displayLarge: _baseTextTheme.displayLarge?.copyWith(
      color: textPrimaryDarkColor,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: _baseTextTheme.displayMedium?.copyWith(
      color: textPrimaryDarkColor,
      fontWeight: FontWeight.w600,
    ),
    displaySmall: _baseTextTheme.displaySmall?.copyWith(
      color: textPrimaryDarkColor,
      fontWeight: FontWeight.w600,
    ),
    headlineLarge: _baseTextTheme.headlineLarge?.copyWith(
      color: textPrimaryDarkColor,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: _baseTextTheme.headlineMedium?.copyWith(
      color: textPrimaryDarkColor,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: _baseTextTheme.headlineSmall?.copyWith(
      color: textPrimaryDarkColor,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: _baseTextTheme.titleLarge?.copyWith(
      color: textPrimaryDarkColor,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: _baseTextTheme.titleMedium?.copyWith(
      color: textPrimaryDarkColor,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: _baseTextTheme.titleSmall?.copyWith(
      color: textSecondaryDarkColor,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: _baseTextTheme.bodyLarge?.copyWith(
      color: textPrimaryDarkColor,
    ),
    bodyMedium: _baseTextTheme.bodyMedium?.copyWith(
      color: textPrimaryDarkColor,
    ),
    bodySmall: _baseTextTheme.bodySmall?.copyWith(
      color: textSecondaryDarkColor,
    ),
    labelLarge: _baseTextTheme.labelLarge?.copyWith(
      color: textPrimaryDarkColor,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: _baseTextTheme.labelMedium?.copyWith(
      color: textSecondaryDarkColor,
    ),
    labelSmall: _baseTextTheme.labelSmall?.copyWith(
      color: textSecondaryDarkColor,
    ),
  );
  
  // === MATERIAL THEME DATA ===
  
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      surface: surfaceColor,
      background: backgroundColor,
      error: errorColor,
    ),
    textTheme: lightTextTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceColor,
      foregroundColor: textPrimaryColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: lightTextTheme.titleLarge,
    ),
    cardTheme: CardThemeData(
      color: surfaceColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: backgroundColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: errorColor, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFFE5E5EA),
      thickness: 0.5,
    ),
  );
  
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
      primary: primaryLightColor,
      secondary: secondaryLightColor,
      tertiary: accentLightColor,
      surface: surfaceDarkColor,
      background: backgroundDarkColor,
      error: errorColor,
    ),
    textTheme: darkTextTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceDarkColor,
      foregroundColor: textPrimaryDarkColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: darkTextTheme.titleLarge,
    ),
    cardTheme: CardThemeData(
      color: surfaceDarkColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryLightColor,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryLightColor,
        side: const BorderSide(color: primaryLightColor),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryLightColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2C2C2E),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryLightColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: errorColor, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF38383A),
      thickness: 0.5,
    ),
  );
  
  // === CUPERTINO THEME DATA ===
  
  static CupertinoThemeData get lightCupertinoTheme => const CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    barBackgroundColor: surfaceColor,
    textTheme: CupertinoTextThemeData(
      primaryColor: textPrimaryColor,
      textStyle: TextStyle(
        color: textPrimaryColor,
        fontSize: 17,
        fontWeight: FontWeight.normal,
      ),
      navTitleTextStyle: TextStyle(
        color: textPrimaryColor,
        fontSize: 17,
        fontWeight: FontWeight.w600,
      ),
      navLargeTitleTextStyle: TextStyle(
        color: textPrimaryColor,
        fontSize: 34,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
  
  static CupertinoThemeData get darkCupertinoTheme => const CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryLightColor,
    scaffoldBackgroundColor: backgroundDarkColor,
    barBackgroundColor: surfaceDarkColor,
    textTheme: CupertinoTextThemeData(
      primaryColor: textPrimaryDarkColor,
      textStyle: TextStyle(
        color: textPrimaryDarkColor,
        fontSize: 17,
        fontWeight: FontWeight.normal,
      ),
      navTitleTextStyle: TextStyle(
        color: textPrimaryDarkColor,
        fontSize: 17,
        fontWeight: FontWeight.w600,
      ),
      navLargeTitleTextStyle: TextStyle(
        color: textPrimaryDarkColor,
        fontSize: 34,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
  
  // === UTILITY METHODS ===
  
  /// Get appropriate theme based on brightness
  static ThemeData getTheme(bool isDarkMode) {
    return isDarkMode ? darkTheme : lightTheme;
  }
  
  /// Get appropriate Cupertino theme based on brightness
  static CupertinoThemeData getCupertinoTheme(bool isDarkMode) {
    return isDarkMode ? darkCupertinoTheme : lightCupertinoTheme;
  }
  
  /// Get text color based on brightness
  static Color getTextColor(bool isDarkMode) {
    return isDarkMode ? textPrimaryDarkColor : textPrimaryColor;
  }
  
  /// Get background color based on brightness
  static Color getBackgroundColor(bool isDarkMode) {
    return isDarkMode ? backgroundDarkColor : backgroundColor;
  }
  
  /// Get surface color based on brightness
  static Color getSurfaceColor(bool isDarkMode) {
    return isDarkMode ? surfaceDarkColor : surfaceColor;
  }
}