import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_books_app/core/theme/theme_helper.dart';
import 'package:online_books_app/core/utils/size_utils.dart';
import 'package:online_books_app/localization/app_localization.dart';
import 'package:online_books_app/localization/l10n/app_localizations.dart';
import 'package:online_books_app/presentation/e_books/list_ebooks_screen.dart';
import 'package:online_books_app/presentation/notification/controller/notification_controller.dart';
import 'package:online_books_app/routes/app_routes.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          child: FutureBuilder<String>(
            future: _getInitialRoute(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error loading app'));
              } else if (snapshot.hasData) {
                return GetMaterialApp(
                  initialBinding: BindingsBuilder(() {
                    Get.put(NotificationController());
                  }),
                  unknownRoute: GetPage(
                    name: '/item_list_ebook',
                    page: () => ListEbooksScreen(),
                  ),
                  debugShowCheckedModeBanner: false,
                  translations: AppLocalization(),
                  locale: Get.deviceLocale,
                  fallbackLocale: const Locale('en', 'US'),
                  supportedLocales: AppLocalizations.supportedLocales,
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  title: 'Online Books App',
                  initialRoute: snapshot.data!,
                  getPages: AppRoutes.pages,
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(textScaler: const TextScaler.linear(1.0)),
                      child: child!,
                    );
                  },
                  theme: theme,
                );
              } else {
                return const Center(child: Text('No initial route available'));
              }
            },
          ),
        );
      },
    );
  }

  Future<String> _getInitialRoute() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;
    if (onboardingCompleted) {
      return AppRoutes.loginScreen;
    } else {
      return AppRoutes.onboardingoneScreen;
    }
  }
}
