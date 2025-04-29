// lib/config/routes/app_pages.dart

import 'package:get/get.dart';
import 'package:pratice_improve_flutter_form_builder/ui/screens/auth/log_in/login_screen.dart';
import 'package:pratice_improve_flutter_form_builder/ui/screens/home/home_screen.dart';
import 'package:pratice_improve_flutter_form_builder/ui/widgets/application_form.dart';

part 'app_routes.dart';

/// Defines the application's pages and their corresponding routes.
class AppPages {
  AppPages._();

  static const initial = Routes.initial;

  static final routes = <GetPage>[
    GetPage(
      name: _Paths.logIn,
      page: () => LoginScreen(),
    ),
    GetPage(
      name: _Paths.applicationForm,
      page: () => const ApplicationForm(),
    ),
    GetPage(
      name: _Paths.home,
      page: () => const HomeScreen(),
    ),
  ];
}
