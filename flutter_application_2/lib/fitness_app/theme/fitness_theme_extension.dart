import 'package:flutter/material.dart';

@immutable
class FitnessThemeExtension extends ThemeExtension<FitnessThemeExtension> {
  final Color scaffoldBackground;
  final Color cardBackground;
  final Color cardBorder;

  final Color activityColor;
  final Color healthColor;
  final Color sleepColor;

  final Color chartTrackColor;

  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;

  final List<Color> activityGradient;
  final List<Color> healthGradient;
  final List<Color> sleepGradient;

  final Color activityCardBackground;
  final Color activityCardBorder;

  final Color accentCyan;
  final Color accentLime;
  final Color accentPink;
  final Color accentBlue;

  const FitnessThemeExtension({
    required this.scaffoldBackground,
    required this.cardBackground,
    required this.cardBorder,
    required this.activityColor,
    required this.healthColor,
    required this.sleepColor,
    required this.chartTrackColor,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.activityGradient,
    required this.healthGradient,
    required this.sleepGradient,
    required this.activityCardBackground,
    required this.activityCardBorder,
    required this.accentCyan,
    required this.accentLime,
    required this.accentPink,
    required this.accentBlue,
  });

  @override
  FitnessThemeExtension copyWith({
    Color? scaffoldBackground,
    Color? cardBackground,
    Color? cardBorder,
    Color? activityColor,
    Color? healthColor,
    Color? sleepColor,
    Color? chartTrackColor,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    List<Color>? activityGradient,
    List<Color>? healthGradient,
    List<Color>? sleepGradient,
    Color? activityCardBackground,
    Color? activityCardBorder,
    Color? accentCyan,
    Color? accentLime,
    Color? accentPink,
    Color? accentBlue,
  }) {
    return FitnessThemeExtension(
      scaffoldBackground: scaffoldBackground ?? this.scaffoldBackground,
      cardBackground: cardBackground ?? this.cardBackground,
      cardBorder: cardBorder ?? this.cardBorder,
      activityColor: activityColor ?? this.activityColor,
      healthColor: healthColor ?? this.healthColor,
      sleepColor: sleepColor ?? this.sleepColor,
      chartTrackColor: chartTrackColor ?? this.chartTrackColor,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      activityGradient: activityGradient ?? this.activityGradient,
      healthGradient: healthGradient ?? this.healthGradient,
      sleepGradient: sleepGradient ?? this.sleepGradient,
      activityCardBackground:
          activityCardBackground ?? this.activityCardBackground,
      activityCardBorder: activityCardBorder ?? this.activityCardBorder,
      accentCyan: accentCyan ?? this.accentCyan,
      accentLime: accentLime ?? this.accentLime,
      accentPink: accentPink ?? this.accentPink,
      accentBlue: accentBlue ?? this.accentBlue,
    );
  }

  @override
  FitnessThemeExtension lerp(covariant FitnessThemeExtension? other, double t) {
    if (other == null) return this;
    return FitnessThemeExtension(
      scaffoldBackground: Color.lerp(
        scaffoldBackground,
        other.scaffoldBackground,
        t,
      )!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      activityColor: Color.lerp(activityColor, other.activityColor, t)!,
      healthColor: Color.lerp(healthColor, other.healthColor, t)!,
      sleepColor: Color.lerp(sleepColor, other.sleepColor, t)!,
      chartTrackColor: Color.lerp(chartTrackColor, other.chartTrackColor, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      activityGradient: List.generate(
        activityGradient.length,
        (i) => Color.lerp(activityGradient[i], other.activityGradient[i], t)!,
      ),
      healthGradient: List.generate(
        healthGradient.length,
        (i) => Color.lerp(healthGradient[i], other.healthGradient[i], t)!,
      ),
      sleepGradient: List.generate(
        sleepGradient.length,
        (i) => Color.lerp(sleepGradient[i], other.sleepGradient[i], t)!,
      ),
      activityCardBackground: Color.lerp(
        activityCardBackground,
        other.activityCardBackground,
        t,
      )!,
      activityCardBorder: Color.lerp(
        activityCardBorder,
        other.activityCardBorder,
        t,
      )!,
      accentCyan: Color.lerp(accentCyan, other.accentCyan, t)!,
      accentLime: Color.lerp(accentLime, other.accentLime, t)!,
      accentPink: Color.lerp(accentPink, other.accentPink, t)!,
      accentBlue: Color.lerp(accentBlue, other.accentBlue, t)!,
    );
  }
}
