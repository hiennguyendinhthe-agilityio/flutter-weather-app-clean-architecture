// Layer 2: Semantic — ColorScheme factory.
//
// Maps Primitive Tokens → Material 3 ColorScheme semantic roles.
// This is the ONLY place that knows which raw color maps to which M3 role.
//
// Why Material 3 ColorScheme instead of a custom extension?
//   - Flutter's built-in component themes (AppBarTheme, CardTheme,
//     ElevatedButtonTheme, etc.) all fallback to ColorScheme roles
//     automatically. Populating ColorScheme correctly means most
//     components "just work" without additional configuration.

import 'package:flutter/material.dart';
import 'package:weather_app/theme/tokens/color_tokens.dart';

abstract final class WeatherColorScheme {
  WeatherColorScheme._();

  static ColorScheme light() {
    return const ColorScheme(
      brightness: Brightness.light,
      // Primary — sky blue accent
      primary: Color(0xFF1A73E8),
      onPrimary: WeatherColorTokens.neutralL100,
      primaryContainer: Color(0xFFD3E3FD),
      onPrimaryContainer: Color(0xFF001C3B),
      // Secondary — soft cyan
      secondary: WeatherColorTokens.cyan500,
      onSecondary: WeatherColorTokens.neutralL100,
      secondaryContainer: Color(0xFFCCF5F0),
      onSecondaryContainer: Color(0xFF002019),
      // Tertiary — warm yellow (sun)
      tertiary: WeatherColorTokens.yellow600,
      onTertiary: WeatherColorTokens.neutralL100,
      tertiaryContainer: Color(0xFFFFF0B3),
      onTertiaryContainer: Color(0xFF221A00),
      // Error
      error: WeatherColorTokens.errorRed,
      onError: WeatherColorTokens.onErrorWhite,
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF410002),
      // Surface
      surface: WeatherColorTokens.neutralL50,
      onSurface: WeatherColorTokens.neutralL900,
      surfaceContainerHighest: WeatherColorTokens.neutralL200,
      onSurfaceVariant: WeatherColorTokens.neutralL700,
      // Outline
      outline: WeatherColorTokens.neutralL200,
      outlineVariant: WeatherColorTokens.neutralL300,
      // Inverse
      inverseSurface: WeatherColorTokens.neutral800,
      onInverseSurface: WeatherColorTokens.neutralL50,
      inversePrimary: Color(0xFFA8C8FF),
      // Scrim & Shadow
      scrim: WeatherColorTokens.neutral950,
      shadow: WeatherColorTokens.neutral950,
    );
  }

  static ColorScheme dark() {
    return const ColorScheme(
      brightness: Brightness.dark,
      // Primary — sky blue accent
      primary: Color(0xFF7CB9FF),
      onPrimary: Color(0xFF003063),
      primaryContainer: Color(0xFF00469D),
      onPrimaryContainer: Color(0xFFD3E3FD),
      // Secondary — cyan
      secondary: WeatherColorTokens.cyan400,
      onSecondary: Color(0xFF003730),
      secondaryContainer: Color(0xFF004F47),
      onSecondaryContainer: Color(0xFFCCF5F0),
      // Tertiary — sun yellow
      tertiary: WeatherColorTokens.yellow300,
      onTertiary: Color(0xFF3A2E00),
      tertiaryContainer: Color(0xFF544500),
      onTertiaryContainer: Color(0xFFFFF0B3),
      // Error
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),
      // Surface
      surface: WeatherColorTokens.neutral900,
      onSurface: WeatherColorTokens.neutralL50,
      surfaceContainerHighest: WeatherColorTokens.neutral700,
      onSurfaceVariant: WeatherColorTokens.neutral300,
      // Outline
      outline: WeatherColorTokens.neutral700,
      outlineVariant: WeatherColorTokens.neutral650,
      // Inverse
      inverseSurface: WeatherColorTokens.neutralL50,
      onInverseSurface: WeatherColorTokens.neutral900,
      inversePrimary: Color(0xFF1A73E8),
      // Scrim & Shadow
      scrim: WeatherColorTokens.neutral950,
      shadow: WeatherColorTokens.neutral950,
    );
  }
}
