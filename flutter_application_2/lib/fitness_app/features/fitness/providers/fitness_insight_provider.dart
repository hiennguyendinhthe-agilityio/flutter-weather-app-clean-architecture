import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/fitness_insight.dart';
import 'fitness_provider.dart';
import 'selected_date_provider.dart';

part 'fitness_insight_provider.g.dart';

@riverpod
Future<FitnessInsight> fitnessInsight(Ref ref) async {
  final selectedDate = ref.watch(selectedDateProvider);
  
  // Watch .future của các async providers
  final todayData = await ref.watch(dailyFitnessProvider(selectedDate).future);
  final weekData = await ref.watch(currentWeekDataProvider.future);
  final stats = await ref.watch(healthStatsProvider.future);

  // Tính số bước chân trung bình tuần
  final totalSteps = weekData.fold<int>(0, (sum, day) => sum + day.currentSteps);
  final averageSteps = weekData.isNotEmpty ? totalSteps / weekData.length : 0.0;
  
  final isAboveWeeklyAverage = todayData.currentSteps > averageSteps;

  // Tính streak (các ngày trong tuần hoàn thành mục tiêu số bước)
  int streak = 0;
  for (final day in weekData) {
    if (day.currentSteps >= day.goalSteps) {
      streak++;
    }
  }

  final motivationalMessage = isAboveWeeklyAverage
      ? 'Hôm nay bạn hoạt động năng nổ hơn mức trung bình tuần (${averageSteps.round()} bước)!'
      : 'Cố lên nào ${stats.userName}, chỉ còn một chút nữa là đạt mức trung bình tuần!';

  return FitnessInsight(
    streakDays: streak,
    isAboveWeeklyAverage: isAboveWeeklyAverage,
    motivationalMessage: motivationalMessage,
    weeklyAvgSteps: averageSteps.round(),
  );
}
