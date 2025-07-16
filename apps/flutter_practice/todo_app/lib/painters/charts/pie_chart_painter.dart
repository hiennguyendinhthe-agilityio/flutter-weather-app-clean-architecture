import 'dart:math';
import 'package:flutter/material.dart';

class ChartData {
  final String label;
  final double value;
  final Color color;

  ChartData(this.label, this.value, this.color);
}

class PieChartPainter extends CustomPainter {
  final List<ChartData> data;
  final int selectedIndex;
  final double explosionDistance;

  PieChartPainter({
    required this.data,
    this.selectedIndex = -1,
    this.explosionDistance = 10.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 40;
    final total = data.fold(0.0, (sum, item) => sum + item.value);

    double startAngle = -pi / 2; // Start from top

    for (int i = 0; i < data.length; i++) {
      final sweepAngle = (data[i].value / total) * 2 * pi;
      final isSelected = i == selectedIndex;
      
      // Calculate center offset for explosion effect
      Offset segmentCenter = center;
      if (isSelected) {
        final midAngle = startAngle + sweepAngle / 2;
        segmentCenter = Offset(
          center.dx + explosionDistance * cos(midAngle),
          center.dy + explosionDistance * sin(midAngle),
        );
      }

      // Draw segment
      final segmentPaint = Paint()
        ..color = data[i].color
        ..style = PaintingStyle.fill;

      // Add shadow for selected segment
      if (isSelected) {
        final shadowPaint = Paint()
          ..color = Colors.black.withOpacity(0.3)
          ..style = PaintingStyle.fill
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

        canvas.drawArc(
          Rect.fromCircle(center: segmentCenter, radius: radius),
          startAngle,
          sweepAngle,
          true,
          shadowPaint,
        );
      }

      canvas.drawArc(
        Rect.fromCircle(center: segmentCenter, radius: radius),
        startAngle,
        sweepAngle,
        true,
        segmentPaint,
      );

      // Draw border
      final borderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawArc(
        Rect.fromCircle(center: segmentCenter, radius: radius),
        startAngle,
        sweepAngle,
        true,
        borderPaint,
      );

      // Draw label
      _drawLabel(canvas, segmentCenter, radius, startAngle, sweepAngle, data[i], isSelected);

      startAngle += sweepAngle;
    }

    // Draw center circle
    final centerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 30, centerPaint);

    // Draw center border
    final centerBorderPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, 30, centerBorderPaint);
  }

  void _drawLabel(Canvas canvas, Offset center, double radius, double startAngle, 
                  double sweepAngle, ChartData chartData, bool isSelected) {
    final midAngle = startAngle + sweepAngle / 2;
    final labelRadius = radius * 0.7;
    final labelX = center.dx + labelRadius * cos(midAngle);
    final labelY = center.dy + labelRadius * sin(midAngle);

    // Draw percentage
    final percentage = ((chartData.value / data.fold(0.0, (sum, item) => sum + item.value)) * 100).toInt();
    
    final textPainter = TextPainter(
      text: TextSpan(
        text: '$percentage%',
        style: TextStyle(
          color: Colors.white,
          fontSize: isSelected ? 16 : 14,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    final textOffset = Offset(
      labelX - textPainter.width / 2,
      labelY - textPainter.height / 2,
    );
    textPainter.paint(canvas, textOffset);

    // Draw label outside the chart
    if (isSelected) {
      final outerLabelRadius = radius + 50;
      final outerLabelX = center.dx + outerLabelRadius * cos(midAngle);
      final outerLabelY = center.dy + outerLabelRadius * sin(midAngle);

      final labelPainter = TextPainter(
        text: TextSpan(
          text: chartData.label,
          style: TextStyle(
            color: chartData.color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      labelPainter.layout();
      
      // Draw background for label
      final labelBgPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      final labelRect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(outerLabelX, outerLabelY),
          width: labelPainter.width + 16,
          height: labelPainter.height + 8,
        ),
        const Radius.circular(8),
      );

      canvas.drawRRect(labelRect, labelBgPaint);

      // Draw border for label
      final labelBorderPaint = Paint()
        ..color = chartData.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawRRect(labelRect, labelBorderPaint);

      // Draw label text
      final labelOffset = Offset(
        outerLabelX - labelPainter.width / 2,
        outerLabelY - labelPainter.height / 2,
      );
      labelPainter.paint(canvas, labelOffset);

      // Draw line from segment to label
      final linePaint = Paint()
        ..color = chartData.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      final lineStartX = center.dx + radius * cos(midAngle);
      final lineStartY = center.dy + radius * sin(midAngle);
      final lineEndX = center.dx + (radius + 30) * cos(midAngle);
      final lineEndY = center.dy + (radius + 30) * sin(midAngle);

      canvas.drawLine(
        Offset(lineStartX, lineStartY),
        Offset(lineEndX, lineEndY),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}