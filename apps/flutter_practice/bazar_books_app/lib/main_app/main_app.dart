import 'package:bazar_books_app/core/l10n_generated/l10n.dart';
import 'package:bazar_books_app/di.dart';
import 'package:bazar_books_app/features/auth/blocs/auth_bloc.dart';
import 'package:bazar_books_app/features/auth/data/auth_repository_impl.dart';
import 'package:bazar_books_app/features/home/home_page.dart';
import 'package:bazar_books_app/features/profile/bloc/profile/profile_bloc.dart';
import 'package:bazar_books_app/features/profile/bloc/profile/profile_event.dart';
import 'package:bazar_books_app/features/profile/data/profile_repository.dart';
import 'package:bazar_books_app/routes.dart';
import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_framework/responsive_framework.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return ScreenUtilInit(
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
            BlocProvider(
              create: (context) => ProfileBloc(
                authRepository: getIt<AuthRepositoryImpl>(),
                imagePicker: ImagePicker(),
                profileRepository: getIt<ProfileRepository>(),
              )..add(FetchUserInfoEvent()),
            ),
          ],
          child: MaterialApp.router(
            key: navigatorKey,
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
            builder: (context, widget) => ResponsiveBreakpoints.builder(
              child: widget!,
              breakpoints: [
                const Breakpoint(start: 0, end: 450, name: MOBILE),
                const Breakpoint(start: 451, end: 800, name: TABLET),
                const Breakpoint(start: 801, end: 1920, name: DESKTOP),
                const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
              ],
            ),
          ),
        );
      },
      child: const HomePage(),
    );
  }
}
