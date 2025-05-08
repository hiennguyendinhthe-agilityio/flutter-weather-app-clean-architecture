import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pratice_improve_flutter_form_builder/controllers/application_controller.dart';
import 'package:pratice_improve_flutter_form_builder/controllers/login_controller.dart';
import 'package:pratice_improve_flutter_form_builder/ui/themes/app_theme.dart';

import 'config/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  Get.lazyPut(() => ApplicationController(), fenix: true);
  Get.put(LoginController());

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
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}
