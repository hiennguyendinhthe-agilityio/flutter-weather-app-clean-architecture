import 'dart:math';
import 'package:flutter/material.dart';

class SunRaysOverlay extends StatefulWidget {
  const SunRaysOverlay({super.key});

  @override
  State<SunRaysOverlay> createState() => _SunRaysOverlayState();
}

class _SunRaysOverlayState extends State<SunRaysOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
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
          return CustomPaint(
            painter: SunRaysPainter(_controller.value),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class SunRaysPainter extends CustomPainter {
  final double animationValue;
  SunRaysPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    // We draw a few large polygons from the top right radiating outwards
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30);

    // Increase base opacity to make it visible
    final baseOpacity = 0.2 + (animationValue * 0.2);

    final origin = Offset(size.width, -50);

    // Ray 1
    _drawRay(
      canvas,
      paint,
      origin,
      size.height * 0.8,
      pi * 0.7,
      pi * 0.1,
      Colors.yellow.withAlpha((baseOpacity * 255).toInt()),
    );

    // Ray 2
    _drawRay(
      canvas,
      paint,
      origin,
      size.height,
      pi * 0.85,
      pi * 0.15,
      Colors.orangeAccent.withAlpha((baseOpacity * 200).toInt()),
    );

    // Ray 3
    _drawRay(
      canvas,
      paint,
      origin,
      size.height * 0.9,
      pi * 0.55,
      pi * 0.1,
      Colors.white.withAlpha((baseOpacity * 150).toInt()),
    );
  }

  void _drawRay(
    Canvas canvas,
    Paint paint,
    Offset origin,
    double length,
    double angle,
    double spread,
    Color color,
  ) {
    paint.color = color;
    final path = Path();
    path.moveTo(origin.dx, origin.dy);

    // Calculate the two bottom points of the ray polygon
    final p1 = Offset(
      origin.dx + cos(angle - spread / 2) * length,
      origin.dy + sin(angle - spread / 2) * length,
    );
    final p2 = Offset(
      origin.dx + cos(angle + spread / 2) * length,
      origin.dy + sin(angle + spread / 2) * length,
    );

    path.lineTo(p1.dx, p1.dy);
    path.lineTo(p2.dx, p2.dy);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant SunRaysPainter oldDelegate) => true;
}
