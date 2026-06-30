import 'package:flutter/material.dart';

// ignore: always_use_package_imports
import 'ticker_provider_demo.dart';

void main(List<String> args) {
  runApp(const MainTickerProviderDemo());
}

class MainTickerProviderDemo extends StatelessWidget {
  const MainTickerProviderDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: TickerProviderDemo());
  }
}
