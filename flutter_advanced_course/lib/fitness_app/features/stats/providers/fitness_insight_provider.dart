import 'package:flutter_advanced_course/fitness_app/features/shared/providers/fitness_provider.dart';
import 'package:flutter_advanced_course/fitness_app/features/shared/providers/selected_date_provider.dart';
import 'package:flutter_advanced_course/fitness_app/features/stats/models/fitness_insight.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fitness_insight_provider.g.dart';

@riverpod
Future<FitnessInsight> fitnessInsight(Ref ref) async {
  final selectedDate = ref.watch(selectedDateProvider);

  // Watch .future of async providers
  final todayData = await ref.watch(dailyFitnessProvider(selectedDate).future);
  final weekData = await ref.watch(currentWeekDataProvider.future);
  final stats = await ref.watch(healthStatsProvider.future);

  // Calculate the average steps of the week
  final totalSteps = weekData.fold<int>(
    0,
    (sum, day) => sum + day.currentSteps,
  );
  final averageSteps = weekData.isNotEmpty ? totalSteps / weekData.length : 0.0;

  final isAboveWeeklyAverage = todayData.currentSteps > averageSteps;

  // Calculate streak (days in the week to complete the number of steps)
  int streak = 0;
  for (final day in weekData) {
    if (day.currentSteps >= day.goalSteps) {
      streak++;
    }
  }

  final motivationalMessage = isAboveWeeklyAverage
      ? 'Today you are more active than last week (${averageSteps.round()} steps)!'
      : 'Keep it up ${stats.userName}, only a little more to reach last week’s average!';

  return FitnessInsight(
    streakDays: streak,
    isAboveWeeklyAverage: isAboveWeeklyAverage,
    motivationalMessage: motivationalMessage,
    weeklyAvgSteps: averageSteps.round(),
  );
}
