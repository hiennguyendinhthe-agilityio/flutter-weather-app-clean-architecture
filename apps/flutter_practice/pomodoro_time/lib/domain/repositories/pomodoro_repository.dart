// lib/domain/repositories/pomodoro_repository.dart
import 'package:task_management_app/domain/entities/pomodoro.dart';

abstract class PomodoroRepository {
  Future<Pomodoro?> getLastPomodoro();
  Future<void> savePomodoro(Pomodoro pomodoro);
}
