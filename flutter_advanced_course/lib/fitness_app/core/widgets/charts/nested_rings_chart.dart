import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/theme_context_ext.dart';
import 'package:flutter_advanced_course/fitness_app/core/widgets/charts/core/circular_chart_painter.dart';
import 'package:flutter_advanced_course/fitness_app/core/widgets/common/ring_legend_item.dart';
import 'package:flutter_advanced_course/fitness_app/core/widgets/mixins/ring_interaction_mixin.dart';

class NestedRingData {
  final double progress;
  final Color color;
  final Color trackColor;
  final String label;
  final IconData icon;
  final double strokeWidth;

  const NestedRingData({
    required this.progress,
    required this.color,
    required this.trackColor,
    required this.label,
    required this.icon,
    this.strokeWidth = 11.0,
  });
}

class NestedRingsChart extends StatefulWidget {
  final List<NestedRingData> rings;
  final double size;
  final double spacing;

  const NestedRingsChart({
    super.key,
    required this.rings,
    this.size = 240.0,
    this.spacing = 10.0,
  });

  @override
  State<NestedRingsChart> createState() => _NestedRingsChartState();
}

class _NestedRingsChartState extends State<NestedRingsChart>
    with TickerProviderStateMixin, RingInteractionMixin {
  static const int _defaultDailyGoalPercent = 80;

  late List<double> _fromProgress;

  @override
  void initState() {
    super.initState();

    _fromProgress = List.filled(widget.rings.length, 0.0);
    initRingAnimations(ringCount: widget.rings.length);
  }

  @override
  void didUpdateWidget(covariant NestedRingsChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.rings != widget.rings) {
      _fromProgress = List.generate(widget.rings.length, (i) {
        final oldFrom = i < _fromProgress.length ? _fromProgress[i] : 0.0;
        final oldTarget = i < oldWidget.rings.length
            ? oldWidget.rings[i].progress
            : 0.0;
        return CircularPainterUtils.lerp(
          oldFrom,
          oldTarget,
          sweepAnimation.value,
        );
      });
      sweepController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    disposeRingAnimations();
    super.dispose();
  }

  void _onCanvasTapped(Offset position) {
    final strokeWidths = widget.rings.map((r) => r.strokeWidth).toList();
    handleCanvasTapped(position, widget.size, widget.spacing, strokeWidths);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.nestedRingsChartTheme;
    final currentLabel = selectedIndex == null
        ? 'Daily Goals'
        : widget.rings[selectedIndex!].label;
    final targetValue = selectedIndex == null
        ? _defaultDailyGoalPercent
        : (widget.rings[selectedIndex!].progress * 100).toInt();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox.square(
          dimension: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              GestureDetector(
                onTapUp: (details) => _onCanvasTapped(details.localPosition),
                child: CustomPaint(
                  size: Size.square(widget.size),
                  painter: _NestedRingsPainter(
                    rings: widget.rings,
                    fromProgress: _fromProgress,
                    spacing: widget.spacing,
                    entranceAnimation: sweepAnimation,
                    repaintListenable: Listenable.merge([
                      sweepController,
                      ...focusControllers,
                    ]),
                    focusAnimations: focusControllers,
                  ),
                ),
              ),

              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TweenAnimationBuilder<int>(
                    tween: IntTween(begin: 0, end: targetValue),
                    duration: const Duration(milliseconds: 700),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Text('$value%', style: theme.percentageStyle);
                    },
                  ),
                  Text(currentLabel, style: theme.subtitleStyle),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.rings.asMap().entries.map((entry) {
            final index = entry.key;
            final ring = entry.value;
            final isLast = index == widget.rings.length - 1;
            final isSelected = selectedIndex == index;
            final isDimmed = selectedIndex != null && !isSelected;

            return RingLegendItem(
              color: ring.color,
              label: ring.label,
              icon: ring.icon,
              isDimmed: isDimmed,
              isLast: isLast,
              onTap: () => onLegendTapped(index),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _NestedRingsPainter extends BaseCircularPainter {
  final List<NestedRingData> rings;

  final List<double> fromProgress;
  final double spacing;

  final Paint _trackPaint = Paint()..style = PaintingStyle.stroke;
  final Paint _progressPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  _NestedRingsPainter({
    required this.rings,
    required this.fromProgress,
    required this.spacing,
    required super.entranceAnimation,
    required super.repaintListenable,
    required super.focusAnimations,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = centerOf(size);
    final strokeWidths = rings.map((r) => r.strokeWidth).toList();
    final radii = CircularPainterUtils.buildRadii(
      strokeWidths: strokeWidths,
      maxRadius: maxRadiusOf(size),
      spacing: spacing,
    );

    for (int i = 0; i < rings.length; i++) {
      final ring = rings[i];
      final fv = focusAnimations[i].value;
      final radius = radii[i];

      final opacityMultiplier = (fv * 0.8 + 0.2).clamp(0.2, 1.0);
      final dynamicStrokeWidth = ring.strokeWidth + (fv - 1.0) * 8.0;
      final safeStrokeWidth = max(2.0, dynamicStrokeWidth);

      _trackPaint
        ..color = ring.color.withValues(alpha: 0.05 * opacityMultiplier)
        ..strokeWidth = safeStrokeWidth;
      canvas.drawCircle(center, radius, _trackPaint);

      if (entranceProgress > 0) {
        _progressPaint
          ..color = ring.color.withValues(alpha: opacityMultiplier)
          ..strokeWidth = safeStrokeWidth;

        final displayProgress = CircularPainterUtils.lerp(
          fromProgress[i],
          ring.progress,
          entranceProgress,
        );
        final currentSweepAngle = 2 * pi * displayProgress;

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          -pi / 2,
          currentSweepAngle,
          false,
          _progressPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _NestedRingsPainter oldDelegate) {
    return super.shouldRepaint(oldDelegate) ||
        oldDelegate.rings != rings ||
        !CircularPainterUtils.listEquals(
          oldDelegate.fromProgress,
          fromProgress,
        );
  }
}
