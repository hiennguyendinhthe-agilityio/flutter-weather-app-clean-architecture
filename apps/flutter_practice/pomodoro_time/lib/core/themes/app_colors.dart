import 'package:flutter/material.dart';
import 'package:task_management_app/core/themes/app_palette.dart';

class PtColors {
  static ColorScheme light = ColorScheme(
    brightness: Brightness.light,
    primary: PtPalette.yellow[5]!,
    onPrimary: Colors.white,
    secondary: PtPalette.green[5]!,
    onSecondary: Colors.white,
    error: PtPalette.red[5]!,
    onError: Colors.white,
    surface: PtPalette.grey[4]!,
    onSurface: PtPalette.grey[5]!,
    onSurfaceVariant: PtPalette.grey[10],
    outline: PtPalette.grey[2]!,
    surfaceContainer: PtPalette.grey[3]!,
  );
}
