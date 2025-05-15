import 'package:task_management_app/data/models/task.dart';

abstract class PomodoroEvent {}

class StartPomodoroEvent extends PomodoroEvent {
  final Task? task;
  StartPomodoroEvent({this.task});
}

class PausePomodoroEvent extends PomodoroEvent {}

class ResumePomodoroEvent extends PomodoroEvent {}

class StopPomodoroEvent extends PomodoroEvent {}

class ResetPomodoroEvent extends PomodoroEvent {}

class SetPomodoroDurationEvent extends PomodoroEvent {
  final int minutes;
  SetPomodoroDurationEvent(this.minutes);
}

class PomodoroTickEvent extends PomodoroEvent {}

class LoadLastPomodoroEvent extends PomodoroEvent {}
