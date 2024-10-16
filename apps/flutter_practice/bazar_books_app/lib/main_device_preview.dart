import 'package:bazar_books_app/di.dart';
import 'package:bazar_books_app/routes.dart';
import 'package:bazar_books_design/core/core.dart';
import 'package:bazar_books_design/themes/themes.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initGetIt();

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(
      context,
      designWidth: 375,
      designHeight: 812,
    );

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return MaterialApp.router(
          routerConfig: router,
          themeMode: ThemeMode.system,
          theme: bazUiAppTheme,
          darkTheme: bazUiDarkTheme,
          debugShowCheckedModeBanner: false,

          // Locale settings
          locale: const Locale('en', 'US'),
          localizationsDelegates: const [
            BazUiS.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            ...BazUiS.delegate.supportedLocales,
            const Locale('en', ''),
          ],

          // Responsive Wrapper
          builder: (context, widget) => ResponsiveWrapper.builder(
            ClampingScrollWrapper.builder(context, widget!),
            breakpoints: [
              const ResponsiveBreakpoint.resize(375, name: MOBILE),
              const ResponsiveBreakpoint.resize(600, name: TABLET),
              const ResponsiveBreakpoint.resize(800, name: DESKTOP),
              const ResponsiveBreakpoint.resize(1200, name: '4K'),
            ],
            defaultScale: true,
            background: Container(color: Colors.white),
          ),
        );
      },
    );
  }
}
