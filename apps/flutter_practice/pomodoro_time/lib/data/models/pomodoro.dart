import 'package:task_management_app/data/models/task.dart';

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

  factory Pomodoro.fromJson(Map<String, dynamic> json) {
    return Pomodoro(
      duration: json['duration'],
      remainingTime: json['remainingTime'],
      isRunning: json['isRunning'],
      currentTask: json['currentTask'] != null
          ? Task.fromJson(json['currentTask'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'duration': duration,
      'remainingTime': remainingTime,
      'isRunning': isRunning,
      'currentTask':
          currentTask != null ? (currentTask as Task).toJson() : null,
    };
  }
}
