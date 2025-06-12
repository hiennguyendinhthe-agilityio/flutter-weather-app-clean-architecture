import 'package:flutter/material.dart';

class TimeAxisPainter extends CustomPainter {
  final double hourHeight;
  final TextStyle labelStyle;
  final Color lineColor;

  TimeAxisPainter({
    required this.hourHeight,
    required this.labelStyle,
    this.lineColor = const Color(0xFFEEEEEE),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 1.0;
    final tp = TextPainter(textDirection: TextDirection.ltr);

    for (int h = 0; h <= 24; h++) {
      final y = h * hourHeight;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
      tp.text = TextSpan(
          text: '${h.toString().padLeft(2, '0')}:00', style: labelStyle);
      tp.layout();
      tp.paint(canvas, Offset(0, y - tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
