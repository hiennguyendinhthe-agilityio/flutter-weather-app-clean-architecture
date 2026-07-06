// App root widget.
//
// Responsibilities:
//   - Wire [GoRouter] from [appRouterProvider].
//   - Wire [ThemeMode] from [themeModeProvider].
//   - Wire [ThemeData] from [AppTheme].
//   - Hand off to [MaterialApp.router]. No business logic here.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/router/app_router.dart';
import 'package:weather_app/theme/app_theme.dart';
import 'package:weather_app/theme/providers/theme_provider.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      // ── Theme ──────────────────────────────────────────────────────────────
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      // ── Router ─────────────────────────────────────────────────────────────
      routerConfig: router,
    );
  }
}
