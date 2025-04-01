import 'package:example_textfield/example/example_getx/lib/app/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  final ThemeService _themeService = ThemeService();

  ThemeMode get theme => _themeService.getTheme();

  void switchTheme() {
    _themeService.switchTheme();
    update();
  }
}
