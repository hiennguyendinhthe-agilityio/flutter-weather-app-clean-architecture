import 'package:flutter/material.dart';

class WorkoutItem {
  final String id;
  final String title;
  final int durationMinutes;
  final int targetKcal;
  final String level;
  final String category;
  final IconData icon;
  final Color color;

  const WorkoutItem({
    required this.id,
    required this.title,
    required this.durationMinutes,
    required this.targetKcal,
    required this.level,
    required this.category,
    required this.icon,
    required this.color,
  });

  String get durationLabel => '$durationMinutes min';

  String get kcalLabel => '$targetKcal kcal';
}
