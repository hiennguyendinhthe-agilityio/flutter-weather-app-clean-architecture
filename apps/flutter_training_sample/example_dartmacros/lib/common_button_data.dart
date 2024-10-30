import 'dart:ui';

import 'package:example_dartmacros/button_macros.dart';

@ButtonMacros()
class CommonButtonData {
  final String title;
  final VoidCallback? onTap;

  CommonButtonData({
    required this.title,
    this.onTap,
  });
}
