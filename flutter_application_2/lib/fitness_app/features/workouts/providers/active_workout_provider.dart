import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/active_workout_state.dart';
import '../models/workout_item.dart';
import '../models/workout_log.dart';
import 'workout_provider.dart';

part 'active_workout_provider.g.dart';

@riverpod
class ActiveWorkout extends _$ActiveWorkout {
  Timer? _timer;

  @override
  ActiveWorkoutState build() {
    ref.onDispose(_stopTimer);
    return const ActiveWorkoutState.idle();
  }

  void start(WorkoutItem workout) {
    _stopTimer();
    state = ActiveWorkoutState(
      workout: workout,
      elapsed: Duration.zero,
      isRunning: true,
    );
    _startTimer();
  }

  void pause() {
    if (!state.hasWorkout) {
      return;
    }

    _stopTimer();
    state = state.copyWith(isRunning: false);
  }

  void resume() {
    if (!state.hasWorkout || state.isRunning) {
      return;
    }

    state = state.copyWith(isRunning: true);
    _startTimer();
  }

  void cancel() {
    _stopTimer();
    state = const ActiveWorkoutState.idle();
  }

  void complete() {
    final workout = state.workout;
    if (workout == null) {
      return;
    }

    final completedAt = DateTime.now();
    final elapsed = state.elapsed == Duration.zero
        ? Duration(minutes: workout.durationMinutes)
        : state.elapsed;

    ref
        .read(workoutHistoryProvider.notifier)
        .addLog(
          WorkoutLog.fromWorkout(
            workout: workout,
            completedAt: completedAt,
            elapsed: elapsed,
          ),
        );

    cancel();
  }

  void _startTimer() {
    _timer ??= Timer.periodic(const Duration(seconds: 1), (_) {
      final workout = state.workout;
      if (workout == null || !state.isRunning) {
        return;
      }

      final nextElapsed = state.elapsed + const Duration(seconds: 1);
      final totalDuration = Duration(minutes: workout.durationMinutes);

      if (nextElapsed >= totalDuration) {
        state = state.copyWith(elapsed: totalDuration);
        complete();
        return;
      }

      state = state.copyWith(elapsed: nextElapsed);
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }
}
