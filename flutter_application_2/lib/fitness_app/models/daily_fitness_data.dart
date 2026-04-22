class DailyFitnessData {
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
}
