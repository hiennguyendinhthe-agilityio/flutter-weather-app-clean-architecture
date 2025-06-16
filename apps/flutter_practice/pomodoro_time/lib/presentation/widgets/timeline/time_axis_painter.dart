import 'package:flutter/material.dart';

class TimeAxisPainter extends CustomPainter {
  final double hourHeight;
  final TextStyle labelStyle;
  final Color lineColor;

  const TimeAxisPainter({
    required this.hourHeight,
    required this.labelStyle,
    this.lineColor = const Color(0xFFE0E0E0),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 1;
    final tp = TextPainter(textDirection: TextDirection.ltr);

    for (var hour = 0; hour <= 24; hour++) {
      final y = hour * hourHeight;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);

      tp.text = TextSpan(
        text: '${hour.toString().padLeft(2, '0')}:00',
        style: labelStyle,
      );
      tp.layout();
      tp.paint(canvas, Offset(0, y - tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
