import 'package:flutter/material.dart';

import 'extensions/fitness_semantic_extension.dart';

/// Ergonomic accessors for the Fitness app's theme layers.
///
/// Usage in widgets:
///   final cs  = context.cs;      // ColorScheme — colors, surfaces, text roles
///   final ext = context.fitnessExt; // Gradients + accent series (not in M3)
///   final tt  = context.tt;      // TextTheme — typography scale
extension FitnessThemeContext on BuildContext {
  /// Material 3 [ColorScheme]. Prefer this for all color decisions.
  ColorScheme get cs => Theme.of(this).colorScheme;

  /// App [TextTheme] built from [FitnessTypographyTokens].
  TextTheme get tt => Theme.of(this).textTheme;

  /// The slim [FitnessSemanticExtension] — only gradients & chart accent colors.
  /// Only access this when you need data not expressible by [ColorScheme].
  FitnessSemanticExtension get fitnessExt =>
      Theme.of(this).extension<FitnessSemanticExtension>()!;
}
