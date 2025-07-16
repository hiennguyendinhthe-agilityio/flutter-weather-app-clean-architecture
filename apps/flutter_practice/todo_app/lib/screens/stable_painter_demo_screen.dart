import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StablePainterDemoScreen extends StatefulWidget {
  const StablePainterDemoScreen({super.key});

  @override
  State<StablePainterDemoScreen> createState() =>
      _StablePainterDemoScreenState();
}

class _StablePainterDemoScreenState extends State<StablePainterDemoScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  double _progressValue = 0.7;
  bool _isAnimating = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    if (_isAnimating) {
      _animationController.repeat();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('🎨 Stable Custom Painter'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 30),
              _buildProgressSection(),
              const SizedBox(height: 30),
              _buildWaveSection(),
              const SizedBox(height: 30),
              _buildChartSection(),
              const SizedBox(height: 30),
              _buildControlsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CupertinoColors.separator),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                CupertinoIcons.paintbrush_fill,
                color: CupertinoColors.systemBlue,
                size: 30,
              ),
              const SizedBox(width: 12),
              const Text(
                'Custom Painter Showcase',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.label,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Khám phá sức mạnh của CustomPainter và Canvas trong Flutter',
            style: TextStyle(
              fontSize: 16,
              color: CupertinoColors.secondaryLabel,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CupertinoColors.separator),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🎯 Progress Indicators',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.label,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Circular Progress
              Column(
                children: [
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return SizedBox(
                        width: 120,
                        height: 120,
                        child: CustomPaint(
                          painter: StableCircularProgressPainter(
                            progress: _progressValue,
                            animationValue: _animationController.value,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  const Text('Circular Progress'),
                ],
              ),

              // Linear Progress
              Column(
                children: [
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Container(
                        width: 150,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: CupertinoColors.systemGrey5,
                        ),
                        child: CustomPaint(
                          painter: StableLinearProgressPainter(
                            progress: _progressValue,
                            animationValue: _animationController.value,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  const Text('Linear Progress'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWaveSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CupertinoColors.separator),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🌊 Wave Animation',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.label,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Container(
              width: 200,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: CupertinoColors.systemBlue, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: StableWavePainter(
                        progress: _progressValue,
                        animationValue: _animationController.value,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CupertinoColors.separator),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📊 Simple Chart',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.label,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: SizedBox(
              width: 200,
              height: 200,
              child: CustomPaint(painter: StableChartPainter()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CupertinoColors.separator),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🎛️ Controls',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.label,
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'Progress Value: ${(_progressValue * 100).toInt()}%',
            style: const TextStyle(fontSize: 16, color: CupertinoColors.label),
          ),
          CupertinoSlider(
            value: _progressValue,
            onChanged: (value) {
              setState(() {
                _progressValue = value;
              });
            },
          ),

          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CupertinoButton.filled(
                onPressed: () {
                  _animationController.reset();
                  _animationController.forward();
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(CupertinoIcons.refresh, size: 18),
                    SizedBox(width: 8),
                    Text('Restart'),
                  ],
                ),
              ),
              CupertinoButton.filled(
                onPressed: () {
                  setState(() {
                    _isAnimating = !_isAnimating;
                    if (_isAnimating) {
                      _animationController.repeat();
                    } else {
                      _animationController.stop();
                    }
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isAnimating
                          ? CupertinoIcons.pause
                          : CupertinoIcons.play_arrow,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(_isAnimating ? 'Pause' : 'Play'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Stable Circular Progress Painter
class StableCircularProgressPainter extends CustomPainter {
  final double progress;
  final double animationValue;

  StableCircularProgressPainter({
    required this.progress,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 10;

    if (radius <= 0) return;

    // Background circle
    final backgroundPaint = Paint()
      ..color = CupertinoColors.systemGrey4
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    if (progress > 0) {
      final progressPaint = Paint()
        ..color = CupertinoColors.systemBlue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round;

      final sweepAngle = 2 * pi * progress;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        sweepAngle,
        false,
        progressPaint,
      );

      // Animated dot
      final dotAngle = -pi / 2 + sweepAngle;
      final dotX = center.dx + radius * cos(dotAngle);
      final dotY = center.dy + radius * sin(dotAngle);

      final dotPaint = Paint()
        ..color = CupertinoColors.white
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(dotX, dotY), 6, dotPaint);
    }

    // Progress text
    final textPainter = TextPainter(
      text: TextSpan(
        text: '${(progress * 100).toInt()}%',
        style: const TextStyle(
          color: CupertinoColors.label,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    final textOffset = Offset(
      center.dx - textPainter.width / 2,
      center.dy - textPainter.height / 2,
    );
    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Stable Linear Progress Painter
class StableLinearProgressPainter extends CustomPainter {
  final double progress;
  final double animationValue;

  StableLinearProgressPainter({
    required this.progress,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0 || progress <= 0) return;

    final progressWidth = size.width * progress;
    if (progressWidth <= 0) return;

    final progressPaint = Paint()
      ..color = CupertinoColors.systemBlue
      ..style = PaintingStyle.fill;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, progressWidth, size.height),
      const Radius.circular(10),
    );

    canvas.drawRRect(rect, progressPaint);

    // Simple shimmer effect
    final shimmerPaint = Paint()
      ..color = CupertinoColors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final shimmerX = (progressWidth * animationValue) - 20;
    if (shimmerX > -20 && shimmerX < progressWidth) {
      final shimmerRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(max(0, shimmerX), 0, min(20, progressWidth), size.height),
        const Radius.circular(10),
      );
      canvas.drawRRect(shimmerRect, shimmerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Stable Wave Painter
class StableWavePainter extends CustomPainter {
  final double progress;
  final double animationValue;

  StableWavePainter({required this.progress, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    // Background
    final backgroundPaint = Paint()
      ..color = CupertinoColors.systemBlue.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      backgroundPaint,
    );

    if (progress <= 0) return;

    // Wave
    final waveHeight = size.height * (1 - progress);
    final wavePath = Path();
    wavePath.moveTo(0, waveHeight);

    for (double x = 0; x <= size.width; x += 2) {
      final normalizedX = x / size.width;
      final y =
          waveHeight + 8 * sin(normalizedX * 4 * pi + animationValue * 2 * pi);
      wavePath.lineTo(x, y);
    }

    wavePath.lineTo(size.width, size.height);
    wavePath.lineTo(0, size.height);
    wavePath.close();

    final wavePaint = Paint()
      ..color = CupertinoColors.systemBlue.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    canvas.drawPath(wavePath, wavePaint);

    // Progress text
    final textPainter = TextPainter(
      text: TextSpan(
        text: '${(progress * 100).toInt()}%',
        style: TextStyle(
          color: progress > 0.5 ? CupertinoColors.white : CupertinoColors.label,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    final textOffset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );
    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Stable Chart Painter
class StableChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 20;

    if (radius <= 0) return;

    final data = [
      {'label': 'Flutter', 'value': 35.0, 'color': CupertinoColors.systemBlue},
      {'label': 'React', 'value': 25.0, 'color': CupertinoColors.systemGreen},
      {'label': 'Vue', 'value': 20.0, 'color': CupertinoColors.systemOrange},
      {'label': 'Angular', 'value': 20.0, 'color': CupertinoColors.systemRed},
    ];

    double startAngle = -pi / 2;
    final total = data.fold(
      0.0,
      (sum, item) => sum + (item['value'] as double),
    );

    for (var item in data) {
      final value = item['value'] as double;
      final color = item['color'] as Color;
      final sweepAngle = (value / total) * 2 * pi;

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      // Border
      final borderPaint = Paint()
        ..color = CupertinoColors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        borderPaint,
      );

      startAngle += sweepAngle;
    }

    // Center circle
    final centerPaint = Paint()
      ..color = CupertinoColors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 25, centerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
