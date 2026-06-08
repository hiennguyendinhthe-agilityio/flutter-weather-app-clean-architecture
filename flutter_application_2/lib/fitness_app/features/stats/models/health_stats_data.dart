import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class HealthStatsData extends Equatable {
  final double activityProgress;
  final double healthProgress;
  final double sleepProgress;

  final int totalIndex;
  final List<ActivityLevelData> activityLevels;
  final String userName;
  final String motivationalText;

  const HealthStatsData({
    required this.activityProgress,
    required this.healthProgress,
    required this.sleepProgress,
    required this.totalIndex,
    required this.activityLevels,
    required this.userName,
    required this.motivationalText,
  });

  @override
  List<Object?> get props => [
    activityProgress,
    healthProgress,
    sleepProgress,
    totalIndex,
    activityLevels,
    userName,
    motivationalText,
  ];
}

class ActivityLevelData extends Equatable {
  final String name;
  final double percentage;
  final IconData icon;
  final Color color;
  final int durationMinutes;
  final int caloriesBurned;

  const ActivityLevelData({
    required this.name,
    required this.percentage,
    required this.icon,
    required this.color,
    required this.durationMinutes,
    required this.caloriesBurned,
  });

  @override
  List<Object?> get props => [
    name,
    percentage,
    icon.codePoint,
    color.toARGB32(),
    durationMinutes,
    caloriesBurned,
  ];
}
