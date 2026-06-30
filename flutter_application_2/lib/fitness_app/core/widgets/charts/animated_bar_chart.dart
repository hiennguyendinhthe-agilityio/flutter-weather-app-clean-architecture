import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AnimatedBarChart — Optimized (Stutter Fix)
// ─────────────────────────────────────────────────────────────────────────────

class AnimatedBarChart extends StatefulWidget {
  final List<double> dataPoints;
  final Color color;
  final double barWidth;
  final double spacing;

  const AnimatedBarChart({
    super.key,
    required this.dataPoints,
    required this.color,
    this.barWidth = 10.0,
    this.spacing = 4.0,
  });

  @override
  State<AnimatedBarChart> createState() => _AnimatedBarChartState();
}

class _AnimatedBarChartState extends State<AnimatedBarChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late List<double> _oldDataPoints;

  @override
  void initState() {
    super.initState();
    _oldDataPoints = List.filled(widget.dataPoints.length, 0.0);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedBarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    // WHY: widget.dataPoints is often a new List instance with same values.
    // listEquals ensures we only restart animation when actual data changes.
    if (!listEquals(oldWidget.dataPoints, widget.dataPoints)) {
      _oldDataPoints = List.from(oldWidget.dataPoints);
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _AnimatedBarChartPainter(
        oldDataPoints: _oldDataPoints,
        dataPoints: widget.dataPoints,
        animation: _animation,
        color: widget.color,
        barWidth: widget.barWidth,
        spacing: widget.spacing,
      ),
    );
  }
}

class _AnimatedBarChartPainter extends CustomPainter {
  final List<double> oldDataPoints;
  final List<double> dataPoints;
  final Animation<double> animation;
  final Color color;
  final double barWidth;
  final double spacing;

  // ── Optimization: Reuse Paint ──
  final Paint _barPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  _AnimatedBarChartPainter({
    required this.oldDataPoints,
    required this.dataPoints,
    required this.animation,
    required this.color,
    required this.barWidth,
    required this.spacing,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    if (dataPoints.isEmpty) return;

    double actualBarWidth = barWidth;
    double actualSpacing = spacing;
    double totalWidth =
        (dataPoints.length * actualBarWidth) +
        ((dataPoints.length - 1) * actualSpacing);

    if (totalWidth > size.width) {
      final scaleFactor = size.width / totalWidth;
      actualBarWidth *= scaleFactor;
      actualSpacing *= scaleFactor;
      totalWidth = size.width;
    }

    _barPaint
      ..color = color
      ..strokeWidth = actualBarWidth;

    final startX = (size.width - totalWidth) / 2;
    final centerY = size.height / 2;

    for (int i = 0; i < dataPoints.length; i++) {
      final oldVal = i < oldDataPoints.length ? oldDataPoints[i] : 0.0;
      final newVal = dataPoints[i].clamp(0.0, 1.0);

      double interpolatedVal = newVal;
      final isInitialLoad = oldDataPoints.every((e) => e == 0.0);

      if (isInitialLoad) {
        final delay = i * (0.2 / dataPoints.length);
        double scale = 0.0;
        if (animation.value > delay) {
          scale = ((animation.value - delay) / 0.8).clamp(0.0, 1.2);
        }
        interpolatedVal = newVal * scale;
      } else {
        final delay = i * (0.2 / dataPoints.length);
        double morphProgress = 0.0;
        if (animation.value > delay) {
          morphProgress = ((animation.value - delay) / 0.8).clamp(0.0, 1.0);
        }
        interpolatedVal = oldVal + (newVal - oldVal) * morphProgress;
      }

      final desiredHeight = size.height * interpolatedVal;
      final x =
          startX +
          (i * (actualBarWidth + actualSpacing)) +
          (actualBarWidth / 2);

      final drawHeight = math.max(0.0, desiredHeight - actualBarWidth);
      final topY = centerY - (drawHeight / 2);
      final bottomY = centerY + (drawHeight / 2);

      if (desiredHeight > actualBarWidth) {
        canvas.drawLine(Offset(x, topY), Offset(x, bottomY), _barPaint);
      } else if (desiredHeight > 0) {
        canvas.drawLine(
          Offset(x, centerY),
          Offset(x, centerY + 0.1),
          _barPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _AnimatedBarChartPainter oldDelegate) {
    return !listEquals(oldDelegate.dataPoints, dataPoints) ||
        !listEquals(oldDelegate.oldDataPoints, oldDataPoints) ||
        oldDelegate.color != color;
  }
}
