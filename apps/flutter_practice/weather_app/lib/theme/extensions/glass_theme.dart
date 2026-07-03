import 'package:flutter/material.dart';

/// Layer 3: Component Theme Extension — Glassmorphism
///
/// Custom theme extension for Glassmorphism UI elements (cards, search bars)
/// that overlay the dynamic weather background images.
class GlassTheme extends ThemeExtension<GlassTheme> {
  final Color background;
  final Color backgroundHighlight;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color iconPrimary;
  final Color iconSecondary;
  final Color searchBackground;

  const GlassTheme({
    required this.background,
    required this.backgroundHighlight,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.iconPrimary,
    required this.iconSecondary,
    required this.searchBackground,
  });

  /// Factory for the default glassmorphism look (Light/Dark agnostic because
  /// it always sits on top of a vibrant landscape image).
  factory GlassTheme.universal() {
    return GlassTheme(
      background: Colors.white.withAlpha(220), // Bottom card bg
      backgroundHighlight: Colors.white.withAlpha(60), // Active states
      border: Colors.white.withAlpha(76), // Borders
      textPrimary: Colors.white, // Large temp, city name
      textSecondary: Colors.white.withAlpha(200), // Secondary text
      iconPrimary: Colors.white, // Main icons
      iconSecondary: Colors.white.withAlpha(204), // Search prefix icon
      searchBackground: Colors.white24, // Search bar / button bg
    );
  }

  @override
  ThemeExtension<GlassTheme> copyWith({
    Color? background,
    Color? backgroundHighlight,
    Color? border,
    Color? textPrimary,
    Color? textSecondary,
    Color? iconPrimary,
    Color? iconSecondary,
    Color? searchBackground,
  }) {
    return GlassTheme(
      background: background ?? this.background,
      backgroundHighlight: backgroundHighlight ?? this.backgroundHighlight,
      border: border ?? this.border,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      iconPrimary: iconPrimary ?? this.iconPrimary,
      iconSecondary: iconSecondary ?? this.iconSecondary,
      searchBackground: searchBackground ?? this.searchBackground,
    );
  }

  @override
  ThemeExtension<GlassTheme> lerp(ThemeExtension<GlassTheme>? other, double t) {
    if (other is! GlassTheme) return this;
    return GlassTheme(
      background: Color.lerp(background, other.background, t)!,
      backgroundHighlight: Color.lerp(
        backgroundHighlight,
        other.backgroundHighlight,
        t,
      )!,
      border: Color.lerp(border, other.border, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      iconPrimary: Color.lerp(iconPrimary, other.iconPrimary, t)!,
      iconSecondary: Color.lerp(iconSecondary, other.iconSecondary, t)!,
      searchBackground: Color.lerp(
        searchBackground,
        other.searchBackground,
        t,
      )!,
    );
  }
}
