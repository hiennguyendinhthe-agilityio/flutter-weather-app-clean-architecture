// lib/domain/usecases/pomodoro/pause_pomodoro.dart
import 'package:task_management_app/domain/entities/pomodoro.dart';
import 'package:task_management_app/domain/repositories/pomodoro_repository.dart';

class PausePomodoro {
  final PomodoroRepository repository;

  PausePomodoro(this.repository);

  Future<void> call(Pomodoro pomodoro) async {
    final pausedPomodoro = pomodoro.copyWith(isRunning: false);
    await repository.savePomodoro(pausedPomodoro);
  }
}
