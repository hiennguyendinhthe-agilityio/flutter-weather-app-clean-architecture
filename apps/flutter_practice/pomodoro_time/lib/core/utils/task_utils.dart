import 'package:flutter/material.dart';

Color getColorFromName(String colorName) {
  switch (colorName) {
    case 'red':
      return const Color(0xFFF87171);
    case 'orange':
      return const Color(0xFFF97316);
    case 'yellow':
      return const Color(0xFFFBBF24);
    case 'green':
      return const Color(0xFF34D399);
    case 'blue':
      return const Color(0xFF60A5FA);
    case 'indigo':
      return const Color(0xFF818CF8);
    case 'purple':
      return const Color(0xFF8B5CF6);
    case 'pink':
      return const Color(0xFFEC4899);
    default:
      return Colors.grey; // Default color if no match found
  }
}

String formatDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);

  return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
}
