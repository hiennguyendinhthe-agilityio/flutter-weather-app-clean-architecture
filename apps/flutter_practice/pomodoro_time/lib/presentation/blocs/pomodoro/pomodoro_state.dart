import 'package:task_management_app/domain/entities/pomodoro.dart';

abstract class PomodoroState {}

class PomodoroInitial extends PomodoroState {}

class PomodoroRunning extends PomodoroState {
  final Pomodoro pomodoro;
  PomodoroRunning(this.pomodoro);
}

class PomodoroPaused extends PomodoroState {
  final Pomodoro pomodoro;
  PomodoroPaused(this.pomodoro);
}

class PomodoroCompleted extends PomodoroState {
  final Pomodoro pomodoro;
  PomodoroCompleted(this.pomodoro);
}
