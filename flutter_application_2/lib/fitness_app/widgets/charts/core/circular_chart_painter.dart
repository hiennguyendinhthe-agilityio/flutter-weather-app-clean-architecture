import 'package:flutter/material.dart';

class CircularPainterUtils {
  CircularPainterUtils._();

  static List<double> buildRadii({
    required List<double> strokeWidths,
    required double maxRadius,
    required double spacing,
  }) {
    final radii = <double>[];
    double currentOuter = maxRadius;

    for (int i = strokeWidths.length - 1; i >= 0; i--) {
      final sw = strokeWidths[i];
      final radius = currentOuter - (sw / 2);
      radii.insert(0, radius);
      currentOuter = radius - (sw / 2) - spacing;
    }

    return radii;
  }

  static bool listEquals(List<double> a, List<double> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  static double lerp(double a, double b, double t) => a + (b - a) * t;
}

abstract class BaseCircularPainter extends CustomPainter {
  final Animation<double>? entranceAnimation;
  final Listenable? repaintListenable;

  final List<Animation<double>> focusAnimations;

  const BaseCircularPainter({
    this.entranceAnimation,
    this.repaintListenable,
    this.focusAnimations = const [],
  }) : super(repaint: repaintListenable ?? entranceAnimation);

  double get entranceProgress => entranceAnimation?.value ?? 1.0;

  Offset centerOf(Size size) => Offset(size.width / 2, size.height / 2);

  double maxRadiusOf(Size size) => size.width / 2;

  @override
  bool shouldRepaint(covariant BaseCircularPainter oldDelegate) {
    return oldDelegate.entranceAnimation != entranceAnimation ||
        oldDelegate.focusAnimations != focusAnimations;
  }
}
