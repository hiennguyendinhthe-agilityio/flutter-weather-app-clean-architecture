import 'package:flutter/material.dart';

class FitnessActivityRingsTheme
    extends ThemeExtension<FitnessActivityRingsTheme> {
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final Color? trackColor;

  const FitnessActivityRingsTheme({
    this.titleStyle,
    this.subtitleStyle,
    this.trackColor,
  });

  @override
  FitnessActivityRingsTheme copyWith({
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    Color? trackColor,
  }) {
    return FitnessActivityRingsTheme(
      titleStyle: titleStyle ?? this.titleStyle,
      subtitleStyle: subtitleStyle ?? this.subtitleStyle,
      trackColor: trackColor ?? this.trackColor,
    );
  }

  @override
  FitnessActivityRingsTheme lerp(
    ThemeExtension<FitnessActivityRingsTheme>? other,
    double t,
  ) {
    if (other is! FitnessActivityRingsTheme) return this;
    return FitnessActivityRingsTheme(
      titleStyle: TextStyle.lerp(titleStyle, other.titleStyle, t),
      subtitleStyle: TextStyle.lerp(subtitleStyle, other.subtitleStyle, t),
      trackColor: Color.lerp(trackColor, other.trackColor, t),
    );
  }
}
