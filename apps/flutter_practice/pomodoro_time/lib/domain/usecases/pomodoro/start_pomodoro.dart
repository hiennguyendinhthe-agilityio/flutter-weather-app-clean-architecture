import 'package:task_management_app/domain/entities/pomodoro.dart';
import 'package:task_management_app/domain/entities/task.dart';
import 'package:task_management_app/domain/repositories/pomodoro_repository.dart';

class StartPomodoro {
  final PomodoroRepository repository;

  StartPomodoro(this.repository);

  Future<void> call({required int duration, Task? currentTask}) async {
    final pomodoro = Pomodoro(
      duration: duration,
      remainingTime: duration * 60, // Convert to seconds
      isRunning: true,
      currentTask: currentTask,
    );

    await repository.savePomodoro(pomodoro);
  }
}
