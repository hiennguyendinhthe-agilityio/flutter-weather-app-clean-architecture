import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/chart_demo/core/constants.dart';
import 'package:flutter_advanced_course/chart_demo/models/bar_item_data.dart';

class BarColumnPainter extends CustomPainter {
  BarColumnPainter({
    required this.item,
    required this.growProgress,
    required this.primaryRatio,
    required this.totalRatio,
    this.borderRadius = BarDefaults.borderRadius,
    this.gapBetweenSegments = BarDefaults.gapBetweenSegs,
  });

  final BarItemData item;
  final double growProgress;
  final double primaryRatio;
  final double totalRatio;
  final double borderRadius;
  final double gapBetweenSegments;

  @override
  void paint(Canvas canvas, Size size) {
    if (growProgress <= 0) return;

    final maxH = size.height;
    final width = size.width;
    final radius = Radius.circular(borderRadius);

    final totalH = maxH * totalRatio * growProgress;
    final primaryH = maxH * primaryRatio * growProgress;

    if (totalH <= 0) return;

    final bottom = maxH;

    final secondaryH = totalH - primaryH - gapBetweenSegments;
    if (secondaryH > 0) {
      final secondaryRect = RRect.fromLTRBAndCorners(
        0,
        bottom - totalH,
        width,
        bottom - primaryH - gapBetweenSegments,
        topLeft: radius,
        topRight: radius,
      );
      canvas.drawRRect(
        secondaryRect,
        Paint()..color = item.resolvedSecondaryColor,
      );
    }

    final hasSecondary = secondaryH > 0;
    final primaryRect = RRect.fromLTRBAndCorners(
      0,
      bottom - primaryH,
      width,
      bottom,
      topLeft: hasSecondary ? Radius.zero : radius,
      topRight: hasSecondary ? Radius.zero : radius,
      bottomLeft: radius,
      bottomRight: radius,
    );
    canvas.drawRRect(primaryRect, Paint()..color = item.color);

    if (item.valueLabel != null && growProgress > 0.85) {
      final labelOpacity = ((growProgress - 0.85) / 0.15).clamp(0.0, 1.0);
      _paintLabel(
        canvas,
        size,
        item.valueLabel!,
        bottom - totalH - 8,
        opacity: labelOpacity,
      );
    }
  }

  void _paintLabel(
    Canvas canvas,
    Size size,
    String text,
    double topY, {
    double opacity = 1.0,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: item.color.withValues(alpha: opacity),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: size.width);

    final x = (size.width - textPainter.width) / 2;
    textPainter.paint(canvas, Offset(x, topY));
  }

  @override
  bool shouldRepaint(BarColumnPainter old) =>
      growProgress != old.growProgress ||
      primaryRatio != old.primaryRatio ||
      totalRatio != old.totalRatio ||
      item != old.item;
}
