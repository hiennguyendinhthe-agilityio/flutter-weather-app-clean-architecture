import 'package:task_management_app/data/models/task_model.dart';
import 'package:task_management_app/domain/entities/pomodoro.dart';
import 'package:task_management_app/domain/entities/task.dart';

class PomodoroModel extends Pomodoro {
  PomodoroModel({
    required int duration,
    required int remainingTime,
    required bool isRunning,
    Task? currentTask,
  }) : super(
          duration: duration,
          remainingTime: remainingTime,
          isRunning: isRunning,
          currentTask: currentTask,
        );

  factory PomodoroModel.fromJson(Map<String, dynamic> json) {
    return PomodoroModel(
      duration: json['duration'],
      remainingTime: json['remainingTime'],
      isRunning: json['isRunning'],
      currentTask: json['currentTask'] != null
          ? TaskModel.fromJson(json['currentTask'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'duration': duration,
      'remainingTime': remainingTime,
      'isRunning': isRunning,
      'currentTask':
          currentTask != null ? (currentTask as TaskModel).toJson() : null,
    };
  }

  factory PomodoroModel.fromEntity(Pomodoro pomodoro) {
    return PomodoroModel(
      duration: pomodoro.duration,
      remainingTime: pomodoro.remainingTime,
      isRunning: pomodoro.isRunning,
      currentTask: pomodoro.currentTask != null
          ? TaskModel.fromEntity(pomodoro.currentTask!)
          : null,
    );
  }
}
