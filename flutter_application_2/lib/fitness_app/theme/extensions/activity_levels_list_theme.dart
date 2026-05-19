import 'package:flutter/material.dart';

class ActivityLevelsListTheme extends ThemeExtension<ActivityLevelsListTheme> {
  final TextStyle? titleStyle;
  final TextStyle? durationStyle;
  final Color? iconBackgroundColor;
  final Color? iconColor;

  const ActivityLevelsListTheme({
    this.titleStyle,
    this.durationStyle,
    this.iconBackgroundColor,
    this.iconColor,
  });

  @override
  ActivityLevelsListTheme copyWith({
    TextStyle? titleStyle,
    TextStyle? durationStyle,
    Color? iconBackgroundColor,
    Color? iconColor,
  }) {
    return ActivityLevelsListTheme(
      titleStyle: titleStyle ?? this.titleStyle,
      durationStyle: durationStyle ?? this.durationStyle,
      iconBackgroundColor: iconBackgroundColor ?? this.iconBackgroundColor,
      iconColor: iconColor ?? this.iconColor,
    );
  }

  @override
  ActivityLevelsListTheme lerp(
    ThemeExtension<ActivityLevelsListTheme>? other,
    double t,
  ) {
    if (other is! ActivityLevelsListTheme) return this;
    return ActivityLevelsListTheme(
      titleStyle: TextStyle.lerp(titleStyle, other.titleStyle, t),
      durationStyle: TextStyle.lerp(durationStyle, other.durationStyle, t),
      iconBackgroundColor: Color.lerp(
        iconBackgroundColor,
        other.iconBackgroundColor,
        t,
      ),
      iconColor: Color.lerp(iconColor, other.iconColor, t),
    );
  }
}
