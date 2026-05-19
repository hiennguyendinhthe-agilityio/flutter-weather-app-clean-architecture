import 'package:flutter/material.dart';

class SlidingToggleTheme extends ThemeExtension<SlidingToggleTheme> {
  final Color? backgroundColor;
  final Color? thumbColor;
  final TextStyle? textStyle;
  final TextStyle? selectedTextStyle;

  const SlidingToggleTheme({
    this.backgroundColor,
    this.thumbColor,
    this.textStyle,
    this.selectedTextStyle,
  });

  @override
  SlidingToggleTheme copyWith({
    Color? backgroundColor,
    Color? thumbColor,
    TextStyle? textStyle,
    TextStyle? selectedTextStyle,
  }) {
    return SlidingToggleTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      thumbColor: thumbColor ?? this.thumbColor,
      textStyle: textStyle ?? this.textStyle,
      selectedTextStyle: selectedTextStyle ?? this.selectedTextStyle,
    );
  }

  @override
  SlidingToggleTheme lerp(ThemeExtension<SlidingToggleTheme>? other, double t) {
    if (other is! SlidingToggleTheme) return this;
    return SlidingToggleTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      thumbColor: Color.lerp(thumbColor, other.thumbColor, t),
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t),
      selectedTextStyle: TextStyle.lerp(
        selectedTextStyle,
        other.selectedTextStyle,
        t,
      ),
    );
  }
}
