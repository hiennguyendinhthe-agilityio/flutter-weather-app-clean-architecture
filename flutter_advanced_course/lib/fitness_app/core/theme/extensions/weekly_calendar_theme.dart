import 'package:flutter/material.dart';

class WeeklyCalendarTheme extends ThemeExtension<WeeklyCalendarTheme> {
  final TextStyle? monthTextStyle;
  final TextStyle? dayTextStyle;
  final TextStyle? dateTextStyle;
  final TextStyle? selectedDateTextStyle;
  final Color? selectedBackgroundColor;
  final Color? todayIndicatorColor;

  const WeeklyCalendarTheme({
    this.monthTextStyle,
    this.dayTextStyle,
    this.dateTextStyle,
    this.selectedDateTextStyle,
    this.selectedBackgroundColor,
    this.todayIndicatorColor,
  });

  @override
  WeeklyCalendarTheme copyWith({
    TextStyle? monthTextStyle,
    TextStyle? dayTextStyle,
    TextStyle? dateTextStyle,
    TextStyle? selectedDateTextStyle,
    Color? selectedBackgroundColor,
    Color? todayIndicatorColor,
  }) {
    return WeeklyCalendarTheme(
      monthTextStyle: monthTextStyle ?? this.monthTextStyle,
      dayTextStyle: dayTextStyle ?? this.dayTextStyle,
      dateTextStyle: dateTextStyle ?? this.dateTextStyle,
      selectedDateTextStyle:
          selectedDateTextStyle ?? this.selectedDateTextStyle,
      selectedBackgroundColor:
          selectedBackgroundColor ?? this.selectedBackgroundColor,
      todayIndicatorColor: todayIndicatorColor ?? this.todayIndicatorColor,
    );
  }

  @override
  WeeklyCalendarTheme lerp(
    ThemeExtension<WeeklyCalendarTheme>? other,
    double t,
  ) {
    if (other is! WeeklyCalendarTheme) return this;
    return WeeklyCalendarTheme(
      monthTextStyle: TextStyle.lerp(monthTextStyle, other.monthTextStyle, t),
      dayTextStyle: TextStyle.lerp(dayTextStyle, other.dayTextStyle, t),
      dateTextStyle: TextStyle.lerp(dateTextStyle, other.dateTextStyle, t),
      selectedDateTextStyle: TextStyle.lerp(
        selectedDateTextStyle,
        other.selectedDateTextStyle,
        t,
      ),
      selectedBackgroundColor: Color.lerp(
        selectedBackgroundColor,
        other.selectedBackgroundColor,
        t,
      ),
      todayIndicatorColor: Color.lerp(
        todayIndicatorColor,
        other.todayIndicatorColor,
        t,
      ),
    );
  }
}
