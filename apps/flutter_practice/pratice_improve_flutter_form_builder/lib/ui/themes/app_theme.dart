import 'package:flutter/material.dart';

import '../../core/abstractions/theme.dart';

class AppTheme implements AbstractTheme {
  final bool isDarkMode;

  AppTheme({this.isDarkMode = false});

  @override
  Color get primaryColor => const Color(0xFF5865F2); // Discord blue

  @override
  Color get secondaryColor => const Color(0xFF57F287); // Discord green

  @override
  Color get backgroundColor =>
      isDarkMode ? const Color(0xFF36393F) : Colors.white;

  @override
  Color get primaryTextColor =>
      isDarkMode ? Colors.white : const Color(0xFF23272A);

  @override
  Color get secondaryTextColor =>
      isDarkMode ? const Color(0xFFB9BBBE) : const Color(0xFF72767D);

  @override
  Color get errorColor => const Color(0xFFED4245); // Discord red

  @override
  Color get successColor => const Color(0xFF57F287); // Discord green

  @override
  double get borderRadius => 8.0;

  @override
  EdgeInsets get fieldPadding =>
      const EdgeInsets.symmetric(vertical: 12, horizontal: 16);

  @override
  TextTheme get textTheme => TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: primaryTextColor,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: primaryTextColor,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: primaryTextColor,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: primaryTextColor,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: primaryTextColor,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: primaryTextColor,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: primaryTextColor,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: secondaryTextColor,
        ),
      );

  @override
  InputDecorationTheme get inputDecorationTheme => InputDecorationTheme(
        filled: true,
        fillColor:
            isDarkMode ? const Color(0xFF2F3136) : const Color(0xFFF2F3F5),
        contentPadding: fieldPadding,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: errorColor, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: errorColor, width: 2),
        ),
        errorStyle: TextStyle(color: errorColor),
        hintStyle: TextStyle(color: secondaryTextColor),
      );

  @override
  ButtonThemeData get buttonTheme => ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        buttonColor: primaryColor,
        textTheme: ButtonTextTheme.primary,
      );

  @override
  ThemeData get themeData => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme(
          brightness: isDarkMode ? Brightness.dark : Brightness.light,
          primary: primaryColor,
          onPrimary: Colors.white,
          secondary: secondaryColor,
          onSecondary: Colors.white,
          error: errorColor,
          onError: Colors.white,
          surface: backgroundColor,
          onSurface: primaryTextColor,
          primaryContainer: secondaryTextColor,
        ),
        scaffoldBackgroundColor: backgroundColor,
        textTheme: textTheme,
        inputDecorationTheme: inputDecorationTheme,
        buttonTheme: buttonTheme,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: primaryColor,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        ),
      );
}
