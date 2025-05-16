import 'package:flutter/material.dart';

class PomodoroColorTheme {
  static const Map<int, PomodoroThemeColors> themeColors = {
    5: PomodoroThemeColors(
      primary: Color(0xFF4CAF50),
      secondary: Color(0xFF81C784),
      background: Color(0xFFE8F5E9),
    ),
    10: PomodoroThemeColors(
      primary: Color(0xFF2196F3),
      secondary: Color(0xFF64B5F6),
      background: Color(0xFFE3F2FD),
    ),
    20: PomodoroThemeColors(
      primary: Color(0xFFFFA000),
      secondary: Color(0xFFFFCA28),
      background: Color(0xFFFFF8E1),
    ),
    25: PomodoroThemeColors(
      primary: Color(0xFFE91E63),
      secondary: Color(0xFFF48FB1),
      background: Color(0xFFFCE4EC),
    ),
    30: PomodoroThemeColors(
      primary: Color(0xFF9C27B0),
      secondary: Color(0xFFBA68C8),
      background: Color(0xFFF3E5F5),
    ),
  };

  static PomodoroThemeColors getThemeColors(int duration) {
    return themeColors[duration] ?? themeColors[25]!;
  }
}

class PomodoroThemeColors {
  final Color primary;
  final Color secondary;
  final Color background;

  const PomodoroThemeColors({
    required this.primary,
    required this.secondary,
    required this.background,
  });
}
