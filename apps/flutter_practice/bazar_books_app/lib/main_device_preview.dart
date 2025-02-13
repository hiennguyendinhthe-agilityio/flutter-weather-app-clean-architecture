import 'package:bazar_books_app/core/l10n_generated/l10n.dart';
import 'package:bazar_books_app/di.dart';
import 'package:bazar_books_app/features/auth/blocs/auth_bloc.dart';
import 'package:bazar_books_app/features/auth/data/auth_repository_impl.dart';
import 'package:bazar_books_app/routes.dart';
import 'package:bazar_books_design/core/core.dart';
import 'package:bazar_books_design/themes/themes.dart';
import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:device_preview/device_preview.dart';
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

  runApp(
    DevicePreview(
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
    );

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        final authRepository = getIt<AuthRepositoryImpl>();
        return BlocProvider(
          create: (context) => AuthBloc(authRepository)
            ..add(
              IsLoggedIn(),
            ),
          child: MaterialApp.router(
            routerConfig: router,
            theme: bazUiAppTheme,
            darkTheme: bazUiDarkTheme,
            debugShowCheckedModeBanner: false,

            // Locale settings
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

            // Responsive Wrapper
            builder: (context, widget) => ResponsiveBreakpoints.builder(
              child: widget!,
              breakpoints: [
                const Breakpoint(start: 0, end: 450, name: MOBILE),
                const Breakpoint(start: 451, end: 800, name: TABLET),
                const Breakpoint(start: 801, end: 1920, name: DESKTOP),
                const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
              ],
              // defaultScale: true,
              // background: Container(color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}
