import 'package:flutter/material.dart';

class RingLegendItemTheme extends ThemeExtension<RingLegendItemTheme> {
  final TextStyle? labelStyle;

  const RingLegendItemTheme({this.labelStyle});

  @override
  RingLegendItemTheme copyWith({TextStyle? labelStyle}) {
    return RingLegendItemTheme(labelStyle: labelStyle ?? this.labelStyle);
  }

  @override
  RingLegendItemTheme lerp(
    ThemeExtension<RingLegendItemTheme>? other,
    double t,
  ) {
    if (other is! RingLegendItemTheme) return this;
    return RingLegendItemTheme(
      labelStyle: TextStyle.lerp(labelStyle, other.labelStyle, t),
    );
  }
}
