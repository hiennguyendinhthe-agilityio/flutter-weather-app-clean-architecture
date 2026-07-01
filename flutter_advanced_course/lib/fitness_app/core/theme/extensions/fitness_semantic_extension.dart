import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/tokens/color_tokens.dart';

/// Layer 2: Semantic Extension — App-specific values not covered by ColorScheme.
///
/// WHY this extension is justified:
///   - Material 3 [ColorScheme] has no concept of multi-stop gradients.
///   - Category-specific brand colors (activity/health/sleep) are fitness-domain
///     concepts unknown to the Flutter SDK.
///   - [ThemeExtension] is the Flutter-official mechanism for extending ThemeData
///     with custom data. It must be kept minimal: ONLY what ColorScheme cannot express.
///
/// WHY certain fields were REMOVED vs the old FitnessThemeExtension:
///   - scaffoldBackground → ColorScheme.surfaceContainerLowest / ThemeData.scaffoldBackgroundColor
///   - cardBackground     → ColorScheme.surface
///   - cardBorder         → ColorScheme.outlineVariant
///   - textPrimary        → ColorScheme.onSurface
///   - textSecondary      → ColorScheme.onSurfaceVariant
///   - accentCyan/Lime/Pink/Blue → expressed via ColorScheme.tertiary, secondary, etc.
@immutable
class FitnessSemanticExtension
    extends ThemeExtension<FitnessSemanticExtension> {
  /// Multi-stop gradient for the Activity metric ring/chart.
  final List<Color> activityGradient;

  /// Multi-stop gradient for the Health metric ring/chart.
  final List<Color> healthGradient;

  /// Multi-stop gradient for the Sleep metric ring/chart.
  final List<Color> sleepGradient;

  /// Accent colors for data-visualization category series.
  /// These cannot be expressed via ColorScheme roles (they are chart series,
  /// not UI semantic roles) and change per brightness.
  final Color accentCyan;
  final Color accentLime;
  final Color accentPink;
  final Color accentBlue;

  const FitnessSemanticExtension({
    required this.activityGradient,
    required this.healthGradient,
    required this.sleepGradient,
    required this.accentCyan,
    required this.accentLime,
    required this.accentPink,
    required this.accentBlue,
  });

  // ── Named constructors (Dark / Light) ──

  const FitnessSemanticExtension.dark()
    : activityGradient = const [
        FitnessColorTokens.green400,
        FitnessColorTokens.yellow500,
        FitnessColorTokens.yellow300,
      ],
      healthGradient = const [
        FitnessColorTokens.blue300,
        FitnessColorTokens.cyan400,
        FitnessColorTokens.green300,
      ],
      sleepGradient = const [
        FitnessColorTokens.cyan400,
        FitnessColorTokens.blue300,
        FitnessColorTokens.purple400,
      ],
      accentCyan = FitnessColorTokens.cyan400,
      accentLime = FitnessColorTokens.yellow400,
      accentPink = FitnessColorTokens.pink400,
      accentBlue = FitnessColorTokens.blue300;

  const FitnessSemanticExtension.light()
    : activityGradient = const [
        FitnessColorTokens.green500,
        FitnessColorTokens.yellow700,
        FitnessColorTokens.yellow600,
      ],
      healthGradient = const [
        FitnessColorTokens.blue700,
        FitnessColorTokens.cyan500,
        FitnessColorTokens.green500,
      ],
      sleepGradient = const [
        FitnessColorTokens.cyan500,
        FitnessColorTokens.blue700,
        FitnessColorTokens.purple600,
      ],
      accentCyan = FitnessColorTokens.cyan500,
      accentLime = FitnessColorTokens.yellow700,
      accentPink = FitnessColorTokens.purple700,
      accentBlue = FitnessColorTokens.blue700;

  // ── ThemeExtension contract ──

  @override
  FitnessSemanticExtension copyWith({
    List<Color>? activityGradient,
    List<Color>? healthGradient,
    List<Color>? sleepGradient,
    Color? accentCyan,
    Color? accentLime,
    Color? accentPink,
    Color? accentBlue,
  }) {
    return FitnessSemanticExtension(
      activityGradient: activityGradient ?? this.activityGradient,
      healthGradient: healthGradient ?? this.healthGradient,
      sleepGradient: sleepGradient ?? this.sleepGradient,
      accentCyan: accentCyan ?? this.accentCyan,
      accentLime: accentLime ?? this.accentLime,
      accentPink: accentPink ?? this.accentPink,
      accentBlue: accentBlue ?? this.accentBlue,
    );
  }

  @override
  FitnessSemanticExtension lerp(
    covariant FitnessSemanticExtension? other,
    double t,
  ) {
    if (other == null) return this;
    return FitnessSemanticExtension(
      activityGradient: _lerpColorList(
        activityGradient,
        other.activityGradient,
        t,
      ),
      healthGradient: _lerpColorList(healthGradient, other.healthGradient, t),
      sleepGradient: _lerpColorList(sleepGradient, other.sleepGradient, t),
      accentCyan: Color.lerp(accentCyan, other.accentCyan, t)!,
      accentLime: Color.lerp(accentLime, other.accentLime, t)!,
      accentPink: Color.lerp(accentPink, other.accentPink, t)!,
      accentBlue: Color.lerp(accentBlue, other.accentBlue, t)!,
    );
  }

  static List<Color> _lerpColorList(List<Color> a, List<Color> b, double t) {
    final length = a.length < b.length ? a.length : b.length;
    return List.generate(length, (i) => Color.lerp(a[i], b[i], t)!);
  }
}
