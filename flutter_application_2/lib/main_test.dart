import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// ===============================
/// APP ROOT
/// ===============================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFFEDEDED),
        body: Center(child: DonutChart(values: [40, 25, 15, 10, 10])),
      ),
    );
  }
}

/// ===============================
/// DONUT CHART WIDGET
/// ===============================
class DonutChart extends StatelessWidget {
  const DonutChart({super.key, required this.values});

  final List<double> values;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(250, 250),
      painter: DonutPainter(values),
    );
  }
}

/// ===============================
/// PAINTER – NƠI VẼ UI
/// ===============================
class DonutPainter extends CustomPainter {
  DonutPainter(this.values);

  final List<double> values;

  @override
  void paint(Canvas canvas, Size size) {
    /// ===== 1. TÍNH TỔNG =====
    final total = values.reduce((a, b) => a + b);

    /// ===== 2. THÔNG SỐ CƠ BẢN =====
    final center = Offset(size.width / 2, size.height / 2);

    final strokeWidth = 40.0; // 👉 ĐỘ DÀY DONUT
    final outerRadius = size.width / 2;
    final innerRadius = outerRadius - strokeWidth;

    /// 👉 khoảng trống giữa các slice
    final gap = _degToRad(6);

    /// 👉 bắt đầu từ 12h
    double startAngle = -pi / 2;

    /// ===== 3. LOOP VẼ TỪNG SLICE =====
    for (int i = 0; i < values.length; i++) {
      final value = values[i];

      /// 👉 đổi value -> góc
      final sweepAngle = (value / total) * 2 * pi - gap;

      final path = Path();

      /// ===============================
      /// BẮT ĐẦU VẼ SLICE
      /// ===============================

      /// 👉 điểm outer start
      final outerStart = _point(center, outerRadius, startAngle);

      path.moveTo(outerStart.dx, outerStart.dy);

      /// ===== 1. BO GÓC START =====
      final cornerAngle = _degToRad(8);

      final outerStartArc = _point(
        center,
        outerRadius,
        startAngle + cornerAngle,
      );

      path.quadraticBezierTo(
        outerStart.dx,
        outerStart.dy,
        outerStartArc.dx,
        outerStartArc.dy,
      );

      /// ===== 2. ARC NGOÀI =====
      path.arcTo(
        Rect.fromCircle(center: center, radius: outerRadius),
        startAngle + cornerAngle,
        sweepAngle - cornerAngle * 2,
        false,
      );

      /// ===== 3. BO GÓC END =====
      final outerEnd = _point(center, outerRadius, startAngle + sweepAngle);

      final outerEndArc = _point(
        center,
        outerRadius,
        startAngle + sweepAngle - cornerAngle,
      );

      path.quadraticBezierTo(
        outerEnd.dx,
        outerEnd.dy,
        outerEndArc.dx,
        outerEndArc.dy,
      );

      /// ===== 4. NỐI VÀO INNER =====
      final innerEnd = _point(center, innerRadius, startAngle + sweepAngle);

      path.lineTo(innerEnd.dx, innerEnd.dy);

      /// ===== 5. ARC TRONG =====
      path.arcTo(
        Rect.fromCircle(center: center, radius: innerRadius),
        startAngle + sweepAngle - cornerAngle,
        -(sweepAngle - cornerAngle * 2),
        false,
      );

      /// ===== 6. KHÉP PATH =====
      path.close();

      /// ===== 7. VẼ =====
      final paint = Paint()
        ..color = Colors.primaries[i % Colors.primaries.length]
        ..style = PaintingStyle.fill;

      canvas.drawPath(path, paint);

      /// 👉 cập nhật góc cho slice tiếp theo
      startAngle += sweepAngle + gap;
    }
  }

  /// ===============================
  /// HELPER
  /// ===============================
  Offset _point(Offset center, double radius, double angle) {
    return Offset(
      center.dx + cos(angle) * radius,
      center.dy + sin(angle) * radius,
    );
  }

  double _degToRad(double deg) {
    return deg * pi / 180;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
