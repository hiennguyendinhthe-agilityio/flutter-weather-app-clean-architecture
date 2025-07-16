import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/theme_provider.dart';
import 'package:todo_app/screens/main_tab_screen.dart';

void main() => runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
      // PhotoProvider merged into PhotoScrollController - no longer needed here
    ],
    child: const MyApp(),
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return CupertinoApp(
          title: 'Todo App',
          debugShowCheckedModeBanner: false,
          theme: themeProvider.cupertinoTheme,
          home: const MainTabScreen(),
          builder: (context, child) {
            // Listen to system brightness changes
            final brightness = MediaQuery.of(context).platformBrightness;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              themeProvider.updateSystemTheme(brightness);
            });
            return child!;
          },
        );
      },
    );
  }
}
