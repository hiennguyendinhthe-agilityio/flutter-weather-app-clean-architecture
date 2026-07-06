import 'dart:math';
import 'package:flutter/material.dart';

class WindOverlay extends StatefulWidget {
  const WindOverlay({super.key});

  @override
  State<WindOverlay> createState() => _WindOverlayState();
}

class _WindOverlayState extends State<WindOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<WindParticle> _particles = [];
  final Random _rnd = Random();

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(days: 1))
          ..addListener(() {
            _updateParticles();
            setState(() {});
          })
          ..forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_particles.isEmpty) {
      final size = MediaQuery.of(context).size;
      for (int i = 0; i < 60; i++) {
        _particles.add(WindParticle.reset(size.width, size.height, _rnd));
      }
    }
  }

  void _updateParticles() {
    final size = MediaQuery.of(context).size;
    for (var p in _particles) {
      p.x += p.speed;
      p.y += sin(p.x * 0.01 + p.swayPhase) * p.swayMagnitude; // slight wave

      if (p.x > size.width + 50 || p.y < -50 || p.y > size.height + 50) {
        p.reset(size.width, size.height, _rnd, left: true);
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
      child: CustomPaint(painter: WindPainter(_particles), size: Size.infinite),
    );
  }
}

class WindParticle {
  double x, y, length, speed, thickness;
  double swayPhase, swayMagnitude;
  double opacity;

  WindParticle({
    required this.x,
    required this.y,
    required this.length,
    required this.speed,
    required this.thickness,
    required this.swayPhase,
    required this.swayMagnitude,
    required this.opacity,
  });

  factory WindParticle.reset(
    double w,
    double h,
    Random rnd, {
    bool left = false,
  }) {
    return WindParticle(
      x: left ? -50 : rnd.nextDouble() * w,
      y: rnd.nextDouble() * h,
      length: rnd.nextDouble() * 30 + 10,
      speed: rnd.nextDouble() * 15 + 20, // move very fast to the right
      thickness: rnd.nextDouble() * 1.5 + 0.5,
      swayPhase: rnd.nextDouble() * pi * 2,
      swayMagnitude: rnd.nextDouble() * 2 + 0.5,
      opacity: rnd.nextDouble() * 0.3 + 0.1,
    );
  }

  void reset(double w, double h, Random rnd, {bool left = false}) {
    x = left ? -50 : rnd.nextDouble() * w;
    y = rnd.nextDouble() * h;
    length = rnd.nextDouble() * 30 + 10;
    speed = rnd.nextDouble() * 15 + 20;
    thickness = rnd.nextDouble() * 1.5 + 0.5;
    swayPhase = rnd.nextDouble() * pi * 2;
    swayMagnitude = rnd.nextDouble() * 2 + 0.5;
    opacity = rnd.nextDouble() * 0.3 + 0.1;
  }
}

class WindPainter extends CustomPainter {
  final List<WindParticle> particles;
  WindPainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round;

    for (var p in particles) {
      paint.color = Colors.white.withAlpha((p.opacity * 255).toInt());
      paint.strokeWidth = p.thickness;
      // draw horizontal-ish line
      canvas.drawLine(Offset(p.x, p.y), Offset(p.x + p.length, p.y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant WindPainter oldDelegate) => true;
}
