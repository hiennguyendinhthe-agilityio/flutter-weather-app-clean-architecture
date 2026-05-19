import 'package:flutter/material.dart';

class SegmentedDonutChartTheme
    extends ThemeExtension<SegmentedDonutChartTheme> {
  final Color? trackColor;
  final TextStyle? centerValueStyle;
  final TextStyle? centerSubtitleStyle;
  final Color? dividerColor;

  const SegmentedDonutChartTheme({
    this.trackColor,
    this.centerValueStyle,
    this.centerSubtitleStyle,
    this.dividerColor,
  });

  @override
  SegmentedDonutChartTheme copyWith({
    Color? trackColor,
    TextStyle? centerValueStyle,
    TextStyle? centerSubtitleStyle,
    Color? dividerColor,
  }) {
    return SegmentedDonutChartTheme(
      trackColor: trackColor ?? this.trackColor,
      centerValueStyle: centerValueStyle ?? this.centerValueStyle,
      centerSubtitleStyle: centerSubtitleStyle ?? this.centerSubtitleStyle,
      dividerColor: dividerColor ?? this.dividerColor,
    );
  }

  @override
  SegmentedDonutChartTheme lerp(
    ThemeExtension<SegmentedDonutChartTheme>? other,
    double t,
  ) {
    if (other is! SegmentedDonutChartTheme) return this;
    return SegmentedDonutChartTheme(
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
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t),
    );
  }
}
