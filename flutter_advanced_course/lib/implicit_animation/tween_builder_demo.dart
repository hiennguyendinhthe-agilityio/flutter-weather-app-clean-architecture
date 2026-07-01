import 'dart:math';

import 'package:flutter/material.dart';

class TweenBuilderDemo extends StatefulWidget {
  const TweenBuilderDemo({super.key});

  @override
  State<TweenBuilderDemo> createState() => _TweenBuilderDemoState();
}

class _TweenBuilderDemoState extends State<TweenBuilderDemo> {
  double _angle = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: _angle),
              duration: const Duration(seconds: 2),
              curve: Curves.elasticOut,
              builder: (context, value, child) =>
                  Transform.rotate(angle: value, child: child),
              child: const Icon(Icons.refresh, size: 50, color: Colors.purple),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _angle += pi;
                });
              },
              child: Text(_angle == 0 ? 'Rotate' : 'Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
