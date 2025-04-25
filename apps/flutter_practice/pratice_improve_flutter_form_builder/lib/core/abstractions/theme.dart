import 'package:flutter/material.dart';

/// Abstract class for theme definitions
abstract class AbstractTheme {
  /// Primary color of the theme
  Color get primaryColor;

  /// Secondary color of the theme
  Color get secondaryColor;

  /// Background color of the theme
  Color get backgroundColor;

  /// Text color for primary elements
  Color get primaryTextColor;

  /// Text color for secondary elements
  Color get secondaryTextColor;

  /// Error color for the theme
  Color get errorColor;

  /// Success color for the theme
  Color get successColor;

  /// Border radius for components
  double get borderRadius;

  /// Padding for form fields
  EdgeInsets get fieldPadding;

  /// Get the text theme
  TextTheme get textTheme;

  /// Get the input decoration theme
  InputDecorationTheme get inputDecorationTheme;

  /// Get the button theme
  ButtonThemeData get buttonTheme;

  /// Get the complete theme data
  ThemeData get themeData;
}
