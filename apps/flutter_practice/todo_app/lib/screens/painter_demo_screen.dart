import 'dart:math';

import 'package:flutter/material.dart';

class MaterialPainterDemoScreen extends StatefulWidget {
  const MaterialPainterDemoScreen({super.key});

  @override
  State<MaterialPainterDemoScreen> createState() =>
      _MaterialPainterDemoScreenState();
}

class _MaterialPainterDemoScreenState extends State<MaterialPainterDemoScreen>
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎨 Material Custom Painter'),
        actions: [
          IconButton(
            icon: Icon(_isAnimating ? Icons.pause : Icons.play_arrow),
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
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildProgressSection(),
            const SizedBox(height: 24),
            _buildWaveSection(),
            const SizedBox(height: 24),
            _buildChartSection(),
            const SizedBox(height: 24),
            _buildControlsSection(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _animationController.reset();
          _animationController.forward();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.palette,
                  color: Theme.of(context).colorScheme.primary,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Text(
                  'Custom Painter Showcase',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Khám phá sức mạnh của CustomPainter và Canvas trong Flutter với Material Design',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🎯 Progress Indicators',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
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
                            painter: MaterialCircularProgressPainter(
                              progress: _progressValue,
                              animationValue: _animationController.value,
                              primaryColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Circular Progress',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
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
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                          ),
                          child: CustomPaint(
                            painter: MaterialLinearProgressPainter(
                              progress: _progressValue,
                              animationValue: _animationController.value,
                              primaryColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Linear Progress',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaveSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🌊 Wave Animation',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Center(
              child: Container(
                width: 200,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: MaterialWavePainter(
                          progress: _progressValue,
                          animationValue: _animationController.value,
                          waveColor: Theme.of(context).colorScheme.primary,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primaryContainer,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📊 Material Chart',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: 200,
                height: 200,
                child: CustomPaint(
                  painter: MaterialChartPainter(
                    colorScheme: Theme.of(context).colorScheme,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🎛️ Controls',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Text(
              'Progress Value: ${(_progressValue * 100).toInt()}%',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Slider(
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
                FilledButton.icon(
                  onPressed: () {
                    _animationController.reset();
                    _animationController.forward();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Restart'),
                ),
                FilledButton.tonalIcon(
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
                  icon: Icon(_isAnimating ? Icons.pause : Icons.play_arrow),
                  label: Text(_isAnimating ? 'Pause' : 'Play'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Material Design Custom Painters
class MaterialCircularProgressPainter extends CustomPainter {
  final double progress;
  final double animationValue;
  final Color primaryColor;
  final Color backgroundColor;

  MaterialCircularProgressPainter({
    required this.progress,
    required this.animationValue,
    required this.primaryColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 10;

    if (radius <= 0) return;

    // Background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    if (progress > 0) {
      final progressPaint = Paint()
        ..color = primaryColor
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

      // Animated dot with Material elevation
      final dotAngle = -pi / 2 + sweepAngle;
      final dotX = center.dx + radius * cos(dotAngle);
      final dotY = center.dy + radius * sin(dotAngle);

      // Shadow for elevation
      final shadowPaint = Paint()
        ..color = Colors.black.withValues(alpha: 0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

      canvas.drawCircle(Offset(dotX + 2, dotY + 2), 8, shadowPaint);

      final dotPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(dotX, dotY), 6, dotPaint);
    }

    // Progress text with Material typography
    final textPainter = TextPainter(
      text: TextSpan(
        text: '${(progress * 100).toInt()}%',
        style: TextStyle(
          color: primaryColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: 'Roboto',
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

class MaterialLinearProgressPainter extends CustomPainter {
  final double progress;
  final double animationValue;
  final Color primaryColor;

  MaterialLinearProgressPainter({
    required this.progress,
    required this.animationValue,
    required this.primaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0 || progress <= 0) return;

    final progressWidth = size.width * progress;
    if (progressWidth <= 0) return;

    // Material Design gradient
    final progressPaint = Paint()
      ..shader = LinearGradient(
        colors: [primaryColor, primaryColor.withValues(alpha: 0.8)],
      ).createShader(Rect.fromLTWH(0, 0, progressWidth, size.height))
      ..style = PaintingStyle.fill;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, progressWidth, size.height),
      const Radius.circular(10),
    );

    canvas.drawRRect(rect, progressPaint);

    // Material shimmer effect
    final shimmerPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;

    final shimmerX = (progressWidth * animationValue) - 30;
    if (shimmerX > -30 && shimmerX < progressWidth) {
      final shimmerRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(max(0, shimmerX), 0, min(30, progressWidth), size.height),
        const Radius.circular(10),
      );
      canvas.drawRRect(shimmerRect, shimmerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class MaterialWavePainter extends CustomPainter {
  final double progress;
  final double animationValue;
  final Color waveColor;
  final Color backgroundColor;

  MaterialWavePainter({
    required this.progress,
    required this.animationValue,
    required this.waveColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    // Background with Material elevation
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      backgroundPaint,
    );

    if (progress <= 0) return;

    // Material wave with gradient
    final waveHeight = size.height * (1 - progress);
    final wavePath = Path();
    wavePath.moveTo(0, waveHeight);

    for (double x = 0; x <= size.width; x += 2) {
      final normalizedX = x / size.width;
      final y =
          waveHeight + 10 * sin(normalizedX * 4 * pi + animationValue * 2 * pi);
      wavePath.lineTo(x, y);
    }

    wavePath.lineTo(size.width, size.height);
    wavePath.lineTo(0, size.height);
    wavePath.close();

    final wavePaint = Paint()
      ..shader =
          LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [waveColor.withValues(alpha: 0.7), waveColor],
          ).createShader(
            Rect.fromLTWH(0, waveHeight, size.width, size.height - waveHeight),
          )
      ..style = PaintingStyle.fill;

    canvas.drawPath(wavePath, wavePaint);

    // Progress text with Material typography
    final textPainter = TextPainter(
      text: TextSpan(
        text: '${(progress * 100).toInt()}%',
        style: TextStyle(
          color: progress > 0.5 ? Colors.white : waveColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'Roboto',
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

class MaterialChartPainter extends CustomPainter {
  final ColorScheme colorScheme;

  MaterialChartPainter({required this.colorScheme});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 20;

    if (radius <= 0) return;

    // Material Design color palette
    final data = [
      {'label': 'Flutter', 'value': 35.0, 'color': colorScheme.primary},
      {'label': 'React', 'value': 25.0, 'color': colorScheme.secondary},
      {'label': 'Vue', 'value': 20.0, 'color': colorScheme.tertiary},
      {'label': 'Angular', 'value': 20.0, 'color': colorScheme.error},
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

      // Shadow for Material elevation
      final shadowPaint = Paint()
        ..color = Colors.black.withValues(alpha: 0.1)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

      canvas.drawArc(
        Rect.fromCircle(
          center: Offset(center.dx + 2, center.dy + 2),
          radius: radius,
        ),
        startAngle,
        sweepAngle,
        true,
        shadowPaint,
      );

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

      // Material border
      final borderPaint = Paint()
        ..color = colorScheme.surface
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

    // Center circle with Material elevation
    final centerShadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawCircle(
      Offset(center.dx + 1, center.dy + 1),
      25,
      centerShadowPaint,
    );

    final centerPaint = Paint()
      ..color = colorScheme.surface
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 25, centerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
