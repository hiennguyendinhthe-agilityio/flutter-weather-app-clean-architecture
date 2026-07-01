import 'package:flutter/material.dart';

/// Layer 3: Component Theme — AppBar.
///
/// Returns an [AppBarTheme] using M3-conformant ColorScheme roles:
///   - backgroundColor → surfaceContainer (per M3 spec for top app bars)
///   - foreground       → onSurface
///
/// Keeps raw values (font size, weight) by delegating to [TextTheme] so that
/// the only place these sizes exist is [FitnessTypographyTokens.buildTextTheme()].
abstract final class FitnessAppBarStyle {
  FitnessAppBarStyle._();

  static AppBarTheme appBarTheme(ColorScheme cs, TextTheme textTheme) {
    return AppBarTheme(
      // M3 spec: top app bar uses surfaceContainer
      backgroundColor: cs.surfaceContainer,
      foregroundColor: cs.onSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      titleTextStyle: textTheme.titleMedium?.copyWith(color: cs.onSurface),
      iconTheme: IconThemeData(color: cs.onSurface, size: 24),
      actionsIconTheme: IconThemeData(color: cs.onSurface, size: 24),
    );
  }
}
