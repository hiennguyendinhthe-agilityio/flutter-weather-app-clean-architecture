import 'package:flutter/material.dart';

class UserProfileHeaderTheme extends ThemeExtension<UserProfileHeaderTheme> {
  final TextStyle? greetingStyle;
  final TextStyle? nameStyle;
  final TextStyle? badgeTextStyle;
  final Color? badgeBackgroundColor;

  const UserProfileHeaderTheme({
    this.greetingStyle,
    this.nameStyle,
    this.badgeTextStyle,
    this.badgeBackgroundColor,
  });

  @override
  UserProfileHeaderTheme copyWith({
    TextStyle? greetingStyle,
    TextStyle? nameStyle,
    TextStyle? badgeTextStyle,
    Color? badgeBackgroundColor,
  }) {
    return UserProfileHeaderTheme(
      greetingStyle: greetingStyle ?? this.greetingStyle,
      nameStyle: nameStyle ?? this.nameStyle,
      badgeTextStyle: badgeTextStyle ?? this.badgeTextStyle,
      badgeBackgroundColor: badgeBackgroundColor ?? this.badgeBackgroundColor,
    );
  }

  @override
  UserProfileHeaderTheme lerp(
    ThemeExtension<UserProfileHeaderTheme>? other,
    double t,
  ) {
    if (other is! UserProfileHeaderTheme) return this;
    return UserProfileHeaderTheme(
      greetingStyle: TextStyle.lerp(greetingStyle, other.greetingStyle, t),
      nameStyle: TextStyle.lerp(nameStyle, other.nameStyle, t),
      badgeTextStyle: TextStyle.lerp(badgeTextStyle, other.badgeTextStyle, t),
      badgeBackgroundColor: Color.lerp(
        badgeBackgroundColor,
        other.badgeBackgroundColor,
        t,
      ),
    );
  }
}
