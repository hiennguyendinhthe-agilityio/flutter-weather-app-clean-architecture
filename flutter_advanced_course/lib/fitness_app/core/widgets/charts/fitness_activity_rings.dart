import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/theme_context_ext.dart';
import 'package:flutter_advanced_course/fitness_app/core/widgets/charts/core/circular_chart_painter.dart';
import 'package:flutter_advanced_course/fitness_app/core/widgets/common/ring_legend_item.dart';
import 'package:flutter_advanced_course/fitness_app/core/widgets/mixins/ring_interaction_mixin.dart';

class ActivityRingsData {
  final double progress;
  final Color color;
  final String label;
  final IconData icon;
  final double strokeWidth;

  const ActivityRingsData({
    required this.progress,
    required this.color,
    required this.label,
    required this.icon,
    this.strokeWidth = 14.0,
  });
}

class ActivityRingsChart extends StatefulWidget {
  final List<ActivityRingsData> rings;
  final double size;
  final double spacing;
  final int totalIndex;

  const ActivityRingsChart({
    super.key,
    required this.rings,
    required this.totalIndex,
    this.size = 280.0,
    this.spacing = 14.0,
  });

  @override
  State<ActivityRingsChart> createState() => _ActivityRingsChartState();
}

class _ActivityRingsChartState extends State<ActivityRingsChart>
    with TickerProviderStateMixin, RingInteractionMixin {
  late List<double> _fromProgress;

  @override
  void initState() {
    super.initState();
    _fromProgress = List.filled(widget.rings.length, 0.0);
    initRingAnimations(
      ringCount: widget.rings.length,
      sweepDuration: const Duration(milliseconds: 1600),
    );
  }

  @override
  void didUpdateWidget(covariant ActivityRingsChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.rings != widget.rings ||
        oldWidget.totalIndex != widget.totalIndex) {
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
    final theme = context.fitnessActivityRingsTheme;
    final targetValue = selectedIndex == null
        ? widget.totalIndex
        : (widget.rings[selectedIndex!].progress * 100).toInt();
    final currentLabel = selectedIndex == null
        ? 'Total index'
        : widget.rings[selectedIndex!].label;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: SizedBox.square(
            dimension: widget.size,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    onTapUp: (d) => _onCanvasTapped(d.localPosition),
                    child: CustomPaint(
                      size: Size.square(widget.size),
                      painter: _ActivityRingsPainter(
                        rings: widget.rings,
                        fromProgress: _fromProgress,
                        spacing: widget.spacing,
                        trackColor:
                            theme.trackColor ??
                            Colors.grey.withValues(alpha: 0.2),
                        entranceAnimation: sweepAnimation,
                        repaintListenable: Listenable.merge([
                          sweepController,
                          ...focusControllers,
                        ]),
                        focusAnimations: focusControllers,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  right: widget.size * 0.15,
                  bottom: widget.size * 0.02,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TweenAnimationBuilder<int>(
                        tween: IntTween(begin: 0, end: targetValue),
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, _) {
                          return Text(
                            '$value',
                            style: theme.titleStyle,
                            textAlign: TextAlign.center,
                          );
                        },
                      ),
                      Text(currentLabel, style: theme.subtitleStyle),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

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

class _ActivityRingsPainter extends BaseCircularPainter {
  final List<ActivityRingsData> rings;
  final List<double> fromProgress;
  final double spacing;
  final Color trackColor;

  _ActivityRingsPainter({
    required this.rings,
    required this.fromProgress,
    required this.spacing,
    required this.trackColor,
    required super.entranceAnimation,
    required super.repaintListenable,
    required super.focusAnimations,
  });

  static const double _trackStartAngle = pi / 2;
  static const double _trackSweepFraction = 0.8;
  static const double _trackSweepAngle = 2 * pi * _trackSweepFraction;

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
      final dynamicStroke = ring.strokeWidth + (fv - 1.0) * 8.0;
      final safeStroke = max(2.0, dynamicStroke);
      final arcRect = Rect.fromCircle(center: center, radius: radius);

      final trackPaint = Paint()
        ..color = trackColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = safeStroke
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        arcRect,
        _trackStartAngle,
        _trackSweepAngle,
        false,
        trackPaint,
      );

      if (entranceProgress > 0) {
        final displayProgress = CircularPainterUtils.lerp(
          fromProgress[i],
          ring.progress,
          entranceProgress,
        );
        final currentSweep = _trackSweepAngle * displayProgress;

        final progressPaint = Paint()
          ..color = ring.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = safeStroke
          ..strokeCap = StrokeCap.round;

        if (opacityMultiplier < 1.0) {
          canvas.saveLayer(
            arcRect.inflate(safeStroke),
            Paint()..color = Colors.white.withValues(alpha: opacityMultiplier),
          );
        }

        canvas.drawArc(
          arcRect,
          _trackStartAngle,
          currentSweep,
          false,
          progressPaint,
        );

        if (opacityMultiplier < 1.0) canvas.restore();

        final endAngle = _trackStartAngle + currentSweep;

        if (entranceProgress > 0.5) {
          final iconOpacity =
              ((entranceProgress - 0.5) * 2.0).clamp(0.0, 1.0) *
              opacityMultiplier;
          final iconOffsetAngle = 18.0 / radius;
          final iconAngle = _trackStartAngle - iconOffsetAngle;
          final iconRadius = radius + 2.0;

          _drawIcon(
            canvas,
            Offset(
              center.dx + iconRadius * cos(iconAngle),
              center.dy + iconRadius * sin(iconAngle),
            ),
            ring.icon,
            ring.color,
            iconOpacity,
            safeStroke * 0.7,
          );
        }

        if (entranceProgress > 0.3) {
          final labelOpacity =
              ((entranceProgress - 0.3) * 1.5).clamp(0.0, 1.0) *
              opacityMultiplier;
          final extraAngle = 25.0 / radius;
          final labelAngle = endAngle + extraAngle;

          _drawText(
            canvas,
            Offset(
              center.dx + radius * cos(labelAngle),
              center.dy + radius * sin(labelAngle),
            ),
            '${(displayProgress * 100).toInt()}%',
            labelOpacity,
            labelAngle + pi / 2,
          );
        }
      }
    }
  }

  void _drawIcon(
    Canvas canvas,
    Offset position,
    IconData icon,
    Color color,
    double opacity,
    double size,
  ) {
    final tp = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: size,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          color: color.withValues(alpha: opacity),
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    )..layout();
    tp.paint(
      canvas,
      Offset(position.dx - tp.width / 2, position.dy - tp.height / 2),
    );
  }

  void _drawText(
    Canvas canvas,
    Offset position,
    String text,
    double opacity,
    double rotationAngle,
  ) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: const Color(
            0xFF8B8B9B,
          ).withValues(alpha: opacity.clamp(0.0, 1.0)),
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    )..layout();

    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate(rotationAngle);
    tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ActivityRingsPainter oldDelegate) {
    return super.shouldRepaint(oldDelegate) ||
        oldDelegate.rings != rings ||
        !CircularPainterUtils.listEquals(
          oldDelegate.fromProgress,
          fromProgress,
        );
  }
}
