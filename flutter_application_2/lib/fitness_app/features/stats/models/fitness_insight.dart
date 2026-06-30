import 'package:equatable/equatable.dart';

class FitnessInsight extends Equatable {
  final int streakDays;
  final bool isAboveWeeklyAverage;
  final String motivationalMessage;
  final int weeklyAvgSteps;

  const FitnessInsight({
    required this.streakDays,
    required this.isAboveWeeklyAverage,
    required this.motivationalMessage,
    required this.weeklyAvgSteps,
  });

  @override
  List<Object?> get props => [
    streakDays,
    isAboveWeeklyAverage,
    motivationalMessage,
    weeklyAvgSteps,
  ];
}
