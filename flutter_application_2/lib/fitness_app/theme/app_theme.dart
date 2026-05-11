import 'package:flutter/material.dart';

import 'fitness_theme_extension.dart';

abstract final class AppTheme {
  AppTheme._();

  static ThemeData dark() =>
      _buildTheme(brightness: Brightness.dark, extension: _darkExtension);

  static ThemeData light() =>
      _buildTheme(brightness: Brightness.light, extension: _lightExtension);

  static ThemeData _buildTheme({
    required Brightness brightness,
    required FitnessThemeExtension extension,
  }) {
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: extension.activityColor,
      onPrimary: extension.scaffoldBackground,
      secondary: extension.healthColor,
      onSecondary: extension.scaffoldBackground,
      error: const Color(0xFFFF5C5C),
      onError: Colors.white,
      surface: extension.cardBackground,
      onSurface: extension.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: extension.scaffoldBackground,
      fontFamily: 'Inter',
      extensions: [extension],

      appBarTheme: AppBarTheme(
        backgroundColor: extension.scaffoldBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: extension.textPrimary,
          fontFamily: 'Inter',
        ),
        iconTheme: IconThemeData(color: extension.textPrimary, size: 24),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: extension.scaffoldBackground,
        selectedItemColor: extension.activityColor,
        unselectedItemColor: extension.textSecondary.withValues(alpha: 0.5),
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontFamily: 'Inter',
        ),
      ),

      cardTheme: CardThemeData(
        color: extension.cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: extension.cardBorder),
        ),
      ),
    );
  }

  static const FitnessThemeExtension _darkExtension = FitnessThemeExtension(
    scaffoldBackground: Color(0xFF14141E),
    cardBackground: Color(0xFF1C1C26),
    cardBorder: Color(0xFF282835),

    activityColor: Color(0xFFFFE03E),
    healthColor: Color(0xFF3AFF6E),
    sleepColor: Color(0xFF4A7BD9),

    chartTrackColor: Color(0xFF282835),

    textPrimary: Colors.white,
    textSecondary: Color(0xFF8B8B9B),
    textMuted: Color(0xFF5D5D6E),

    activityGradient: [Color(0xFF3AFF6E), Color(0xFFCBFF3E), Color(0xFFFFE03E)],
    healthGradient: [Color(0xFF5A94FF), Color(0xFF1DE5C2), Color(0xFF6BFF8E)],
    sleepGradient: [Color(0xFF1DE5C2), Color(0xFF5A94FF), Color(0xFF8B6AFF)],

    activityCardBackground: Color(0xFF1E1E30),
    activityCardBorder: Color(0xFF2A2A40),

    accentCyan: Color(0xFF1DE5C2),
    accentLime: Color(0xFFD6FF38),
    accentPink: Color(0xFFFF5CFF),
    accentBlue: Color(0xFF5A94FF),
  );

  static const FitnessThemeExtension _lightExtension = FitnessThemeExtension(
    scaffoldBackground: Color(0xFFF5F5FA),
    cardBackground: Color(0xFFFFFFFF),
    cardBorder: Color(0xFFE0E0EC),

    activityColor: Color(0xFFC9A500),
    healthColor: Color(0xFF1A9E45),
    sleepColor: Color(0xFF2E5BB5),

    chartTrackColor: Color(0xFFE0E0EC),

    textPrimary: Color(0xFF14141E),
    textSecondary: Color(0xFF6B6B7B),
    textMuted: Color(0xFFAAAAAA),

    activityGradient: [Color(0xFF1A9E45), Color(0xFF8FB800), Color(0xFFC9A500)],
    healthGradient: [Color(0xFF2E5BB5), Color(0xFF0DA89A), Color(0xFF1A9E45)],
    sleepGradient: [Color(0xFF0DA89A), Color(0xFF2E5BB5), Color(0xFF6B45CC)],

    activityCardBackground: Color(0xFFF0F0FF),
    activityCardBorder: Color(0xFFD8D8F0),

    accentCyan: Color(0xFF0DA89A),
    accentLime: Color(0xFF8FB800),
    accentPink: Color(0xFFCC3DCC),
    accentBlue: Color(0xFF2E5BB5),
  );
}
