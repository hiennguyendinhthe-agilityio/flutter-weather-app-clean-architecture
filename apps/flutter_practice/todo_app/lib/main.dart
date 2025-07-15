import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/photo_provider.dart';
import 'package:todo_app/providers/theme_provider.dart';
import 'package:todo_app/screens/main_tab_screen.dart';

void main() => runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ChangeNotifierProvider(create: (context) => PhotoProvider()),
    ],
    child: const MyApp(),
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder:
          (BuildContext context, ThemeProvider themeProvider, Widget? child) =>
              CupertinoApp(
                debugShowCheckedModeBanner: false,
                theme: CupertinoThemeData(
                  brightness: themeProvider.brightness,
                  primaryColor: CupertinoColors.systemBlue,
                ),
                home: const MainTabScreen(),
              ),
    );
  }
}
