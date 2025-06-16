import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/home_screen.dart';
import 'services/theme_service.dart';
import 'services/timeline_service.dart';
import 'theme/app_theme.dart';

/// Main entry point of the Beautiful Timeline App
///
/// This app demonstrates a production-quality timeline view with:
/// - Interactive date selection
/// - 24-hour timeline with event positioning
/// - Light/Dark theme support
/// - Responsive design
/// - Pomodoro timer integration
void main() {
  runApp(const BeautifulTimelineApp());
}

/// Root application widget with multi-provider setup
class BeautifulTimelineApp extends StatelessWidget {
  const BeautifulTimelineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TimelineService()),
        ChangeNotifierProvider(create: (_) => ThemeService()),
      ],
      child: Consumer<ThemeService>(
        builder: (context, themeService, child) {
          return MaterialApp(
            title: 'Beautiful Timeline',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeService.themeMode,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
