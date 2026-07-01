import 'package:flutter_advanced_course/fitness_app/features/workouts/models/workout_filter_state.dart';
import 'package:flutter_advanced_course/fitness_app/features/workouts/models/workout_item.dart';
import 'package:flutter_advanced_course/fitness_app/features/workouts/models/workout_log.dart';
import 'package:flutter_advanced_course/fitness_app/features/workouts/models/workout_summary.dart';
import 'package:flutter_advanced_course/fitness_app/features/workouts/providers/workout_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workout_provider.g.dart';

@riverpod
Future<List<WorkoutItem>> workouts(Ref ref) async {
  final repository = ref.watch(workoutRepositoryProvider);
  return repository.getWorkouts();
}

@riverpod
class WorkoutFilter extends _$WorkoutFilter {
  @override
  WorkoutFilterState build() => const WorkoutFilterState();

  void setQuery(String query) {
    state = state.copyWith(query: query);
  }

  void setLevel(String? level) {
    state = state.copyWith(level: level);
  }

  void clear() {
    state = const WorkoutFilterState();
  }
}

@riverpod
List<WorkoutItem> filteredWorkouts(Ref ref) {
  final workouts = ref
      .watch(workoutsProvider)
      .when(
        data: (items) => items,
        error: (_, _) => const <WorkoutItem>[],
        loading: () => const <WorkoutItem>[],
      );
  final filter = ref.watch(workoutFilterProvider);
  final query = filter.query.trim().toLowerCase();

  return workouts
      .where((workout) {
        final matchesQuery =
            query.isEmpty ||
            workout.title.toLowerCase().contains(query) ||
            workout.category.toLowerCase().contains(query);
        final matchesLevel =
            filter.level == null || workout.level == filter.level;

        return matchesQuery && matchesLevel;
      })
      .toList(growable: false);
}

@riverpod
class WorkoutHistory extends _$WorkoutHistory {
  @override
  List<WorkoutLog> build() => const [];

  void addLog(WorkoutLog log) {
    state = [log, ...state];
  }

  void clear() {
    state = const [];
  }
}

@riverpod
WorkoutSummary workoutSummary(Ref ref) {
  final history = ref.watch(workoutHistoryProvider);
  final now = DateTime.now();
  final startOfToday = DateTime(now.year, now.month, now.day);
  final startOfWeek = startOfToday.subtract(Duration(days: now.weekday - 1));

  final todayLogs = history.where((log) {
    final completedDay = DateTime(
      log.completedAt.year,
      log.completedAt.month,
      log.completedAt.day,
    );
    return completedDay == startOfToday;
  }).toList();

  final weeklyCompleted = history.where((log) {
    return !log.completedAt.isBefore(startOfWeek);
  }).length;

  return WorkoutSummary(
    totalKcal: todayLogs.fold(0, (sum, log) => sum + log.caloriesBurned),
    completedToday: todayLogs.length,
    weeklyCompleted: weeklyCompleted,
    weeklyGoal: 5,
  );
}
