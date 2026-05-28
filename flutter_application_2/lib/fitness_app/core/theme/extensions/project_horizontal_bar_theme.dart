import 'package:flutter/material.dart';

class ProjectHorizontalBarTheme
    extends ThemeExtension<ProjectHorizontalBarTheme> {
  final TextStyle? titleStyle;
  final TextStyle? valueStyle;
  final Color? trackColor;

  const ProjectHorizontalBarTheme({
    this.titleStyle,
    this.valueStyle,
    this.trackColor,
  });

  @override
  ProjectHorizontalBarTheme copyWith({
    TextStyle? titleStyle,
    TextStyle? valueStyle,
    Color? trackColor,
  }) {
    return ProjectHorizontalBarTheme(
      titleStyle: titleStyle ?? this.titleStyle,
      valueStyle: valueStyle ?? this.valueStyle,
      trackColor: trackColor ?? this.trackColor,
    );
  }

  @override
  ProjectHorizontalBarTheme lerp(
    ThemeExtension<ProjectHorizontalBarTheme>? other,
    double t,
  ) {
    if (other is! ProjectHorizontalBarTheme) return this;
    return ProjectHorizontalBarTheme(
      titleStyle: TextStyle.lerp(titleStyle, other.titleStyle, t),
      valueStyle: TextStyle.lerp(valueStyle, other.valueStyle, t),
      trackColor: Color.lerp(trackColor, other.trackColor, t),
    );
  }
}
