import 'package:flutter/material.dart';
import 'package:weather_app/theme/extensions/glass_theme.dart';

extension ThemeContextExt on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => theme.colorScheme;
  TextTheme get text => theme.textTheme;
  GlassTheme get glass => theme.extension<GlassTheme>()!;
}
