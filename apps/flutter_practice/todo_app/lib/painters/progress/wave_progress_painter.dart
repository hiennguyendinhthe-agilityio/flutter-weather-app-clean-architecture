import 'dart:math';
import 'package:flutter/material.dart';

class WaveProgressPainter extends CustomPainter {
  final double progress;
  final double animationValue;
  final Color waveColor;
  final Color backgroundColor;

  WaveProgressPainter({
    required this.progress,
    required this.animationValue,
    this.waveColor = Colors.blue,
    this.backgroundColor = Colors.blue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Background
    final backgroundPaint = Paint()
      ..color = backgroundColor.withOpacity(0.1)
      ..style = PaintingStyle.fill;
    
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    // Calculate wave parameters
    final waveHeight = size.height * (1 - progress);
    final waveAmplitude = 8.0;
    final waveFrequency = 2.0;
    final waveSpeed = animationValue * 2 * pi;

    // Create wave path
    final wavePath = Path();
    wavePath.moveTo(0, waveHeight);

    // Generate wave points
    for (double x = 0; x <= size.width; x += 1) {
      final y = waveHeight + 
          waveAmplitude * sin((x / size.width) * waveFrequency * 2 * pi + waveSpeed) +
          waveAmplitude * 0.5 * sin((x / size.width) * waveFrequency * 4 * pi + waveSpeed * 1.5);
      wavePath.lineTo(x, y);
    }

    // Complete the path
    wavePath.lineTo(size.width, size.height);
    wavePath.lineTo(0, size.height);
    wavePath.close();

    // Wave gradient
    final waveGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        waveColor.withOpacity(0.7),
        waveColor,
      ],
    );

    final wavePaint = Paint()
      ..shader = waveGradient.createShader(
        Rect.fromLTWH(0, waveHeight, size.width, size.height - waveHeight),
      )
      ..style = PaintingStyle.fill;

    canvas.drawPath(wavePath, wavePaint);

    // Secondary wave for depth effect
    final secondWavePath = Path();
    final secondWaveHeight = waveHeight + 5;
    secondWavePath.moveTo(0, secondWaveHeight);

    for (double x = 0; x <= size.width; x += 1) {
      final y = secondWaveHeight + 
          waveAmplitude * 0.7 * sin((x / size.width) * waveFrequency * 2 * pi + waveSpeed * 0.8) +
          waveAmplitude * 0.3 * sin((x / size.width) * waveFrequency * 3 * pi + waveSpeed * 1.2);
      secondWavePath.lineTo(x, y);
    }

    secondWavePath.lineTo(size.width, size.height);
    secondWavePath.lineTo(0, size.height);
    secondWavePath.close();

    final secondWavePaint = Paint()
      ..color = waveColor.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    canvas.drawPath(secondWavePath, secondWavePaint);

    // Bubbles effect
    _drawBubbles(canvas, size);

    // Progress text
    final textPainter = TextPainter(
      text: TextSpan(
        text: '${(progress * 100).toInt()}%',
        style: TextStyle(
          color: progress > 0.5 ? Colors.white : waveColor,
          fontSize: 24,
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

  void _drawBubbles(Canvas canvas, Size size) {
    final bubblePaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    final random = Random(42); // Fixed seed for consistent bubbles
    
    for (int i = 0; i < 15; i++) {
      final x = random.nextDouble() * size.width;
      final baseY = size.height * (1 - progress) + 20;
      final y = baseY + (random.nextDouble() * 50) + 
               sin(animationValue * 2 * pi + i) * 10;
      
      if (y < size.height && y > size.height * (1 - progress)) {
        final radius = 2 + random.nextDouble() * 4;
        canvas.drawCircle(Offset(x, y), radius, bubblePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}