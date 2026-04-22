import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/text_styles.dart';

class HeartRateChart extends StatefulWidget {
  final int bpm;

  final List<double> dataPoints;

  const HeartRateChart({
    super.key,
    required this.bpm,
    required this.dataPoints,
  });

  @override
  State<HeartRateChart> createState() => _HeartRateChartState();
}

class _HeartRateChartState extends State<HeartRateChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _growAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _growAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant HeartRateChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.bpm != widget.bpm ||
        oldWidget.dataPoints != widget.dataPoints) {
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
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: FitnessColors.cardBackground,
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Heart Rate', style: FitnessTextStyles.cardTitle),
          const Spacer(),
          Center(
            child: SizedBox(
              height: 50.0,
              width: double.infinity,
              child: AnimatedBuilder(
                animation: _growAnimation,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _WavePainter(
                      dataPoints: widget.dataPoints,
                      animationValue: _growAnimation.value,
                      color: FitnessColors.sleep,
                    ),
                  );
                },
              ),
            ),
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              TweenAnimationBuilder<int>(
                tween: IntTween(begin: 0, end: widget.bpm),
                duration: const Duration(milliseconds: 1400),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Text('$value', style: FitnessTextStyles.chartValue);
                },
              ),
              const SizedBox(width: 4),
              const Text('BPM', style: FitnessTextStyles.cardTitle),
            ],
          ),
        ],
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  final List<double> dataPoints;
  final double animationValue;
  final Color color;
  final double _barWidth;
  final double _spacing;

  _WavePainter({
    required this.dataPoints,
    required this.animationValue,
    required this.color,
    double barWidth = 10.0,
    double spacing = 4.0,
  }) : _spacing = spacing,
       _barWidth = barWidth;

  @override
  void paint(Canvas canvas, Size size) {
    if (dataPoints.isEmpty) return;

    double actualBarWidth = _barWidth;
    double actualSpacing = _spacing;
    double totalWidth =
        (dataPoints.length * actualBarWidth) +
        ((dataPoints.length - 1) * actualSpacing);

    if (totalWidth > size.width) {
      final scaleFactor = size.width / totalWidth;
      actualBarWidth *= scaleFactor;
      actualSpacing *= scaleFactor;
      totalWidth = size.width;
    }

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = actualBarWidth
      ..strokeCap = StrokeCap.round;

    final startX = (size.width - totalWidth) / 2;
    final centerY = size.height / 2;

    for (int i = 0; i < dataPoints.length; i++) {
      final delay = i * (0.2 / dataPoints.length);
      double scale = 0.0;
      if (animationValue > delay) {
        scale = ((animationValue - delay) / 0.8).clamp(0.0, 1.2);
      }

      final actualHeight = size.height * dataPoints[i] * scale;
      final x =
          startX +
          (i * (actualBarWidth + actualSpacing)) +
          (actualBarWidth / 2);

      final topY = centerY - (actualHeight / 2);
      final bottomY = centerY + (actualHeight / 2);

      if (actualHeight > 1.0) {
        canvas.drawLine(Offset(x, topY), Offset(x, bottomY), paint);
      } else if (scale > 0) {
        canvas.drawLine(Offset(x, centerY), Offset(x, centerY + 0.1), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.dataPoints != dataPoints;
  }
}
