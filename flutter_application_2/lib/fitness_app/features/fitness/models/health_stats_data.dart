import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

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

  const ActivityLevelData({
    required this.name,
    required this.percentage,
    required this.icon,
    required this.color,
  });

  @override
  List<Object?> get props => [name, percentage, icon.codePoint, color.toARGB32()];
}
