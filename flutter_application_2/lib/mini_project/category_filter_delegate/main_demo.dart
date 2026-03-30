import 'package:flutter/material.dart';
import 'package:flutter_application_2/mini_project/category_filter_delegate/sticky_header_screen.dart';

void main(List<String> args) {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {

 const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StickyHeaderScreen(),
    );
  }
}
