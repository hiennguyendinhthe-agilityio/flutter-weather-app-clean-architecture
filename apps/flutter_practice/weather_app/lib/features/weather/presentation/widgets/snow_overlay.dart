import 'dart:math';
import 'package:flutter/material.dart';

class SnowOverlay extends StatefulWidget {
  const SnowOverlay({super.key});

  @override
  State<SnowOverlay> createState() => _SnowOverlayState();
}

class _SnowOverlayState extends State<SnowOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<SnowFlake> _flakes = [];
  final Random _rnd = Random();

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(days: 1))
          ..addListener(() {
            _updateFlakes();
            setState(() {});
          })
          ..forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_flakes.isEmpty) {
      final size = MediaQuery.of(context).size;
      for (int i = 0; i < 200; i++) {
        _flakes.add(SnowFlake.reset(size.width, size.height, _rnd));
      }
    }
  }

  void _updateFlakes() {
    final size = MediaQuery.of(context).size;
    final time = DateTime.now().millisecondsSinceEpoch / 1000.0;
    for (var flake in _flakes) {
      flake.y += flake.speed;
      // Sway left and right using sine wave based on time and individual phase
      flake.x +=
          sin(time * flake.swaySpeed + flake.swayPhase) * flake.swayMagnitude;

      if (flake.y > size.height + 10 ||
          flake.x < -20 ||
          flake.x > size.width + 20) {
        flake.reset(size.width, size.height, _rnd, top: true);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(painter: SnowPainter(_flakes), size: Size.infinite),
    );
  }
}

class SnowFlake {
  double x, y, radius, speed;
  double swayPhase, swaySpeed, swayMagnitude;
  double opacity;

  SnowFlake({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.swayPhase,
    required this.swaySpeed,
    required this.swayMagnitude,
    required this.opacity,
  });

  factory SnowFlake.reset(double w, double h, Random rnd, {bool top = false}) {
    return SnowFlake(
      x: rnd.nextDouble() * (w + 40) - 20,
      y: top ? -10 : rnd.nextDouble() * h,
      radius: rnd.nextDouble() * 2 + 1, // 1 to 3
      speed: rnd.nextDouble() * 1.5 + 0.5, // 0.5 to 2.0 (slow)
      swayPhase: rnd.nextDouble() * pi * 2,
      swaySpeed: rnd.nextDouble() * 1 + 0.5,
      swayMagnitude: rnd.nextDouble() * 0.5 + 0.2,
      opacity: rnd.nextDouble() * 0.5 + 0.3, // 0.3 to 0.8
    );
  }

  void reset(double w, double h, Random rnd, {bool top = false}) {
    x = rnd.nextDouble() * (w + 40) - 20;
    y = top ? -10 : rnd.nextDouble() * h;
    radius = rnd.nextDouble() * 2 + 1;
    speed = rnd.nextDouble() * 1.5 + 0.5;
    swayPhase = rnd.nextDouble() * pi * 2;
    swaySpeed = rnd.nextDouble() * 1 + 0.5;
    swayMagnitude = rnd.nextDouble() * 0.5 + 0.2;
    opacity = rnd.nextDouble() * 0.5 + 0.3;
  }
}

class SnowPainter extends CustomPainter {
  final List<SnowFlake> flakes;
  SnowPainter(this.flakes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    for (var flake in flakes) {
      paint.color = Colors.white.withAlpha((flake.opacity * 255).toInt());
      canvas.drawCircle(Offset(flake.x, flake.y), flake.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant SnowPainter oldDelegate) => true;
}
