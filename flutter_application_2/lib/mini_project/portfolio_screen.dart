import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: PortfolioScreen());
  }
}

class ChartDataPoint {
  final String label;
  final double value;

  const ChartDataPoint({required this.label, required this.value});
}

const List<ChartDataPoint> portfolioData = [
  ChartDataPoint(label: 'Jan', value: 4200),
  ChartDataPoint(label: 'Feb', value: 4800),
  ChartDataPoint(label: 'Mar', value: 4500),
  ChartDataPoint(label: 'Apr', value: 5200),
  ChartDataPoint(label: 'May', value: 4900),
  ChartDataPoint(label: 'Jun', value: 5800),
];

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});
  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _drawAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _drawAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.2, curve: Curves.easeIn),
    );

    _controller.addListener(() => setState(() {}));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final firstValue = portfolioData.first.value;
    final lastValue = portfolioData.last.value;
    final changePercent = ((lastValue - firstValue) / firstValue * 100);
    final isPositive = changePercent > 0;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text('Portfolio', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.replay, color: Colors.white),
            onPressed: () {
              _controller.reset();
              _controller.forward();
            },
          ),
        ],
      ),
      body: Opacity(
        opacity: _fadeAnimation.value,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total Value',
                style: TextStyle(color: Colors.white60, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                '\$${lastValue.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isPositive
                      ? Colors.green.withValues(alpha: 0.2)
                      : Colors.red.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${isPositive ? '+' : ''}${changePercent.toStringAsFixed(1)}%  '
                  '${isPositive ? '↑' : '↓'}  Last 6 months',
                  style: TextStyle(
                    color: isPositive ? Colors.greenAccent : Colors.redAccent,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF16213E),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: CustomPaint(
                        painter: ChartPainter(
                          data: portfolioData,
                          animationValue: _drawAnimation.value,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: portfolioData.map((point) {
                        return Text(
                          point.label,
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 12,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  _buildStatCard(
                    label: 'Highest',
                    value:
                        '\$${portfolioData.map((e) => e.value).reduce((a, b) => a > b ? a : b).toStringAsFixed(0)}',
                    color: Colors.greenAccent,
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    label: 'Lowest',
                    value:
                        '\$${portfolioData.map((e) => e.value).reduce((a, b) => a < b ? a : b).toStringAsFixed(0)}',
                    color: Colors.redAccent,
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    label: 'Average',
                    value:
                        '\$${(portfolioData.map((e) => e.value).reduce((a, b) => a + b) / portfolioData.length).toStringAsFixed(0)}',
                    color: Colors.blueAccent,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF16213E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white38, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartPainter extends CustomPainter {
  final List<ChartDataPoint> data;
  final double animationValue;

  ChartPainter({required this.data, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final minValue = data.map((e) => e.value).reduce((a, b) => a < b ? a : b);
    final maxValue = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    final valueRange = maxValue - minValue;
    final paddedMin = minValue - valueRange * 0.1;
    final paddedMax = maxValue + valueRange * 0.1;
    final paddedRange = paddedMax - paddedMin;

    double toY(double value) {
      return size.height - ((value - paddedMin) / paddedRange) * size.height;
    }

    double toX(int index) {
      return (index / (data.length - 1)) * size.width;
    }

    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..strokeWidth = 1;

    for (int i = 0; i <= 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final fullPath = Path();

    fullPath.moveTo(toX(0), toY(data[0].value));

    for (int i = 1; i < data.length; i++) {
      final x = toX(i);
      final y = toY(data[i].value);

      final prevX = toX(i - 1);
      final prevY = toY(data[i - 1].value);

      final controlX = (prevX + x) / 2;

      fullPath.cubicTo(controlX, prevY, controlX, y, x, y);
    }

    final pathMetrics = fullPath.computeMetrics();
    final animatedPath = Path();

    for (final metric in pathMetrics) {
      final extractPath = metric.extractPath(0, metric.length * animationValue);
      animatedPath.addPath(extractPath, Offset.zero);
    }

    final fillPath = Path.from(animatedPath);

    if (animationValue > 0) {
      final lastMetric = animatedPath.computeMetrics().last;
      final lastTangent = lastMetric.getTangentForOffset(lastMetric.length);
      final lastPoint = lastTangent?.position ?? Offset(0, size.height);

      fillPath.lineTo(lastPoint.dx, size.height);
      fillPath.lineTo(0, size.height);
      fillPath.close();

      final gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.blueAccent.withValues(alpha: 0.4),
          Colors.blueAccent.withValues(alpha: 0.0),
        ],
      );

      final fillPaint = Paint()
        ..shader = gradient.createShader(
          Rect.fromLTWH(0, 0, size.width, size.height),
        )
        ..style = PaintingStyle.fill;

      canvas.drawPath(fillPath, fillPaint);
    }

    final linePaint = Paint()
      ..color = Colors.blueAccent
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(animatedPath, linePaint);

    if (animationValue > 0 && animationValue < 1.0) {
      final metrics = animatedPath.computeMetrics();
      for (final metric in metrics) {
        final tangent = metric.getTangentForOffset(metric.length);
        if (tangent != null) {
          final dotPaint = Paint()
            ..color = Colors.white
            ..style = PaintingStyle.fill;

          final dotBorderPaint = Paint()
            ..color = Colors.blueAccent
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2;

          canvas.drawCircle(tangent.position, 6, dotPaint);
          canvas.drawCircle(tangent.position, 6, dotBorderPaint);
        }
      }
    }

    for (int i = 0; i < data.length; i++) {
      final pointProgress = i / (data.length - 1);

      if (animationValue >= pointProgress) {
        final x = toX(i);
        final y = toY(data[i].value);

        final opacity =
            ((animationValue - pointProgress) / (1 / (data.length - 1))).clamp(
          0.0,
          1.0,
        );

        final dotPaint = Paint()
          ..color = Colors.white.withValues(alpha: opacity)
          ..style = PaintingStyle.fill;

        final dotBorderPaint = Paint()
          ..color = Colors.blueAccent.withValues(alpha: opacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

        canvas.drawCircle(Offset(x, y), 5, dotPaint);
        canvas.drawCircle(Offset(x, y), 5, dotBorderPaint);
      }
    }
  }

  @override
  bool shouldRepaint(ChartPainter old) {
    return old.animationValue != animationValue;
  }
}
