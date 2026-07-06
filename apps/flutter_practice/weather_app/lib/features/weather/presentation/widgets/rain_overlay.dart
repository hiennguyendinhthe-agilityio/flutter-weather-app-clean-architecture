import 'dart:math';
import 'package:flutter/material.dart';

class RainOverlay extends StatefulWidget {
  const RainOverlay({super.key});

  @override
  State<RainOverlay> createState() => _RainOverlayState();
}

class _RainOverlayState extends State<RainOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<RainDrop> _drops = [];
  final Random _rnd = Random();

  @override
  void initState() {
    super.initState();
    // Use a very long duration so the animation runs continuously
    _controller =
        AnimationController(vsync: this, duration: const Duration(days: 1))
          ..addListener(() {
            _updateDrops();
            setState(() {});
          })
          ..forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_drops.isEmpty) {
      final size = MediaQuery.of(context).size;
      for (int i = 0; i < 150; i++) {
        _drops.add(RainDrop.reset(size.width, size.height, _rnd));
      }
    }
  }

  void _updateDrops() {
    final size = MediaQuery.of(context).size;
    for (var drop in _drops) {
      drop.y += drop.speed;
      drop.x += drop.wind;
      if (drop.y > size.height || drop.x < -50 || drop.x > size.width + 50) {
        drop.reset(size.width, size.height, _rnd, top: true);
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
      child: CustomPaint(painter: RainPainter(_drops), size: Size.infinite),
    );
  }
}

class RainDrop {
  double x, y, length, speed, wind, thickness;
  double opacity;

  RainDrop({
    required this.x,
    required this.y,
    required this.length,
    required this.speed,
    required this.wind,
    required this.thickness,
    required this.opacity,
  });

  factory RainDrop.reset(double w, double h, Random rnd, {bool top = false}) {
    // Wind is slanting slightly to the right
    final wind = rnd.nextDouble() * 2 + 1.0;
    return RainDrop(
      x: rnd.nextDouble() * (w + 100) - 50,
      y: top ? -30 : rnd.nextDouble() * h,
      length: rnd.nextDouble() * 20 + 15,
      speed: rnd.nextDouble() * 15 + 20, // Fast falling rain
      wind: wind,
      thickness: rnd.nextDouble() * 1 + 0.5,
      opacity: rnd.nextDouble() * 0.4 + 0.1,
    );
  }

  void reset(double w, double h, Random rnd, {bool top = false}) {
    x = rnd.nextDouble() * (w + 100) - 50;
    y = top ? -30 : rnd.nextDouble() * h;
    length = rnd.nextDouble() * 20 + 15;
    speed = rnd.nextDouble() * 15 + 20;
    wind = rnd.nextDouble() * 2 + 1.0;
    thickness = rnd.nextDouble() * 1 + 0.5;
    opacity = rnd.nextDouble() * 0.4 + 0.1;
  }
}

class RainPainter extends CustomPainter {
  final List<RainDrop> drops;
  RainPainter(this.drops);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round;

    for (var drop in drops) {
      paint.color = Colors.white.withAlpha((drop.opacity * 255).toInt());
      paint.strokeWidth = drop.thickness;
      canvas.drawLine(
        Offset(drop.x, drop.y),
        Offset(
          drop.x + drop.wind * (drop.length / drop.speed),
          drop.y + drop.length,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant RainPainter oldDelegate) => true; // Always repaint for animation
}
