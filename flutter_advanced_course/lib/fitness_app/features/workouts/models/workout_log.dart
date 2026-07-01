import 'package:flutter_advanced_course/fitness_app/features/workouts/models/workout_item.dart';

class WorkoutLog {
  final String id;
  final String workoutId;
  final String workoutTitle;
  final DateTime completedAt;
  final int durationMinutes;
  final int caloriesBurned;

  const WorkoutLog({
    required this.id,
    required this.workoutId,
    required this.workoutTitle,
    required this.completedAt,
    required this.durationMinutes,
    required this.caloriesBurned,
  });

  factory WorkoutLog.fromWorkout({
    required WorkoutItem workout,
    required DateTime completedAt,
    required Duration elapsed,
  }) {
    final completedMinutes = elapsed.inMinutes.clamp(
      1,
      workout.durationMinutes,
    );
    final calorieRatio = completedMinutes / workout.durationMinutes;

    return WorkoutLog(
      id: '${workout.id}-${completedAt.microsecondsSinceEpoch}',
      workoutId: workout.id,
      workoutTitle: workout.title,
      completedAt: completedAt,
      durationMinutes: completedMinutes,
      caloriesBurned: (workout.targetKcal * calorieRatio).round().clamp(
        1,
        workout.targetKcal,
      ),
    );
  }
}
