import 'package:bazar_books_app/core/l10n_generated/l10n.dart';
import 'package:bazar_books_app/di.dart';
import 'package:bazar_books_app/features/auth/blocs/auth_bloc.dart';
import 'package:bazar_books_app/features/auth/data/auth_repository_impl.dart';
import 'package:bazar_books_app/features/home/home_page.dart';
import 'package:bazar_books_app/routes.dart';
import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  CachedQuery.instance.configFlutter(
    observers: [BazQueryObserver()],
    config: QueryConfigFlutter(
      refetchOnConnection: true,
      refetchOnResume: true,
      cacheDuration: const Duration(minutes: 5),
      refetchDuration: const Duration(seconds: 5),
    ),
  );

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
      builder: (_, child) {
        final authRepository = getIt<AuthRepositoryImpl>();

        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AuthBloc(authRepository)
                ..add(
                  IsLoggedIn(),
                ),
            ),
          ],
          child: MaterialApp.router(
            routerConfig: router,
            themeMode: ThemeMode.light,
            theme: bazUiAppTheme,
            darkTheme: bazUiDarkTheme,
            debugShowCheckedModeBanner: false,
            locale: const Locale('en', 'US'),
            localizationsDelegates: const [
              S.delegate,
              BazUiS.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              ...BazUiS.delegate.supportedLocales,
              ...S.delegate.supportedLocales,
              const Locale('en', ''),
            ],
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
          ),
        );
      },
      child: const HomePage(),
    );
  }
}
