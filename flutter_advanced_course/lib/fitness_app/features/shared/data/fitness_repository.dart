import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/fitness_app/features/shared/models/daily_fitness_data.dart';
import 'package:flutter_advanced_course/fitness_app/features/stats/models/health_stats_data.dart';

class FitnessRepository {
  FitnessRepository();

  Future<List<DailyFitnessData>> getWeekData() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return getCurrentWeekData();
  }

  Future<HealthStatsData> getHealthStats() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return getCurrentHealthStats();
  }

  Future<DailyFitnessData> getDailyData(DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final weekData = getCurrentWeekData();
    final dayIndex = date.weekday - 1;
    return weekData[dayIndex % weekData.length];
  }

  static List<DailyFitnessData> getCurrentWeekData() {
    return const [
      DailyFitnessData(
        activityProgress: 0.45,
        healthProgress: 0.70,
        sleepProgress: 0.90,
        currentSteps: 8500,
        goalSteps: 10000,
        bpm: 95,
        heartRateDataPoints: [0.4, 0.7, 0.9, 0.7, 1.0, 0.5, 0.6],
      ),
      DailyFitnessData(
        activityProgress: 0.15,
        healthProgress: 0.30,
        sleepProgress: 0.95,
        currentSteps: 3200,
        goalSteps: 10000,
        bpm: 65,
        heartRateDataPoints: [0.2, 0.3, 0.2, 0.4, 0.3, 0.2, 0.3],
      ),
      DailyFitnessData(
        activityProgress: 0.50,
        healthProgress: 0.55,
        sleepProgress: 0.75,
        currentSteps: 7000,
        goalSteps: 10000,
        bpm: 88,
        heartRateDataPoints: [0.6, 0.5, 0.8, 0.7, 0.6, 0.9, 0.5],
      ),
      DailyFitnessData(
        activityProgress: 0.35,
        healthProgress: 0.60,
        sleepProgress: 0.80,
        currentSteps: 6500,
        goalSteps: 10000,
        bpm: 82,
        heartRateDataPoints: [
          0.3,
          0.6,
          0.8,
          0.4,
          0.7,
          0.9,
          0.5,
          1.0,
          0.8,
          0.5,
          0.7,
          0.4,
          0.6,
          0.3,
        ],
      ),
      DailyFitnessData(
        activityProgress: 0.85,
        healthProgress: 0.90,
        sleepProgress: 0.60,
        currentSteps: 12500,
        goalSteps: 10000,
        bpm: 110,
        heartRateDataPoints: [1.0, 0.9, 1.0, 0.8, 0.9, 1.0, 0.7],
      ),
      DailyFitnessData(
        activityProgress: 0.60,
        healthProgress: 0.80,
        sleepProgress: 0.50,
        currentSteps: 9800,
        goalSteps: 10000,
        bpm: 85,
        heartRateDataPoints: [0.5, 0.6, 0.7, 0.5, 0.8, 0.6, 0.7],
      ),
      DailyFitnessData(
        activityProgress: 0.20,
        healthProgress: 0.50,
        sleepProgress: 1.0,
        currentSteps: 4100,
        goalSteps: 10000,
        bpm: 60,
        heartRateDataPoints: [0.1, 0.2, 0.1, 0.3, 0.2, 0.1, 0.2],
      ),
    ];
  }

  static HealthStatsData getCurrentHealthStats() {
    return const HealthStatsData(
      activityProgress: 0.74,
      healthProgress: 0.52,
      sleepProgress: 0.56,
      totalIndex: 64,
      userName: 'Alex',
      motivationalText: 'Alex keep it up!',
      activityLevels: [
        ActivityLevelData(
          name: 'Cycling',
          percentage: 48,
          icon: Icons.directions_bike_rounded,
          color: Color(0xFFCBFF3E),
          durationMinutes: 84,
          caloriesBurned: 420,
        ),
        ActivityLevelData(
          name: 'Running',
          percentage: 72,
          icon: Icons.directions_run_rounded,
          color: Color(0xFF1DE5C2),
          durationMinutes: 45,
          caloriesBurned: 580,
        ),
        ActivityLevelData(
          name: 'Swimming',
          percentage: 35,
          icon: Icons.pool_rounded,
          color: Color(0xFF5A94FF),
          durationMinutes: 30,
          caloriesBurned: 350,
        ),
        ActivityLevelData(
          name: 'Walking',
          percentage: 88,
          icon: Icons.directions_walk_rounded,
          color: Color(0xFF8B6AFF),
          durationMinutes: 120,
          caloriesBurned: 280,
        ),
        ActivityLevelData(
          name: 'Yoga',
          percentage: 61,
          icon: Icons.self_improvement_rounded,
          color: Color(0xFFFFB347),
          durationMinutes: 60,
          caloriesBurned: 150,
        ),
      ],
    );
  }
}
