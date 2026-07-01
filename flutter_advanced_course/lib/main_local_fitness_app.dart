import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/fitness_app/core/router/app_router.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/app_theme.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/providers/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: FitnessApp()));
}

class FitnessApp extends ConsumerWidget {
  const FitnessApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Fitness Goals App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}
