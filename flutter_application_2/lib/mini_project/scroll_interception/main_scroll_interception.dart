import 'package:flutter/material.dart';
import 'package:flutter_application_2/mini_project/scroll_interception/scroll_interception_screen.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScrollInterceptionScreen(),
    );
  }
}
