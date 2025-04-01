import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_books_app/core/utils/size_utils.dart';
import 'package:online_books_app/localization/app_localization.dart';
import 'package:online_books_app/localization/l10n/app_localizations.dart';
import 'package:online_books_app/presentation/home/home_screen.dart';
import 'package:online_books_app/presentation/notification/controller/notification_controller.dart';
import 'package:online_books_app/routes/app_routes.dart';
import 'package:online_books_app/theme/theme_helper.dart';
import 'package:responsive_framework/responsive_framework.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return ResponsiveBreakpoints.builder(
          breakpoints: [
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
          child: GetMaterialApp(
            initialBinding: BindingsBuilder(() {
              Get.put(NotificationController());
            }),
            unknownRoute: GetPage(
              name: '/home_initial_page',
              page: () => HomeScreen(),
            ),
            debugShowCheckedModeBanner: false,
            translations: AppLocalization(),
            locale: Get.deviceLocale,
            fallbackLocale: const Locale('en', 'US'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            title: 'Online Books App',
            initialRoute: AppRoutes.onboardingoneScreen,
            getPages: AppRoutes.pages,
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1.0)),
                child: child!,
              );
            },
            theme: theme,
          ),
        );
      },
    );
  }
}
