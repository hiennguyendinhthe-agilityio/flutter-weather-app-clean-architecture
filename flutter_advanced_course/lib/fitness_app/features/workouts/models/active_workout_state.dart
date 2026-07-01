import 'package:flutter_advanced_course/fitness_app/features/workouts/models/workout_item.dart';

class ActiveWorkoutState {
  final WorkoutItem? workout;
  final Duration elapsed;
  final bool isRunning;

  const ActiveWorkoutState({
    required this.workout,
    required this.elapsed,
    required this.isRunning,
  });

  const ActiveWorkoutState.idle()
    : workout = null,
      elapsed = Duration.zero,
      isRunning = false;

  bool get hasWorkout => workout != null;

  bool get isPaused => hasWorkout && !isRunning;

  double get progress {
    final currentWorkout = workout;
    if (currentWorkout == null) {
      return 0;
    }

    final totalSeconds = currentWorkout.durationMinutes * 60;
    if (totalSeconds <= 0) {
      return 0;
    }

    return (elapsed.inSeconds / totalSeconds).clamp(0.0, 1.0);
  }

  int get estimatedCalories {
    final currentWorkout = workout;
    if (currentWorkout == null) {
      return 0;
    }

    return (currentWorkout.targetKcal * progress).round();
  }

  ActiveWorkoutState copyWith({
    WorkoutItem? workout,
    Duration? elapsed,
    bool? isRunning,
  }) {
    return ActiveWorkoutState(
      workout: workout ?? this.workout,
      elapsed: elapsed ?? this.elapsed,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}
