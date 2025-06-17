import 'package:flutter/material.dart';

class TimeAxisPainter extends CustomPainter {
  final double hourHeight;
  final double timeLabelWidth;
  final Color lineColor;
  final TextStyle labelStyle;

  const TimeAxisPainter({
    this.hourHeight = 60.0,
    this.timeLabelWidth = 68.0,
    this.lineColor = const Color(0xFFE0E0E0),
    this.labelStyle = const TextStyle(color: Colors.grey),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 1;
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (var i = 0; i <= 24; i++) {
      final y = i * hourHeight;

      canvas.drawLine(
        Offset(timeLabelWidth, y),
        Offset(size.width, y),
        paint,
      );

      final label = '${i.toString().padLeft(2, '0')}:00';
      textPainter.text = TextSpan(text: label, style: labelStyle);
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(0, y - textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(TimeAxisPainter oldDelegate) => false;
}
