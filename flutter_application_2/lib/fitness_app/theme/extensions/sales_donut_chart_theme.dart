import 'package:flutter/material.dart';

class SalesDonutChartTheme extends ThemeExtension<SalesDonutChartTheme> {
  final Color? trackColor;
  final Color? progressColor;
  final Color? iconBackgroundColor;
  final Color? iconInnerColor;
  final Color? iconColor;
  final TextStyle? percentageStyle;
  final TextStyle? valueStyle;

  const SalesDonutChartTheme({
    this.trackColor,
    this.progressColor,
    this.iconBackgroundColor,
    this.iconInnerColor,
    this.iconColor,
    this.percentageStyle,
    this.valueStyle,
  });

  @override
  SalesDonutChartTheme copyWith({
    Color? trackColor,
    Color? progressColor,
    Color? iconBackgroundColor,
    Color? iconInnerColor,
    Color? iconColor,
    TextStyle? percentageStyle,
    TextStyle? valueStyle,
  }) {
    return SalesDonutChartTheme(
      trackColor: trackColor ?? this.trackColor,
      progressColor: progressColor ?? this.progressColor,
      iconBackgroundColor: iconBackgroundColor ?? this.iconBackgroundColor,
      iconInnerColor: iconInnerColor ?? this.iconInnerColor,
      iconColor: iconColor ?? this.iconColor,
      percentageStyle: percentageStyle ?? this.percentageStyle,
      valueStyle: valueStyle ?? this.valueStyle,
    );
  }

  @override
  SalesDonutChartTheme lerp(
    ThemeExtension<SalesDonutChartTheme>? other,
    double t,
  ) {
    if (other is! SalesDonutChartTheme) return this;
    return SalesDonutChartTheme(
      trackColor: Color.lerp(trackColor, other.trackColor, t),
      progressColor: Color.lerp(progressColor, other.progressColor, t),
      iconBackgroundColor: Color.lerp(
        iconBackgroundColor,
        other.iconBackgroundColor,
        t,
      ),
      iconInnerColor: Color.lerp(iconInnerColor, other.iconInnerColor, t),
      iconColor: Color.lerp(iconColor, other.iconColor, t),
      percentageStyle: TextStyle.lerp(
        percentageStyle,
        other.percentageStyle,
        t,
      ),
      valueStyle: TextStyle.lerp(valueStyle, other.valueStyle, t),
    );
  }
}
