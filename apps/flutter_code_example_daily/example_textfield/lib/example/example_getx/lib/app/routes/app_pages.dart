import 'package:get/get.dart';

import '../views/home_screen.dart';
import '../views/language_screen.dart';
import '../views/second_screen.dart';
import '../views/settings_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.home, page: () => HomeScreen()),
    GetPage(name: AppRoutes.second, page: () => SecondScreen()),
    GetPage(name: AppRoutes.settings, page: () => const SettingsScreen()),
    GetPage(name: AppRoutes.language, page: () => const LanguageScreen()),
  ];
}
