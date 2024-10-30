import 'package:example_dartmacros/common_button_data.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final buttonData = CommonButtonData(
      title: 'Click Me',
      onTap: () {
        print('Button was tapped');
      },
    );

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Button Macro Example')),
        body: Center(
          child: CommonButton(data: buttonData),
        ),
      ),
    );
  }
}

class CommonButton extends StatelessWidget {
  final CommonButtonData data;

  const CommonButton({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: data.onTap,
      child: Text(data.title),
    );
  }
}
