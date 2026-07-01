import 'package:flutter/material.dart';

/// Layer 3: Component Theme — Heart Rate Chart.
///
/// This defines the visual properties specifically for the [HeartRateChart]
/// custom component, following the same pattern as Flutter's internal
/// [CardTheme] or [AppBarTheme].
class HeartRateChartTheme extends ThemeExtension<HeartRateChartTheme> {
  final Color? backgroundColor;
  final Color? barColor;
  final TextStyle? titleStyle;
  final TextStyle? valueStyle;
  final TextStyle? unitStyle;

  const HeartRateChartTheme({
    this.backgroundColor,
    this.barColor,
    this.titleStyle,
    this.valueStyle,
    this.unitStyle,
  });

  @override
  HeartRateChartTheme copyWith({
    Color? backgroundColor,
    Color? barColor,
    TextStyle? titleStyle,
    TextStyle? valueStyle,
    TextStyle? unitStyle,
  }) {
    return HeartRateChartTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      barColor: barColor ?? this.barColor,
      titleStyle: titleStyle ?? this.titleStyle,
      valueStyle: valueStyle ?? this.valueStyle,
      unitStyle: unitStyle ?? this.unitStyle,
    );
  }

  @override
  HeartRateChartTheme lerp(
    ThemeExtension<HeartRateChartTheme>? other,
    double t,
  ) {
    if (other is! HeartRateChartTheme) {
      return this;
    }
    return HeartRateChartTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      barColor: Color.lerp(barColor, other.barColor, t),
      titleStyle: TextStyle.lerp(titleStyle, other.titleStyle, t),
      valueStyle: TextStyle.lerp(valueStyle, other.valueStyle, t),
      unitStyle: TextStyle.lerp(unitStyle, other.unitStyle, t),
    );
  }
}
