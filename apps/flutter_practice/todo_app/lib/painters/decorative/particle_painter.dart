import 'dart:math';
import 'package:flutter/material.dart';

class Particle {
  Offset position;
  Offset velocity;
  double size;
  Color color;
  double life;
  double maxLife;

  Particle({
    required this.position,
    required this.velocity,
    required this.size,
    required this.color,
    required this.life,
    required this.maxLife,
  });

  void update() {
    position = Offset(
      position.dx + velocity.dx,
      position.dy + velocity.dy,
    );
    life -= 0.016; // Assuming 60fps
    
    // Add some gravity
    velocity = Offset(
      velocity.dx * 0.99, // Air resistance
      velocity.dy + 0.1,  // Gravity
    );
  }

  bool get isDead => life <= 0;
  
  double get alpha => (life / maxLife).clamp(0.0, 1.0);
}

class ParticlePainter extends CustomPainter {
  final double animationValue;
  final List<Particle> particles = [];
  final Random random = Random();

  ParticlePainter({
    required this.animationValue,
  }) {
    _generateParticles();
  }

  void _generateParticles() {
    particles.clear();
    
    // Generate floating particles
    for (int i = 0; i < 50; i++) {
      particles.add(Particle(
        position: Offset(
          random.nextDouble() * 400,
          random.nextDouble() * 200,
        ),
        velocity: Offset(
          (random.nextDouble() - 0.5) * 2,
          (random.nextDouble() - 0.5) * 2,
        ),
        size: 2 + random.nextDouble() * 4,
        color: _getRandomColor(),
        life: 1.0 + random.nextDouble() * 2,
        maxLife: 1.0 + random.nextDouble() * 2,
      ));
    }

    // Generate trail particles
    for (int i = 0; i < 30; i++) {
      final angle = animationValue * 2 * pi + i * 0.2;
      final radius = 50 + sin(animationValue * 4 * pi + i) * 20;
      
      particles.add(Particle(
        position: Offset(
          200 + cos(angle) * radius,
          100 + sin(angle) * radius,
        ),
        velocity: Offset(
          cos(angle) * 0.5,
          sin(angle) * 0.5,
        ),
        size: 3 + sin(animationValue * 6 * pi + i) * 2,
        color: Colors.white.withOpacity(0.8),
        life: 1.0,
        maxLife: 1.0,
      ));
    }
  }

  Color _getRandomColor() {
    final colors = [
      Colors.blue,
      Colors.purple,
      Colors.pink,
      Colors.cyan,
      Colors.white,
    ];
    return colors[random.nextInt(colors.length)].withOpacity(0.7);
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Update and draw particles
    for (final particle in particles) {
      if (!particle.isDead) {
        // Create glow effect
        final glowPaint = Paint()
          ..color = particle.color.withOpacity(particle.alpha * 0.3)
          ..style = PaintingStyle.fill
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

        canvas.drawCircle(
          particle.position,
          particle.size * 2,
          glowPaint,
        );

        // Draw main particle
        final particlePaint = Paint()
          ..color = particle.color.withOpacity(particle.alpha)
          ..style = PaintingStyle.fill;

        canvas.drawCircle(
          particle.position,
          particle.size,
          particlePaint,
        );
      }
    }

    // Draw connecting lines between nearby particles
    _drawConnections(canvas);

    // Draw central energy source
    _drawEnergySource(canvas, size);
  }

  void _drawConnections(Canvas canvas) {
    final connectionPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int i = 0; i < particles.length; i++) {
      for (int j = i + 1; j < particles.length; j++) {
        final distance = (particles[i].position - particles[j].position).distance;
        
        if (distance < 80 && !particles[i].isDead && !particles[j].isDead) {
          final opacity = (1 - distance / 80) * 0.3;
          connectionPaint.color = Colors.white.withOpacity(opacity);
          
          canvas.drawLine(
            particles[i].position,
            particles[j].position,
            connectionPaint,
          );
        }
      }
    }
  }

  void _drawEnergySource(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Pulsing core
    final coreRadius = 15 + sin(animationValue * 8 * pi) * 5;
    final corePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white,
          Colors.blue.withOpacity(0.8),
          Colors.purple.withOpacity(0.4),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: coreRadius))
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, coreRadius, corePaint);

    // Energy rings
    for (int i = 0; i < 3; i++) {
      final ringRadius = 30 + i * 15 + sin(animationValue * 4 * pi - i) * 8;
      final ringPaint = Paint()
        ..color = Colors.white.withOpacity(0.3 - i * 0.1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawCircle(center, ringRadius, ringPaint);
    }

    // Rotating energy beams
    for (int i = 0; i < 8; i++) {
      final angle = animationValue * 2 * pi + i * pi / 4;
      final beamLength = 40 + sin(animationValue * 6 * pi + i) * 10;
      
      final beamPaint = Paint()
        ..color = Colors.white.withOpacity(0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;

      final startX = center.dx + 20 * cos(angle);
      final startY = center.dy + 20 * sin(angle);
      final endX = center.dx + beamLength * cos(angle);
      final endY = center.dy + beamLength * sin(angle);

      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        beamPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}