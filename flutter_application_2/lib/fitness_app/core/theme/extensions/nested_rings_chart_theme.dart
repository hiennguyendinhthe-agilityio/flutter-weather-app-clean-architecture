import 'package:flutter/material.dart';

class NestedRingsChartTheme extends ThemeExtension<NestedRingsChartTheme> {
  final TextStyle? percentageStyle;
  final TextStyle? subtitleStyle;

  const NestedRingsChartTheme({this.percentageStyle, this.subtitleStyle});

  @override
  NestedRingsChartTheme copyWith({
    TextStyle? percentageStyle,
    TextStyle? subtitleStyle,
  }) {
    return NestedRingsChartTheme(
      percentageStyle: percentageStyle ?? this.percentageStyle,
      subtitleStyle: subtitleStyle ?? this.subtitleStyle,
    );
  }

  @override
  NestedRingsChartTheme lerp(
    ThemeExtension<NestedRingsChartTheme>? other,
    double t,
  ) {
    if (other is! NestedRingsChartTheme) return this;
    return NestedRingsChartTheme(
      percentageStyle: TextStyle.lerp(
        percentageStyle,
        other.percentageStyle,
        t,
      ),
      subtitleStyle: TextStyle.lerp(subtitleStyle, other.subtitleStyle, t),
    );
  }
}
