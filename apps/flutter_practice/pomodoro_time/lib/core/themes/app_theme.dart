import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.light().textTheme,
      ),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF121212),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      textTheme: GoogleFonts.sourceSerifProTextTheme(
        ThemeData.dark().textTheme,
      ),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
    );
  }
}

class PomodoroThemeColors {
  final Color primary;
  final Color secondary;
  final Color background;

  PomodoroThemeColors({
    required this.primary,
    required this.secondary,
    required this.background,
  });
}

class PomodoroColorTheme {
  static PomodoroThemeColors getThemeColors(int duration,
      {bool isDarkMode = false}) {
    switch (duration) {
      case 5:
        return PomodoroThemeColors(
          primary: Colors.green,
          secondary: Colors.lightGreen,
          background: isDarkMode ? Colors.black : const Color(0xFFF0F8F0),
        );
      case 10:
        return PomodoroThemeColors(
          primary: Colors.blue,
          secondary: Colors.lightBlue,
          background: isDarkMode ? Colors.black : const Color(0xFFF0F4FF),
        );
      case 20:
        return PomodoroThemeColors(
          primary: Colors.orange,
          secondary: Colors.amber,
          background: isDarkMode ? Colors.black : const Color(0xFFFFF8F0),
        );
      case 25:
        return PomodoroThemeColors(
          primary: Colors.red,
          secondary: Colors.redAccent,
          background: isDarkMode ? Colors.black : const Color(0xFFFFF0F0),
        );
      case 30:
        return PomodoroThemeColors(
          primary: Colors.purple,
          secondary: Colors.purpleAccent,
          background: isDarkMode ? Colors.black : const Color(0xFFF8F0FF),
        );
      default:
        if (duration < 15) {
          return PomodoroThemeColors(
            primary: Colors.teal,
            secondary: Colors.tealAccent,
            background: isDarkMode ? Colors.black : const Color(0xFFF0FFFF),
          );
        } else if (duration < 25) {
          return PomodoroThemeColors(
            primary: Colors.deepOrange,
            secondary: Colors.orangeAccent,
            background: isDarkMode ? Colors.black : const Color(0xFFFFF4F0),
          );
        } else {
          return PomodoroThemeColors(
            primary: Colors.indigo,
            secondary: Colors.indigoAccent,
            background: isDarkMode ? Colors.black : const Color(0xFFF0F0FF),
          );
        }
    }
  }
}
