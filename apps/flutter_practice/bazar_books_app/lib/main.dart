import 'package:bazar_books_app/di.dart';
import 'package:bazar_books_app/features/home/home_page.dart';
import 'package:bazar_books_app/routes.dart';
import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initGetIt();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context, designWidth: 375, designHeight: 812);
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      // Use builder only if you need to use library outside ScreenUtilInit context
      builder: (_, child) {
        return MaterialApp.router(
          routerConfig: router,
          themeMode: ThemeMode.light,
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
              const ResponsiveBreakpoint.resize(350, name: MOBILE),
              const ResponsiveBreakpoint.resize(600, name: TABLET),
              const ResponsiveBreakpoint.resize(800, name: DESKTOP),
              const ResponsiveBreakpoint.resize(1200, name: '4K'),
            ],
            defaultScale: true,
            background: Container(color: Colors.white),
          ),
        );
      },
      child: const HomePage(),
    );
  }
}
