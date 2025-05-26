import 'package:flutter/material.dart';

class ColorCircle extends StatelessWidget {
  final Color color;
  final double size;

  const ColorCircle({
    super.key,
    required this.color,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
