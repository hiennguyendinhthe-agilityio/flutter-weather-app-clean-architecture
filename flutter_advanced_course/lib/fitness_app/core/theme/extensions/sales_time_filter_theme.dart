import 'package:flutter/material.dart';

class SalesTimeFilterTheme extends ThemeExtension<SalesTimeFilterTheme> {
  final Color? backgroundColor;
  final Color? activeBackgroundColor;
  final TextStyle? textStyle;
  final TextStyle? activeTextStyle;

  const SalesTimeFilterTheme({
    this.backgroundColor,
    this.activeBackgroundColor,
    this.textStyle,
    this.activeTextStyle,
  });

  @override
  SalesTimeFilterTheme copyWith({
    Color? backgroundColor,
    Color? activeBackgroundColor,
    TextStyle? textStyle,
    TextStyle? activeTextStyle,
  }) {
    return SalesTimeFilterTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      activeBackgroundColor:
          activeBackgroundColor ?? this.activeBackgroundColor,
      textStyle: textStyle ?? this.textStyle,
      activeTextStyle: activeTextStyle ?? this.activeTextStyle,
    );
  }

  @override
  SalesTimeFilterTheme lerp(
    ThemeExtension<SalesTimeFilterTheme>? other,
    double t,
  ) {
    if (other is! SalesTimeFilterTheme) return this;
    return SalesTimeFilterTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      activeBackgroundColor: Color.lerp(
        activeBackgroundColor,
        other.activeBackgroundColor,
        t,
      ),
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t),
      activeTextStyle: TextStyle.lerp(
        activeTextStyle,
        other.activeTextStyle,
        t,
      ),
    );
  }
}
