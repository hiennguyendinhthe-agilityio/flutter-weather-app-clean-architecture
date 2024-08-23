import 'package:app_testing/about.dart';
import 'package:app_testing/counter.dart';
import 'package:app_testing/home.dart';
import 'package:app_testing/models/counter_porvider.dart';
import 'package:app_testing/models/ui.dart';
import 'package:app_testing/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UI(),
        ),
        ChangeNotifierProvider(create: (_) => CounterPorvider())
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => const Home(),
          '/about': (context) => const About(),
          '/settings': (context) => const Settings(),
          '/counter': (context) => const Counter(),
        },
      ),
    );
  }
}
