import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/mini_project/animation_showcase/animation_topic_model.dart';
import 'package:flutter_application_2/mini_project/animation_showcase/detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late List<Animation<double>> _cardOpacities;
  late List<Animation<Offset>> _cardSlides;

  late Animation<double> _headerOpacity;
  late Animation<Offset> _headerSlide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _headerOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.25, curve: Curves.easeOut),
      ),
    );

    _headerSlide = Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.25, curve: Curves.easeOut),
          ),
        );

    _cardOpacities = [];
    _cardSlides = [];

    for (int i = 0; i < topics.length; i++) {
      final start = 0.20 + i * 0.15;
      final end = (start + 0.35).clamp(0.0, 1.0);

      _cardOpacities.add(
        Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(start, end, curve: Curves.easeOut),
          ),
        ),
      );

      _cardSlides.add(
        Tween<Offset>(begin: const Offset(0.3, 0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(start, end, curve: Curves.easeOut),
          ),
        ),
      );
    }

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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),

              FadeTransition(
                opacity: _headerOpacity,
                child: SlideTransition(
                  position: _headerSlide,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          '🎓  Module 5 – Animations',
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Animation\nShowcase',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap any card to explore',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Expanded(
                child: ListView.separated(
                  itemCount: topics.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final topic = topics[index];
                    return FadeTransition(
                      opacity: _cardOpacities[index],
                      child: SlideTransition(
                        position: _cardSlides[index],

                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailScreen(topic: topic),
                              ),
                            );
                          },

                          child: Hero(
                            tag: topic.id,
                            child: _buildTopicCard(topic),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopicCard(AnimationTopic topic) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: topic.color.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: topic.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(topic.icon, color: topic.color, size: 28),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topic.title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    topic.subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: topic.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),

            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}

class ExplicitDemo extends StatefulWidget {
  const ExplicitDemo({super.key});

  @override
  State<ExplicitDemo> createState() => _ExplicitDemoState();
}

class _ExplicitDemoState extends State<ExplicitDemo>
    with TickerProviderStateMixin {
  late AnimationController _spinnerController;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  String _statusText = 'dismissed';
  Color _statusColor = Colors.grey;

  @override
  void initState() {
    super.initState();

    _spinnerController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _pulseController.addStatusListener((status) {
      setState(() {
        switch (status) {
          case AnimationStatus.forward:
            _statusText = '▶ forward ';
            _statusColor = Colors.blue;
            break;
          case AnimationStatus.reverse:
            _statusText = '◀ reverse ';
            _statusColor = Colors.orange;
            break;
          case AnimationStatus.completed:
            _statusText = '✅ completed ';
            _statusColor = Colors.green;

            _pulseController.reverse();
            break;
          case AnimationStatus.dismissed:
            _statusText = '⬛ dismissed ';
            _statusColor = Colors.grey;

            _pulseController.forward();
            break;
        }
      });
    });

    _pulseController.addListener(() => setState(() {}));
    _spinnerController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _spinnerController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          sectionTitle('Loading Spinner'),
          const SizedBox(height: 20),

          Center(
            child: AnimatedBuilder(
              animation: _spinnerController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _spinnerController.value * 2 * pi,
                  child: child,
                );
              },
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.transparent),
                  gradient: const SweepGradient(
                    colors: [Color(0xFF6C63FF), Color(0x006C63FF)],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5F5FF),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),

          sectionTitle('Pulse + Status Listener'),
          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: _statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _statusColor.withOpacity(0.3)),
            ),
            child: Text(
              _statusText,
              style: TextStyle(
                color: _statusColor,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 24),

          Center(
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: child,
                );
              },
              child: Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                  ),
                ),
                child: const Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 48,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _pulseController.forward(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B6B),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Start Pulse'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _pulseController.stop(),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Stop'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChartPoint {
  final String label;
  final double value;
  const ChartPoint(this.label, this.value);
}

const List<ChartPoint> chartData = [
  ChartPoint('Jan', 4200),
  ChartPoint('Feb', 4800),
  ChartPoint('Mar', 4500),
  ChartPoint('Apr', 5200),
  ChartPoint('May', 4900),
  ChartPoint('Jun', 5800),
];

class ChartDemo extends StatefulWidget {
  const ChartDemo({super.key});

  @override
  State<ChartDemo> createState() => _ChartDemoState();
}

class _ChartDemoState extends State<ChartDemo>
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
      curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
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
    final lastValue = chartData.last.value;
    final firstValue = chartData.first.value;
    final change = ((lastValue - firstValue) / firstValue * 100);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Opacity(
            opacity: _fadeAnimation.value,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Value',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      '\$${lastValue.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '+${change.toStringAsFixed(1)}% ↑',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 180,
                  child: CustomPaint(
                    painter: PortfolioChartPainter(
                      data: chartData,
                      animationValue: _drawAnimation.value,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: chartData.map((p) {
                    return Text(
                      p.label,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 11,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                _controller.reset();
                _controller.forward();
              },
              icon: const Icon(Icons.replay),
              label: const Text('Replay Draw-in Effect'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFB300),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Opacity(
            opacity: _fadeAnimation.value,
            child: Row(
              children: [
                _buildStatChip(
                  'Highest',
                  '\$${chartData.map((e) => e.value).reduce(max).toStringAsFixed(0)}',
                  Colors.greenAccent,
                ),
                const SizedBox(width: 10),
                _buildStatChip(
                  'Lowest',
                  '\$${chartData.map((e) => e.value).reduce(min).toStringAsFixed(0)}',
                  Colors.redAccent,
                ),
                const SizedBox(width: 10),
                _buildStatChip(
                  'Avg',
                  '\$${(chartData.map((e) => e.value).reduce((a, b) => a + b) / chartData.length).toStringAsFixed(0)}',
                  Colors.blueAccent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PortfolioChartPainter extends CustomPainter {
  final List<ChartPoint> data;
  final double animationValue;

  PortfolioChartPainter({required this.data, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final values = data.map((e) => e.value).toList();
    final minVal = values.reduce(min);
    final maxVal = values.reduce(max);
    final range = maxVal - minVal;
    final paddedMin = minVal - range * 0.15;
    final paddedMax = maxVal + range * 0.15;
    final paddedRange = paddedMax - paddedMin;

    double toY(double v) =>
        size.height - ((v - paddedMin) / paddedRange) * size.height;

    double toX(int i) => (i / (data.length - 1)) * size.width;

    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.06)
      ..strokeWidth = 1;

    for (int i = 0; i <= 3; i++) {
      final y = size.height * i / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final path = Path();
    path.moveTo(toX(0), toY(data[0].value));

    for (int i = 1; i < data.length; i++) {
      final cx = (toX(i - 1) + toX(i)) / 2;
      path.cubicTo(
        cx,
        toY(data[i - 1].value),
        cx,
        toY(data[i].value),
        toX(i),
        toY(data[i].value),
      );
    }

    final metrics = path.computeMetrics();
    final animatedPath = Path();

    for (final m in metrics) {
      animatedPath.addPath(
        m.extractPath(0, m.length * animationValue),
        Offset.zero,
      );
    }

    if (animationValue > 0) {
      final fillPath = Path.from(animatedPath);
      final lastM = animatedPath.computeMetrics().last;
      final lastPos =
          lastM.getTangentForOffset(lastM.length)?.position ??
          Offset(size.width, size.height);

      fillPath.lineTo(lastPos.dx, size.height);
      fillPath.lineTo(0, size.height);
      fillPath.close();

      final fillPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFFFB300).withOpacity(0.35),
            const Color(0xFFFFB300).withOpacity(0.0),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..style = PaintingStyle.fill;

      canvas.drawPath(fillPath, fillPaint);
    }

    final linePaint = Paint()
      ..color = const Color(0xFFFFB300)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(animatedPath, linePaint);

    for (int i = 0; i < data.length; i++) {
      final pointProgress = i / (data.length - 1);
      if (animationValue < pointProgress) continue;

      final opacity = ((animationValue - pointProgress) * (data.length - 1))
          .clamp(0.0, 1.0);

      canvas.drawCircle(
        Offset(toX(i), toY(data[i].value)),
        5,
        Paint()
          ..color = Colors.white.withOpacity(opacity)
          ..style = PaintingStyle.fill,
      );
      canvas.drawCircle(
        Offset(toX(i), toY(data[i].value)),
        5,
        Paint()
          ..color = const Color(0xFFFFB300).withOpacity(opacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }

    if (animationValue > 0 && animationValue < 1.0) {
      final m = animatedPath.computeMetrics().last;
      final pos = m.getTangentForOffset(m.length)?.position;
      if (pos != null) {
        canvas.drawCircle(
          pos,
          5,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.fill,
        );
        canvas.drawCircle(
          pos,
          5,
          Paint()
            ..color = const Color(0xFFFFB300)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
      }
    }
  }

  @override
  bool shouldRepaint(PortfolioChartPainter old) =>
      old.animationValue != animationValue;
}

Widget sectionTitle(String title) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.deepPurple,
        ),
      ),
    ),
  );
}
