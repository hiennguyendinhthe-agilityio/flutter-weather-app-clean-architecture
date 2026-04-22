import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const LoadingSniperApp());
}

class LoadingSniperApp extends StatelessWidget {
  const LoadingSniperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoadingSniper(),
    );
  }
}

class LoadingSniper extends StatefulWidget {
  const LoadingSniper({super.key});

  @override
  State<LoadingSniper> createState() => _LoadingSniperState();
}

class _LoadingSniperState extends State<LoadingSniper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    animation = Tween<double>(begin: 0, end: 300).animate(_controller)
      ..addListener(() {
        setState(() {
          // The state that has changed here is the animation object's value.
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.rotate(
              angle: _controller.value * 2 * pi,
              child: child,
            );
          },
          child: Container(
            width: animation.value,
            height: animation.value,
            decoration: BoxDecoration(
              border: Border.all(width: 10, color: Colors.purple),
              color: Colors.purple,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Align(
              alignment: Alignment.center,
              child: Icon(Icons.refresh, color: Colors.white, size: 50),
            ),
          ),
        ),
      ),
    );
  }
}
