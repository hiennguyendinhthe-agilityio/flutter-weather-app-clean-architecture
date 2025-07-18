import 'package:caculator/process_example/screens/student_graden_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ThinkingProcessApp());
}

class ThinkingProcessApp extends StatelessWidget {
  const ThinkingProcessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thinking Process Example',
      home: StudentGradenScreen(),
    );
  }
}
