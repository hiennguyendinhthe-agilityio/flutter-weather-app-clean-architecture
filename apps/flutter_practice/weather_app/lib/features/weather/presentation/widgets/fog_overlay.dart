import 'dart:ui';
import 'package:flutter/material.dart';

class FogOverlay extends StatefulWidget {
  const FogOverlay({super.key});

  @override
  State<FogOverlay> createState() => _FogOverlayState();
}

class _FogOverlayState extends State<FogOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // Calculate movement
          final dy = _controller.value * 50 - 25; // Drifts up and down slowly

          return Stack(
            children: [
              // Cloud 1
              Positioned(
                top: -50 + dy,
                left: -100,
                right: -100,
                height: 400,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withAlpha(50),
                        blurRadius: 100,
                        spreadRadius: 100,
                      ),
                    ],
                  ),
                ),
              ),
              // Cloud 2
              Positioned(
                bottom: -50 - dy,
                left: -50,
                right: -50,
                height: 300,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withAlpha(40),
                        blurRadius: 150,
                        spreadRadius: 80,
                      ),
                    ],
                  ),
                ),
              ),
              // Overall fog layer
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(color: Colors.white.withAlpha(20)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
