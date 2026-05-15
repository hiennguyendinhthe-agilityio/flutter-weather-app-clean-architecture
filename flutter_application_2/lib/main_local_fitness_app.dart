import 'package:flutter/material.dart';
import 'package:flutter_application_2/fitness_app/screens/main_navigation_screen.dart';
import 'package:flutter_application_2/fitness_app/theme/app_theme.dart';

void main() {
  runApp(const FitnessApp());
}

class FitnessApp extends StatelessWidget {
  const FitnessApp({super.key});

  @override
  Widget build(BuildContext context) {   
    return MaterialApp(
      title: 'Fitness Goals App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(), 

      themeMode: ThemeMode.dark,
      home: const MainNavigationScreen(),
    );
  }
}
