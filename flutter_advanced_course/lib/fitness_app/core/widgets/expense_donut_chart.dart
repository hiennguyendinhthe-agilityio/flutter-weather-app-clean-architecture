import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/extensions/expense_donut_chart_theme.dart';
import 'package:flutter_advanced_course/fitness_app/features/sandbox/expenses/models/expense_model.dart';

class ExpenseDonutChart extends StatefulWidget {
  final List<ExpenseCategory> categories;
  final double totalAmount;

  const ExpenseDonutChart({
    super.key,
    required this.categories,
    required this.totalAmount,
  });

  @override
  State<ExpenseDonutChart> createState() => _ExpenseDonutChartState();
}

class _ExpenseDonutChartState extends State<ExpenseDonutChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  late List<ExpenseCategory> _oldCategories;
  late double _oldTotalAmount;

  @override
  void initState() {
    super.initState();
    _oldCategories = widget.categories
        .map((c) => c.copyWith(amount: 0, percentage: 0))
        .toList();
    _oldTotalAmount = 0;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(ExpenseDonutChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.categories != widget.categories ||
        oldWidget.totalAmount != widget.totalAmount) {
      _oldCategories = oldWidget.categories;
      _oldTotalAmount = oldWidget.totalAmount;
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
    final theme = Theme.of(context).extension<ExpenseDonutChartTheme>();

    return SizedBox(
      height: 300,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              final List<ExpenseCategory> currentLerped = [];
              for (int i = 0; i < widget.categories.length; i++) {
                final oldCat = _oldCategories[i];
                final newCat = widget.categories[i];
                currentLerped.add(
                  newCat.copyWith(
                    percentage:
                        lerpDouble(
                          oldCat.percentage,
                          newCat.percentage,
                          _animation.value,
                        ) ??
                        0,
                  ),
                );
              }

              final currentTotal =
                  lerpDouble(
                    _oldTotalAmount,
                    widget.totalAmount,
                    _animation.value,
                  ) ??
                  0;

              return Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(300, 300),
                    painter: _DonutChartPainter(
                      categories: currentLerped,
                      progress: _animation.value,
                      textOpacity: _animation.value,
                      theme: theme,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '\$ ${currentTotal.toInt()}',
                        style: theme?.centerValueStyle,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'total per month',
                        style: theme?.centerSubtitleStyle,
                      ),
                    ],
                  ),
                ],
              );
            },
          ),

          Positioned(
            top: 0,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: theme?.badgeBackgroundColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color:
                        theme?.badgeBackgroundColor?.withValues(alpha: 0.3) ??
                        Colors.black12,
                    blurRadius: 12,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.credit_card_rounded,
                color: theme?.badgeIconColor,
                size: 26,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  final List<ExpenseCategory> categories;
  final double progress;
  final double textOpacity;
  final ExpenseDonutChartTheme? theme;

  _DonutChartPainter({
    required this.categories,
    required this.progress,
    required this.textOpacity,
    required this.theme,
  });

  static const double _kCornerRadius = 2.5;

  static const double _kTrackStroke = 30.0;
  static const double _kArcStroke = 10.0;
  static const double _kTopGap = 0.71;
  static const double _kSliceGap = 0.019;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final baseRadius = min(size.width, size.height) / 2 - 24.0;

    final trackOuter = baseRadius + _kTrackStroke / 2;
    final trackInner = baseRadius - _kTrackStroke / 2;

    final arcCenterR = baseRadius + (_kTrackStroke / 2) - (_kArcStroke / 2);
    final arcOuter = arcCenterR + _kArcStroke / 2;
    final arcInner = arcCenterR - _kArcStroke / 2;

    final textRadius = baseRadius - 4.0;

    final totalGap = _kTopGap + (categories.length - 1) * _kSliceGap;

    final availableAngle = 2 * pi - totalGap;

    final double startAngle = -pi / 2 + _kTopGap / 2;

    final trackSweep = 2 * pi - _kTopGap;
    canvas.drawPath(
      _buildRoundedAnnularPath(
        center: center,
        innerRadius: trackInner,
        outerRadius: trackOuter,
        startAngle: startAngle,
        sweepAngle: trackSweep,
      ),
      Paint()
        ..color = theme?.trackColor ?? Colors.black12
        ..style = PaintingStyle.fill,
    );

    double currentAngle = startAngle;
    for (int i = 0; i < categories.length; i++) {
      final category = categories[i];

      final sweep = category.percentage * availableAngle;

      if (sweep > 0.001) {
        canvas.drawPath(
          _buildRoundedAnnularPath(
            center: center,
            innerRadius: arcInner,
            outerRadius: arcOuter,
            startAngle: currentAngle,
            sweepAngle: sweep,
          ),
          Paint()
            ..color = category.color
            ..style = PaintingStyle.fill,
        );

        if (sweep > 0.1) {
          _drawRadialText(
            canvas,
            center,
            textRadius,
            currentAngle + sweep - 0.15,
            '${(category.percentage * 100).toInt()}%',
            textOpacity,
          );
        }
      }

      currentAngle += sweep + _kSliceGap;
    }
  }

  Path _buildRoundedAnnularPath({
    required Offset center,
    required double innerRadius,
    required double outerRadius,
    required double startAngle,
    required double sweepAngle,
  }) {
    final strokeWidth = outerRadius - innerRadius;
    final endAngle = startAngle + sweepAngle;

    final cr = _kCornerRadius.clamp(0.0, strokeWidth / 2 - 0.01);

    final safeOuter = min(cr / outerRadius, sweepAngle / 2);
    final safeInner = min(cr / innerRadius, sweepAngle / 2);

    Offset pt(double r, double a) =>
        Offset(center.dx + r * cos(a), center.dy + r * sin(a));

    const k = 0.552;

    Offset radCtrl(double r, double a, double dist, bool outward) {
      final p = pt(r, a);
      final sign = outward ? 1.0 : -1.0;
      return Offset(p.dx + sign * cos(a) * dist, p.dy + sign * sin(a) * dist);
    }

    Offset tanCtrl(double r, double a, double dist, bool cw) {
      final p = pt(r, a);
      final tx = cw ? -sin(a) : sin(a);
      final ty = cw ? cos(a) : -cos(a);
      return Offset(p.dx + tx * dist, p.dy + ty * dist);
    }

    final outerStartCorner = pt(outerRadius - cr, startAngle);
    final outerArcStart = pt(outerRadius, startAngle + safeOuter);
    final innerStartCorner = pt(innerRadius + cr, startAngle);

    final outerEndCorner = pt(outerRadius - cr, endAngle);
    final innerEndCorner = pt(innerRadius + cr, endAngle);
    final innerArcEnd = pt(innerRadius, endAngle - safeInner);

    final path = Path();

    path.moveTo(innerStartCorner.dx, innerStartCorner.dy);

    path.lineTo(outerStartCorner.dx, outerStartCorner.dy);

    path.cubicTo(
      radCtrl(outerRadius - cr, startAngle, cr * k, true).dx,
      radCtrl(outerRadius - cr, startAngle, cr * k, true).dy,
      tanCtrl(outerRadius, startAngle + safeOuter, cr * k, false).dx,
      tanCtrl(outerRadius, startAngle + safeOuter, cr * k, false).dy,
      outerArcStart.dx,
      outerArcStart.dy,
    );

    final outerSweep = sweepAngle - safeOuter - safeOuter;
    if (outerSweep > 1e-6) {
      path.arcTo(
        Rect.fromCircle(center: center, radius: outerRadius),
        startAngle + safeOuter,
        outerSweep,
        false,
      );
    }

    path.cubicTo(
      tanCtrl(outerRadius, endAngle - safeOuter, cr * k, true).dx,
      tanCtrl(outerRadius, endAngle - safeOuter, cr * k, true).dy,
      radCtrl(outerRadius - cr, endAngle, cr * k, true).dx,
      radCtrl(outerRadius - cr, endAngle, cr * k, true).dy,
      outerEndCorner.dx,
      outerEndCorner.dy,
    );

    path.lineTo(innerEndCorner.dx, innerEndCorner.dy);

    path.cubicTo(
      radCtrl(innerRadius + cr, endAngle, cr * k, false).dx,
      radCtrl(innerRadius + cr, endAngle, cr * k, false).dy,
      tanCtrl(innerRadius, endAngle - safeInner, cr * k, true).dx,
      tanCtrl(innerRadius, endAngle - safeInner, cr * k, true).dy,
      innerArcEnd.dx,
      innerArcEnd.dy,
    );

    final innerSweep = sweepAngle - safeInner - safeInner;
    if (innerSweep > 1e-6) {
      path.arcTo(
        Rect.fromCircle(center: center, radius: innerRadius),
        endAngle - safeInner,
        -innerSweep,
        false,
      );
    }

    path.cubicTo(
      tanCtrl(innerRadius, startAngle + safeInner, cr * k, false).dx,
      tanCtrl(innerRadius, startAngle + safeInner, cr * k, false).dy,
      radCtrl(innerRadius + cr, startAngle, cr * k, false).dx,
      radCtrl(innerRadius + cr, startAngle, cr * k, false).dy,
      innerStartCorner.dx,
      innerStartCorner.dy,
    );

    path.close();
    return path;
  }

  void _drawRadialText(
    Canvas canvas,
    Offset center,
    double radius,
    double angle,
    String text,
    double opacity,
  ) {
    final textStyle = TextStyle(
      color:
          theme?.radialTextColor?.withValues(alpha: opacity) ??
          Colors.grey.withValues(alpha: opacity),
      fontSize: 12,
      fontWeight: FontWeight.w600,
    );
    final textSpan = TextSpan(text: text, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    canvas.save();

    canvas.translate(center.dx, center.dy);

    canvas.rotate(angle + pi / 2);

    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, -radius - textPainter.height / 2),
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.theme != theme ||
        oldDelegate.categories != categories;
  }
}
