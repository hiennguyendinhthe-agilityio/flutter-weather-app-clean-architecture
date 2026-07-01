import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/chart_demo/widgets/donut_chart/donut_geometry.dart';

class DonutChartPainter extends CustomPainter {
  DonutChartPainter({
    required this.slices,
    required this.strokeWidth,
    required this.sliceInset,
    required this.expansionValues,
    required this.colorValues,
    required this.sweepProgress,
  });

  final List<NormalizedSlice> slices;
  final double strokeWidth;
  final double sliceInset;
  final Map<int, double> expansionValues;
  final Map<int, Color> colorValues;
  final double sweepProgress;

  @override
  void paint(Canvas canvas, Size size) {
    if (slices.isEmpty || sweepProgress <= 0) return;

    final geometry = DonutGeometry(
      slices: slices,
      size: size,
      strokeWidth: strokeWidth,
      sliceInset: sliceInset,
      animationValues: expansionValues,
      sweepProgress: sweepProgress,
    );
    geometry.buildSlices();

    final paint = Paint()..style = PaintingStyle.fill;

    for (final (i, geo) in geometry.sliceGeometries.indexed) {
      paint.color = colorValues[i] ?? slices[i].original.color;
      canvas.drawPath(geo.buildPath(), paint);
    }
  }

  @override
  bool shouldRepaint(DonutChartPainter old) =>
      sweepProgress != old.sweepProgress ||
      expansionValues != old.expansionValues ||
      colorValues != old.colorValues;
}
