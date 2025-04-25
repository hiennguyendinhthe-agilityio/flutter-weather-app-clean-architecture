import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pratice_improve_flutter_form_builder/ui/widgets/application_form.dart';

import 'controllers/application_controller.dart';
import 'ui/themes/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  Get.put(ApplicationController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme();

    return GetMaterialApp(
      title: 'Job Application',
      theme: appTheme.themeData,
      debugShowCheckedModeBanner: false,
      home: const ApplicationForm(),
    );
  }
}
