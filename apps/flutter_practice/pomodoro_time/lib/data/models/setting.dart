import 'package:flutter/material.dart';

class PomodoroSettings {
  // Timer settings
  final int pomodoroTime; // minutes
  final int shortBreakTime; // minutes
  final int longBreakTime; // minutes
  final int longBreakInterval; // after how many pomodoros
  final bool autoStartBreaks;
  final bool autoStartPomodoros;

  // Task settings
  final bool autoCheckTasks;
  final bool autoSwitchTasks;

  // Sound settings
  final String alarmSound; // 'Digital', 'Bell', etc.
  final int alarmVolume; // 0-100
  final int alarmRepeat; // number of repeats
  final String tickingSound; // 'None', 'Ticking', 'White Noise', etc.
  final int tickingVolume; // 0-100

  // Theme settings - added for our color theme feature
  final Color themeColor;

  const PomodoroSettings({
    this.pomodoroTime = 25,
    this.shortBreakTime = 5,
    this.longBreakTime = 15,
    this.longBreakInterval = 4,
    this.autoStartBreaks = false,
    this.autoStartPomodoros = false,
    this.autoCheckTasks = false,
    this.autoSwitchTasks = false,
    this.alarmSound = 'Digital',
    this.alarmVolume = 50,
    this.alarmRepeat = 1,
    this.tickingSound = 'None',
    this.tickingVolume = 50,
    this.themeColor = const Color(0xFF2196F3), // Default blue
  });

  PomodoroSettings copyWith({
    int? pomodoroTime,
    int? shortBreakTime,
    int? longBreakTime,
    int? longBreakInterval,
    bool? autoStartBreaks,
    bool? autoStartPomodoros,
    bool? autoCheckTasks,
    bool? autoSwitchTasks,
    String? alarmSound,
    int? alarmVolume,
    int? alarmRepeat,
    String? tickingSound,
    int? tickingVolume,
    Color? themeColor,
  }) {
    return PomodoroSettings(
      pomodoroTime: pomodoroTime ?? this.pomodoroTime,
      shortBreakTime: shortBreakTime ?? this.shortBreakTime,
      longBreakTime: longBreakTime ?? this.longBreakTime,
      longBreakInterval: longBreakInterval ?? this.longBreakInterval,
      autoStartBreaks: autoStartBreaks ?? this.autoStartBreaks,
      autoStartPomodoros: autoStartPomodoros ?? this.autoStartPomodoros,
      autoCheckTasks: autoCheckTasks ?? this.autoCheckTasks,
      autoSwitchTasks: autoSwitchTasks ?? this.autoSwitchTasks,
      alarmSound: alarmSound ?? this.alarmSound,
      alarmVolume: alarmVolume ?? this.alarmVolume,
      alarmRepeat: alarmRepeat ?? this.alarmRepeat,
      tickingSound: tickingSound ?? this.tickingSound,
      tickingVolume: tickingVolume ?? this.tickingVolume,
      themeColor: themeColor ?? this.themeColor,
    );
  }
}
