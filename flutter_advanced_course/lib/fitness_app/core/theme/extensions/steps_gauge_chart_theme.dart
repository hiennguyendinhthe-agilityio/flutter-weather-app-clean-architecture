import 'package:flutter/material.dart';

class StepsGaugeChartTheme extends ThemeExtension<StepsGaugeChartTheme> {
  final Color? trackColor;
  final Color? progressColor;
  final TextStyle? titleStyle;
  final TextStyle? valueStyle;
  final TextStyle? goalStyle;

  const StepsGaugeChartTheme({
    this.trackColor,
    this.progressColor,
    this.titleStyle,
    this.valueStyle,
    this.goalStyle,
  });

  @override
  StepsGaugeChartTheme copyWith({
    Color? trackColor,
    Color? progressColor,
    TextStyle? titleStyle,
    TextStyle? valueStyle,
    TextStyle? goalStyle,
  }) {
    return StepsGaugeChartTheme(
      trackColor: trackColor ?? this.trackColor,
      progressColor: progressColor ?? this.progressColor,
      titleStyle: titleStyle ?? this.titleStyle,
      valueStyle: valueStyle ?? this.valueStyle,
      goalStyle: goalStyle ?? this.goalStyle,
    );
  }

  @override
  StepsGaugeChartTheme lerp(
    ThemeExtension<StepsGaugeChartTheme>? other,
    double t,
  ) {
    if (other is! StepsGaugeChartTheme) return this;
    return StepsGaugeChartTheme(
      trackColor: Color.lerp(trackColor, other.trackColor, t),
      progressColor: Color.lerp(progressColor, other.progressColor, t),
      titleStyle: TextStyle.lerp(titleStyle, other.titleStyle, t),
      valueStyle: TextStyle.lerp(valueStyle, other.valueStyle, t),
      goalStyle: TextStyle.lerp(goalStyle, other.goalStyle, t),
    );
  }
}
