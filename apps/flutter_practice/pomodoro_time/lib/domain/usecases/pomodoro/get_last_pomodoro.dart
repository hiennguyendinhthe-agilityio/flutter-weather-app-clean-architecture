import 'package:task_management_app/domain/entities/pomodoro.dart';
import 'package:task_management_app/domain/repositories/pomodoro_repository.dart';

class GetLastPomodoro {
  final PomodoroRepository repository;

  GetLastPomodoro(this.repository);

  Future<Pomodoro?> call() async {
    return await repository.getLastPomodoro();
  }
}
