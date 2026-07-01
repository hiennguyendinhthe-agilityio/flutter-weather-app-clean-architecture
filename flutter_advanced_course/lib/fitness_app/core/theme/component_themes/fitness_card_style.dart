import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/tokens/radius_tokens.dart';

/// Layer 3: Component Theme — Card.
///
/// Returns a [CardThemeData] configured for the Fitness app's visual language.
/// By setting this in [ThemeData.cardTheme], every [Card] widget in the app
/// automatically inherits the correct surface color, elevation, and shape
/// WITHOUT needing per-widget style overrides.
abstract final class FitnessCardStyle {
  FitnessCardStyle._();

  static CardThemeData cardTheme(ColorScheme cs) {
    return CardThemeData(
      color: cs.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(FitnessRadiusTokens.xl),
        side: BorderSide(color: cs.outlineVariant, width: 1.0),
      ),
      clipBehavior: Clip.antiAlias,
    );
  }
}
