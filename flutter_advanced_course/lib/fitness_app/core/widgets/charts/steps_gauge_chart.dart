import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/theme_context_ext.dart';
import 'package:flutter_advanced_course/fitness_app/core/widgets/charts/core/circular_chart_painter.dart';

// ─────────────────────────────────────────────────────────────────────────────
// StepsGaugeChart — Optimized (Theming + Stutter Fix)
// ─────────────────────────────────────────────────────────────────────────────

class StepsGaugeChart extends StatefulWidget {
  final int currentSteps;
  final int goalSteps;

  const StepsGaugeChart({
    super.key,
    required this.currentSteps,
    required this.goalSteps,
  });

  @override
  State<StepsGaugeChart> createState() => _StepsGaugeChartState();
}

class _StepsGaugeChartState extends State<StepsGaugeChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sweepAnimation;

  late double _fromProgress;

  @override
  void initState() {
    super.initState();
    _fromProgress = 0.0;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _sweepAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant StepsGaugeChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentSteps != widget.currentSteps ||
        oldWidget.goalSteps != widget.goalSteps) {
      final oldProgress = (oldWidget.currentSteps / oldWidget.goalSteps).clamp(
        0.0,
        1.0,
      );
      _fromProgress = CircularPainterUtils.lerp(
        _fromProgress,
        oldProgress,
        _sweepAnimation.value,
      );
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]} ',
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;
    final theme = context.stepsGaugeChartTheme;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Steps', style: theme.titleStyle),
          const Spacer(),
          Center(
            child: SizedBox.square(
              dimension: 130.0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size.square(130.0),
                    painter: _GaugePainter(
                      progress: (widget.currentSteps / widget.goalSteps).clamp(
                        0.0,
                        1.0,
                      ),
                      fromProgress: _fromProgress,
                      entranceAnimation: _sweepAnimation,
                      color: theme.progressColor ?? cs.tertiary,
                      trackColor: theme.trackColor ?? cs.surface,
                    ),
                  ),
                  TweenAnimationBuilder<int>(
                    tween: IntTween(begin: 0, end: widget.currentSteps),
                    duration: const Duration(milliseconds: 1200),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _formatNumber(value),
                            style:
                                theme.valueStyle ??
                                TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: cs.onSurface,
                                ),
                          ),
                          ?child,
                        ],
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 2),
                        Text(
                          'Goal: ${_formatNumber(widget.goalSteps)}',
                          style:
                              theme.goalStyle ??
                              TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: cs.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _GaugePainter extends BaseCircularPainter {
  final double progress;
  final double fromProgress;
  final Color color;
  final Color trackColor;
  final double _strokeWidth;

  // ── Optimization: Reuse Paint ──
  final Paint _paint = Paint()..style = PaintingStyle.stroke;

  _GaugePainter({
    required this.progress,
    required this.fromProgress,
    required super.entranceAnimation,
    required this.color,
    required this.trackColor,
    double strokeWidth = 10.0,
  }) : _strokeWidth = strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = centerOf(size);
    final radius = maxRadiusOf(size) - _strokeWidth / 2;

    const startAngle = -pi / 2;
    const fullSweep = 2 * pi;

    _paint
      ..color = trackColor
      ..strokeWidth = _strokeWidth
      ..strokeCap = StrokeCap.butt;
    canvas.drawCircle(center, radius, _paint);

    if (entranceProgress > 0) {
      final displayProgress = CircularPainterUtils.lerp(
        fromProgress,
        progress,
        entranceProgress,
      );
      final currentSweep = fullSweep * displayProgress;

      _paint
        ..color = color
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        currentSweep,
        false,
        _paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return super.shouldRepaint(oldDelegate) ||
        oldDelegate.progress != progress ||
        oldDelegate.fromProgress != fromProgress ||
        oldDelegate.color != color ||
        oldDelegate.trackColor != trackColor;
  }
}
