// lib/domain/usecases/pomodoro/stop_pomodoro.dart
import 'package:task_management_app/domain/entities/pomodoro.dart';
import 'package:task_management_app/domain/repositories/pomodoro_repository.dart';

class StopPomodoro {
  final PomodoroRepository repository;

  StopPomodoro(this.repository);

  Future<void> call(Pomodoro pomodoro) async {
    // When stopping, we save the pomodoro with isRunning set to false
    // and optionally could add a "completed" flag if needed
    final stoppedPomodoro = pomodoro.copyWith(
      isRunning: false,
      remainingTime: 0, // Reset remaining time
    );

    await repository.savePomodoro(stoppedPomodoro);
  }
}
