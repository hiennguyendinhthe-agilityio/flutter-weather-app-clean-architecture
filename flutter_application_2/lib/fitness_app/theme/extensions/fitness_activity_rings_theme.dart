import 'package:flutter/material.dart';

class FitnessActivityRingsTheme
    extends ThemeExtension<FitnessActivityRingsTheme> {
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  const FitnessActivityRingsTheme({this.titleStyle, this.subtitleStyle});

  @override
  FitnessActivityRingsTheme copyWith({
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
  }) {
    return FitnessActivityRingsTheme(
      titleStyle: titleStyle ?? this.titleStyle,
      subtitleStyle: subtitleStyle ?? this.subtitleStyle,
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
    );
  }
}
