import 'package:flutter/material.dart';

/// Layer 3: Component Theme — Expense Donut Chart.
///
/// This defines the visual properties specifically for the [ExpenseDonutChart]
/// custom component.
class ExpenseDonutChartTheme extends ThemeExtension<ExpenseDonutChartTheme> {
  final Color? trackColor;
  final TextStyle? centerValueStyle;
  final TextStyle? centerSubtitleStyle;
  final Color? badgeBackgroundColor;
  final Color? badgeIconColor;
  final Color? radialTextColor;

  const ExpenseDonutChartTheme({
    this.trackColor,
    this.centerValueStyle,
    this.centerSubtitleStyle,
    this.badgeBackgroundColor,
    this.badgeIconColor,
    this.radialTextColor,
  });

  @override
  ExpenseDonutChartTheme copyWith({
    Color? trackColor,
    TextStyle? centerValueStyle,
    TextStyle? centerSubtitleStyle,
    Color? badgeBackgroundColor,
    Color? badgeIconColor,
    Color? radialTextColor,
  }) {
    return ExpenseDonutChartTheme(
      trackColor: trackColor ?? this.trackColor,
      centerValueStyle: centerValueStyle ?? this.centerValueStyle,
      centerSubtitleStyle: centerSubtitleStyle ?? this.centerSubtitleStyle,
      badgeBackgroundColor: badgeBackgroundColor ?? this.badgeBackgroundColor,
      badgeIconColor: badgeIconColor ?? this.badgeIconColor,
      radialTextColor: radialTextColor ?? this.radialTextColor,
    );
  }

  @override
  ExpenseDonutChartTheme lerp(
    ThemeExtension<ExpenseDonutChartTheme>? other,
    double t,
  ) {
    if (other is! ExpenseDonutChartTheme) {
      return this;
    }
    return ExpenseDonutChartTheme(
      trackColor: Color.lerp(trackColor, other.trackColor, t),
      centerValueStyle: TextStyle.lerp(
        centerValueStyle,
        other.centerValueStyle,
        t,
      ),
      centerSubtitleStyle: TextStyle.lerp(
        centerSubtitleStyle,
        other.centerSubtitleStyle,
        t,
      ),
      badgeBackgroundColor: Color.lerp(
        badgeBackgroundColor,
        other.badgeBackgroundColor,
        t,
      ),
      badgeIconColor: Color.lerp(badgeIconColor, other.badgeIconColor, t),
      radialTextColor: Color.lerp(radialTextColor, other.radialTextColor, t),
    );
  }
}
