import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/extensions/sales_donut_chart_theme.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/theme_context_ext.dart';

class SalesKpiDonutChart extends StatefulWidget {
  final double percentage; // 0.0 to 1.0
  final String amountString; // e.g., "$ 12 245 / 15 400"

  const SalesKpiDonutChart({
    super.key,
    required this.percentage,
    required this.amountString,
  });

  @override
  State<SalesKpiDonutChart> createState() => _SalesKpiDonutChartState();
}

class _SalesKpiDonutChartState extends State<SalesKpiDonutChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  late double _oldPercentage;
  late double _currentPercentage;

  @override
  void initState() {
    super.initState();
    _oldPercentage = 0.0;
    _currentPercentage = widget.percentage;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant SalesKpiDonutChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.percentage != widget.percentage) {
      _oldPercentage =
          _currentPercentage; // Use current animated value as new starting point
      _currentPercentage = widget.percentage;
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
    final theme = context.salesDonutChartTheme;
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final displayPercentage =
            _oldPercentage +
            (_currentPercentage - _oldPercentage) * _animation.value;

        return CustomPaint(
          size: const Size(280, 280),
          painter: _SalesDonutPainter(
            percentage: displayPercentage,
            amountString: widget.amountString,
            theme: theme,
          ),
        );
      },
    );
  }
}

class _SalesDonutPainter extends CustomPainter {
  final double percentage;
  final String amountString;
  final SalesDonutChartTheme theme;

  _SalesDonutPainter({
    required this.percentage,
    required this.amountString,
    required this.theme,
  });

  // Start angle at 12 o'clock position (top)
  static const double _startAngle = -pi / 2;
  static const double _strokeWidth = 24.0;
  static const double _cornerRadius =
      12.0; // Half of strokeWidth for full roundness

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - _strokeWidth / 2;

    final outerRadius = radius + _strokeWidth / 2;
    final innerRadius = radius - _strokeWidth / 2;

    // 1. Draw Background Track (Dark grey, full circle)
    final trackPaint = Paint()
      ..color = theme.trackColor ?? Colors.black12
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth;
    canvas.drawCircle(center, radius, trackPaint);

    // 2. Draw Progress Arc (Neon Blue)
    final sweepAngle = percentage * 2 * pi;

    if (sweepAngle > 0.01) {
      final path = _buildRoundedAnnularPath(
        center: center,
        innerRadius: innerRadius,
        outerRadius: outerRadius,
        startAngle: _startAngle,
        sweepAngle: sweepAngle,
        cornerRadius: _cornerRadius,
      );

      final progressPaint = Paint()
        ..color = theme.progressColor ?? Colors.blue
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, progressPaint);
    }

    // 3. Draw Floating Icon Marker at End Position (follows progress)
    _drawFloatingIcon(canvas, center, radius, _startAngle + sweepAngle);

    // 4. Draw Central Text
    _drawCentralText(canvas, center);
  }

  void _drawFloatingIcon(
    Canvas canvas,
    Offset center,
    double radius,
    double angle,
  ) {
    // Calculate the exact center of the start cap
    final cx = center.dx + radius * cos(angle);
    final cy = center.dy + radius * sin(angle);

    final iconCenter = Offset(cx, cy);

    // Background circle for the icon (slightly larger than stroke width or matching it)
    final bgPaint = Paint()
      ..color = theme.iconBackgroundColor ?? Colors.blue
      ..style = PaintingStyle.fill;

    // Draw a shadow to make it float
    canvas.drawShadow(
      Path()..addOval(Rect.fromCircle(center: iconCenter, radius: 20)),
      Colors.black.withValues(alpha: 0.5),
      8.0,
      false,
    );

    canvas.drawCircle(iconCenter, 20.0, bgPaint);

    // Inner dark circle to match design
    final innerPaint = Paint()
      ..color = theme.iconInnerColor ?? Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawCircle(iconCenter, 14.0, innerPaint);

    // Draw Icon (Credit Card) using TextPainter with MaterialIcons font
    const iconData = Icons.credit_card;
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: String.fromCharCode(iconData.codePoint),
        style: TextStyle(
          fontSize: 16.0,
          fontFamily: iconData.fontFamily,
          package: iconData.fontPackage,
          color: theme.iconColor ?? Colors.white,
        ),
      ),
    );
    textPainter.layout();

    // Center the icon inside the marker
    textPainter.paint(
      canvas,
      Offset(
        iconCenter.dx - textPainter.width / 2,
        iconCenter.dy - textPainter.height / 2,
      ),
    );
  }

  void _drawCentralText(Canvas canvas, Offset center) {
    // Percentage Text (e.g., "76%")
    final pctString = '${(percentage * 100).round()}%';
    final pctPainter = TextPainter(
      text: TextSpan(text: pctString, style: theme.percentageStyle),
      textDirection: TextDirection.ltr,
    );
    pctPainter.layout();

    // Subtitle Text (e.g., "$ 12 245 / 15 400")
    final subPainter = TextPainter(
      text: TextSpan(text: amountString, style: theme.valueStyle),
      textDirection: TextDirection.ltr,
    );
    subPainter.layout();

    // Total height for vertical centering
    final totalHeight = pctPainter.height + 4.0 + subPainter.height;
    final startY = center.dy - totalHeight / 2;

    pctPainter.paint(canvas, Offset(center.dx - pctPainter.width / 2, startY));

    subPainter.paint(
      canvas,
      Offset(
        center.dx - subPainter.width / 2,
        startY + pctPainter.height + 4.0,
      ),
    );
  }

  // Reuse the geometrically correct rounded annular path builder
  Path _buildRoundedAnnularPath({
    required Offset center,
    required double innerRadius,
    required double outerRadius,
    required double startAngle,
    required double sweepAngle,
    required double cornerRadius,
  }) {
    final strokeWidth = outerRadius - innerRadius;
    final endAngle = startAngle + sweepAngle;

    final cr = cornerRadius.clamp(0.0, strokeWidth / 2 - 0.01);

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

  @override
  bool shouldRepaint(covariant _SalesDonutPainter oldDelegate) {
    return oldDelegate.percentage != percentage ||
        oldDelegate.amountString != amountString ||
        oldDelegate.theme != theme;
  }
}
