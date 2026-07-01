import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/extensions/segmented_donut_chart_theme.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/theme_context_ext.dart';
import 'package:flutter_advanced_course/fitness_app/features/sandbox/projects/models/project_data.dart';

class SegmentedDonutChart extends StatelessWidget {
  final List<ProjectData> segments;
  final String centerTitle;
  final String centerValue;
  final String centerSubtitle;
  final double size;
  final double strokeWidth;
  final double gapAngle;
  final Animation<double> animation;

  const SegmentedDonutChart({
    super.key,
    required this.segments,
    this.centerTitle = 'total time',
    required this.centerValue,
    required this.centerSubtitle,
    this.size = 240,
    this.strokeWidth = 10,
    this.gapAngle = 0.104,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.segmentedDonutChartTheme;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _SegmentedDonutPainter(
              segments: segments,
              strokeWidth: strokeWidth,
              gapAngle: gapAngle,
              animation: animation,
              theme: theme,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(centerTitle, style: theme.centerSubtitleStyle),
              const SizedBox(height: 8),
              Text(centerValue, style: theme.centerValueStyle),
              const SizedBox(height: 8),
              Text(centerSubtitle, style: theme.centerSubtitleStyle),
            ],
          ),
        ],
      ),
    );
  }
}

class _SegmentedDonutPainter extends CustomPainter {
  final List<ProjectData> segments;
  final double strokeWidth;
  final double gapAngle;
  final Animation<double> animation;
  final SegmentedDonutChartTheme theme;

  _SegmentedDonutPainter({
    required this.segments,
    required this.strokeWidth,
    required this.gapAngle,
    required this.animation,
    required this.theme,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final trackPaint = Paint()
      ..color = theme.trackColor ?? const Color(0xFF1E1E28)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    final progress = animation.value;

    if (segments.isEmpty || progress <= 0) return;

    final totalPercentage = segments.fold(0.0, (sum, s) => sum + s.percentage);
    final totalGapSweep = gapAngle * segments.length;
    final availableSweep = 2 * pi - totalGapSweep;

    double currentAngle = -pi / 2;

    for (var segment in segments) {
      final normalizedPercentage = totalPercentage > 0
          ? segment.percentage / totalPercentage
          : 1.0 / segments.length;

      final sweepAngle = (availableSweep * normalizedPercentage) * progress;

      final glowPaint = Paint()
        ..color = segment.color.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 4
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      canvas.drawArc(rect, currentAngle, sweepAngle, false, glowPaint);

      final paint = Paint()
        ..color = segment.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(rect, currentAngle, sweepAngle, false, paint);

      currentAngle += (availableSweep * normalizedPercentage) + gapAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _SegmentedDonutPainter oldDelegate) =>
      oldDelegate.segments != segments || oldDelegate.theme != theme;
}
