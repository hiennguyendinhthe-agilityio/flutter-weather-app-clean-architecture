import 'package:bazar_books_app/di.dart';
import 'package:bazar_books_app/features/auth/sign_in.dart';
import 'package:bazar_books_app/routes.dart';
import 'package:bazar_books_design/core/core.dart';
import 'package:bazar_books_design/themes/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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

    return MaterialApp(
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (context) => const LoginScreen(),
      },
      themeMode: ThemeMode.light,
      theme: bazUiLightTheme,
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
  }
}
