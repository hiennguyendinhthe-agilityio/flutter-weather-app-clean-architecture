import 'package:flutter_application_2/fitness_app/features/stats/models/health_stats_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/daily_fitness_data.dart';
import 'fitness_repository_provider.dart';

part 'fitness_provider.g.dart';

@riverpod
Future<DailyFitnessData> dailyFitness(Ref ref, DateTime date) async {
  final repository = ref.watch(fitnessRepositoryProvider);
  return repository.getDailyData(date);
}

@riverpod
Future<HealthStatsData> healthStats(Ref ref) async {
  final repository = ref.watch(fitnessRepositoryProvider);
  return repository.getHealthStats();
}

@riverpod
Future<List<DailyFitnessData>> currentWeekData(Ref ref) async {
  final repository = ref.watch(fitnessRepositoryProvider);
  return repository.getWeekData();
}
