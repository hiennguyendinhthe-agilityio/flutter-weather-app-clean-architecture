import 'package:bazar_books_app/di.dart';
import 'package:bazar_books_app/features/auth/sign_in.dart';
import 'package:bazar_books_app/routes.dart';
import 'package:bazar_books_design/core/core.dart';
import 'package:bazar_books_design/themes/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (context) => const LoginScreen(),
      },

      themeMode: ThemeMode.light,
      theme: bazUiLightTheme,
      darkTheme: bazUiDarkTheme,

      // Disable banner simulator mode
      debugShowCheckedModeBanner: false,

      // Locale
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
    );
  }
}
