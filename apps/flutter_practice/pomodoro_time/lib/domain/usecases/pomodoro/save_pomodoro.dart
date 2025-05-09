// lib/domain/usecases/pomodoro/save_pomodoro.dart
import 'package:task_management_app/domain/entities/pomodoro.dart';
import 'package:task_management_app/domain/repositories/pomodoro_repository.dart';

class SavePomodoro {
  final PomodoroRepository repository;

  SavePomodoro(this.repository);

  Future<void> call(Pomodoro pomodoro) async {
    await repository.savePomodoro(pomodoro);
  }
}
