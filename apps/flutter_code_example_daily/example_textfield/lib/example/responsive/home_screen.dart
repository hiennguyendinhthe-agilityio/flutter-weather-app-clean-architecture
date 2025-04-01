import 'package:example_textfield/example/responsive/responsive_layout.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive Example'),
      ),
      body: const ResponsiveLayout(),
    );
  }
}
