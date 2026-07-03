// Layer 4: ThemeData Assembly.
//
// This class is a PURE assembler. Its only job is to wire together
// the outputs of all lower layers:
//   Layer 1 (Tokens) → Layer 2 (Semantic) → Layer 3 (Component) → ThemeData
//
// Rules enforced here:
//   - NO raw [Color] literals. All colors come from [WeatherColorScheme]
//     (which reads [WeatherColorTokens]).
//   - NO raw font sizes. All typography comes from [WeatherTypographyTokens].
//   - NO business logic. This is configuration, not behavior.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/theme/extensions/glass_theme.dart';
import 'package:weather_app/theme/semantic/weather_color_scheme.dart';
import 'package:weather_app/theme/tokens/radius_tokens.dart';
import 'package:weather_app/theme/tokens/typography_tokens.dart';

abstract final class AppTheme {
  AppTheme._();

  // ── Public entry points ────────────────────────────────────────────────────

  static ThemeData light() => _build(WeatherColorScheme.light());

  static ThemeData dark() => _build(WeatherColorScheme.dark());

  // ── Private assembler ──────────────────────────────────────────────────────

  static ThemeData _build(ColorScheme colorScheme) {
    var textTheme = WeatherTypographyTokens.buildTextTheme();
    textTheme = GoogleFonts.outfitTextTheme(textTheme);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      extensions: [GlassTheme.universal()],
      // AppBar — transparent, blends into scaffold
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      // Card
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(WeatherRadiusTokens.lg),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      // Scaffold background
      scaffoldBackgroundColor: colorScheme.surface,
      // Input decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(WeatherRadiusTokens.sm),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}
