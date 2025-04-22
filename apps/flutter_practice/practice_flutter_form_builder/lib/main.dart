import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practice_flutter_form_builder/controllers/form_controller.dart';
import 'package:practice_flutter_form_builder/localization/app_translations.dart';
import 'package:practice_flutter_form_builder/screens/screen_one.dart';
import 'package:practice_flutter_form_builder/themes/app_theme.dart';

void main() {
  Get.put(FormController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Multi-Step Form',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: ScreenOne(),
      translations: AppTranslations(),
      locale: Get.deviceLocale,
      fallbackLocale: Locale('en', 'US'),
    );
  }
}
