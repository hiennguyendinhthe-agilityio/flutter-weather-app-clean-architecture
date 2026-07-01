import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/tokens/color_tokens.dart';

/// Layer 2: Semantic — ColorScheme factory.
///
/// Maps Primitive Tokens → Material 3 ColorScheme semantic roles.
/// This is the ONLY place that knows which raw color maps to which M3 role.
///
/// Why Material 3 ColorScheme instead of a custom extension?
///   - Flutter's built-in component themes (AppBarTheme, CardTheme,
///     ElevatedButtonTheme, etc.) all fallback to ColorScheme roles
///     automatically. Populating ColorScheme correctly means most
///     components "just work" without additional configuration.
abstract final class FitnessColorScheme {
  FitnessColorScheme._();

  static ColorScheme dark() {
    return const ColorScheme(
      brightness: Brightness.dark,

      // Primary: Activity / main CTA
      primary: FitnessColorTokens.yellow300,
      onPrimary: FitnessColorTokens.neutral900,
      primaryContainer: FitnessColorTokens.neutral750,
      onPrimaryContainer: FitnessColorTokens.yellow300,

      // Secondary: Health metric
      secondary: FitnessColorTokens.green400,
      onSecondary: FitnessColorTokens.neutral900,
      secondaryContainer: FitnessColorTokens.neutral800,
      onSecondaryContainer: FitnessColorTokens.green400,

      // Tertiary: Sleep metric
      tertiary: FitnessColorTokens.blue500,
      onTertiary: FitnessColorTokens.neutralL100,
      tertiaryContainer: FitnessColorTokens.neutral800,
      onTertiaryContainer: FitnessColorTokens.blue500,

      // Surface
      surface: FitnessColorTokens.neutral800,
      onSurface: Colors.white,
      surfaceContainerHighest: FitnessColorTokens.neutral700,
      surfaceContainerHigh: FitnessColorTokens.neutral750,
      surfaceContainer: FitnessColorTokens.neutral800,
      surfaceContainerLow: FitnessColorTokens.neutral850,
      surfaceContainerLowest: FitnessColorTokens.neutral950,
      onSurfaceVariant: FitnessColorTokens.neutral300,

      // Scaffold / background
      // Note: scaffoldBackgroundColor is set directly in ThemeData,
      // but outlineVariant doubles as our border/divider color.
      outline: FitnessColorTokens.neutral700,
      outlineVariant: FitnessColorTokens.neutral700,

      // Status
      error: FitnessColorTokens.errorRed,
      onError: FitnessColorTokens.onErrorWhite,

      // Inverse
      inverseSurface: Colors.white,
      onInverseSurface: FitnessColorTokens.neutral900,
      inversePrimary: FitnessColorTokens.yellow600,

      // Shadow / scrim
      shadow: Colors.black,
      scrim: Colors.black,
    );
  }

  static ColorScheme light() {
    return const ColorScheme(
      brightness: Brightness.light,

      // Primary: Activity / main CTA
      primary: FitnessColorTokens.yellow600,
      onPrimary: FitnessColorTokens.neutralL100,
      primaryContainer: FitnessColorTokens.neutralL250,
      onPrimaryContainer: FitnessColorTokens.yellow600,

      // Secondary: Health metric
      secondary: FitnessColorTokens.green500,
      onSecondary: FitnessColorTokens.neutralL100,
      secondaryContainer: FitnessColorTokens.neutralL100,
      onSecondaryContainer: FitnessColorTokens.green500,

      // Tertiary: Sleep metric
      tertiary: FitnessColorTokens.blue700,
      onTertiary: FitnessColorTokens.neutralL100,
      tertiaryContainer: FitnessColorTokens.neutralL100,
      onTertiaryContainer: FitnessColorTokens.blue700,

      // Surface
      surface: FitnessColorTokens.neutralL100,
      onSurface: FitnessColorTokens.neutralL900,
      surfaceContainerHighest: FitnessColorTokens.neutralL200,
      surfaceContainerHigh: FitnessColorTokens.neutralL200,
      surfaceContainer: FitnessColorTokens.neutralL100,
      surfaceContainerLow: FitnessColorTokens.neutralL50,
      surfaceContainerLowest: FitnessColorTokens.neutralL50,
      onSurfaceVariant: FitnessColorTokens.neutralL700,

      // Border
      outline: FitnessColorTokens.neutralL200,
      outlineVariant: FitnessColorTokens.neutralL200,

      // Status
      error: FitnessColorTokens.errorRed,
      onError: FitnessColorTokens.onErrorWhite,

      // Inverse
      inverseSurface: FitnessColorTokens.neutral900,
      onInverseSurface: Colors.white,
      inversePrimary: FitnessColorTokens.yellow300,

      // Shadow / scrim
      shadow: Colors.black,
      scrim: Colors.black,
    );
  }
}
