import 'package:equatable/equatable.dart';

class DailyFitnessData extends Equatable {
  final double activityProgress;
  final double healthProgress;
  final double sleepProgress;

  final int currentSteps;
  final int goalSteps;

  final int bpm;
  final List<double> heartRateDataPoints;

  const DailyFitnessData({
    required this.activityProgress,
    required this.healthProgress,
    required this.sleepProgress,
    required this.currentSteps,
    required this.goalSteps,
    required this.bpm,
    required this.heartRateDataPoints,
  });

  @override
  List<Object?> get props => [
    activityProgress,
    healthProgress,
    sleepProgress,
    currentSteps,
    goalSteps,
    bpm,
    heartRateDataPoints,
  ];
}
