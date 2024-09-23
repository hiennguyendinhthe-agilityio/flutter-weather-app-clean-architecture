import 'package:bazar_books_app/di.dart';
import 'package:bazar_books_app/features/auth/presentation/sign_in.dart';
import 'package:bazar_books_app/routes.dart';
import 'package:bazar_books_design/core/apis/api_sercvice.dart';
import 'package:bazar_books_design/core/resources/l10n_generated/l10n.dart';
import 'package:bazar_books_design/themes/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/home/bloc/product_bloc.dart';
import 'features/home/bloc/vendor_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setString('email', '');
  await prefs.setString('password', '');
  await initAppModule();

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final apiService = instance<ApiService>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductBloc>(
          create: (BuildContext context) => ProductBloc(apiService)
            ..add(
              GetProductsEvent(),
            ),
        ),
        BlocProvider<VendorBloc>(
          create: (BuildContext context) => VendorBloc(apiService)
            ..add(
              GetVendorsEvent(),
            ),
        ),
      ],
      child: MaterialApp(
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
      ),
    );
  }
}
