import 'package:example_textfield/example/example_getx/lib/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/controllers/theme_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/translations/translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GetX App with Theme & Multi-Language',
      translations: AppTranslations(),
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('en', 'US'),
      themeMode: themeController.theme,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      initialRoute: AppRoutes.home,
      getPages: AppPages.routes,
    );
  }
}
