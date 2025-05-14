import 'package:task_management_app/domain/entities/task.dart';

class Pomodoro {
  final int duration; // in minutes
  final int remainingTime; // in seconds
  final bool isRunning;
  final Task? currentTask;

  Pomodoro({
    required this.duration,
    required this.remainingTime,
    required this.isRunning,
    this.currentTask,
  });

  Pomodoro copyWith({
    int? duration,
    int? remainingTime,
    bool? isRunning,
    Task? currentTask,
  }) {
    return Pomodoro(
      duration: duration ?? this.duration,
      remainingTime: remainingTime ?? this.remainingTime,
      isRunning: isRunning ?? this.isRunning,
      currentTask: currentTask ?? this.currentTask,
    );
  }
}
