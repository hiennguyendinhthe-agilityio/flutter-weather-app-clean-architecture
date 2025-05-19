// lib/data/models/settings.dart
class Settings {
  // Time settings
  final List<int> availableDurations;
  final int shortBreakDuration;
  final int longBreakDuration;
  final int pomodorosUntilLongBreak;

  // Notification and sound settings
  final bool notifyOnPomodoroEnd;
  final bool notifyOnBreakEnd;
  final String notificationSound;
  final double notificationVolume;

  // UI settings
  final bool darkMode;
  final bool customColors;

  // App behavior
  final bool autoStartBreak;
  final bool autoStartPomodoro;
  final bool autoCompleteTaskOnPomodoroEnd;

  const Settings({
    this.availableDurations = const [5, 10, 20, 25, 30],
    this.shortBreakDuration = 5,
    this.longBreakDuration = 15,
    this.pomodorosUntilLongBreak = 4,
    this.notifyOnPomodoroEnd = true,
    this.notifyOnBreakEnd = true,
    this.notificationSound = 'default',
    this.notificationVolume = 0.7,
    this.darkMode = false,
    this.customColors = true,
    this.autoStartBreak = false,
    this.autoStartPomodoro = false,
    this.autoCompleteTaskOnPomodoroEnd = false,
  });

  Settings copyWith({
    List<int>? availableDurations,
    int? shortBreakDuration,
    int? longBreakDuration,
    int? pomodorosUntilLongBreak,
    bool? notifyOnPomodoroEnd,
    bool? notifyOnBreakEnd,
    String? notificationSound,
    double? notificationVolume,
    bool? darkMode,
    bool? customColors,
    bool? autoStartBreak,
    bool? autoStartPomodoro,
    bool? autoCompleteTaskOnPomodoroEnd,
  }) {
    return Settings(
      availableDurations: availableDurations ?? this.availableDurations,
      shortBreakDuration: shortBreakDuration ?? this.shortBreakDuration,
      longBreakDuration: longBreakDuration ?? this.longBreakDuration,
      pomodorosUntilLongBreak:
          pomodorosUntilLongBreak ?? this.pomodorosUntilLongBreak,
      notifyOnPomodoroEnd: notifyOnPomodoroEnd ?? this.notifyOnPomodoroEnd,
      notifyOnBreakEnd: notifyOnBreakEnd ?? this.notifyOnBreakEnd,
      notificationSound: notificationSound ?? this.notificationSound,
      notificationVolume: notificationVolume ?? this.notificationVolume,
      darkMode: darkMode ?? this.darkMode,
      customColors: customColors ?? this.customColors,
      autoStartBreak: autoStartBreak ?? this.autoStartBreak,
      autoStartPomodoro: autoStartPomodoro ?? this.autoStartPomodoro,
      autoCompleteTaskOnPomodoroEnd:
          autoCompleteTaskOnPomodoroEnd ?? this.autoCompleteTaskOnPomodoroEnd,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'availableDurations': availableDurations,
      'shortBreakDuration': shortBreakDuration,
      'longBreakDuration': longBreakDuration,
      'pomodorosUntilLongBreak': pomodorosUntilLongBreak,
      'notifyOnPomodoroEnd': notifyOnPomodoroEnd,
      'notifyOnBreakEnd': notifyOnBreakEnd,
      'notificationSound': notificationSound,
      'notificationVolume': notificationVolume,
      'darkMode': darkMode,
      'customColors': customColors,
      'autoStartBreak': autoStartBreak,
      'autoStartPomodoro': autoStartPomodoro,
      'autoCompleteTaskOnPomodoroEnd': autoCompleteTaskOnPomodoroEnd,
    };
  }

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      availableDurations:
          List<int>.from(json['availableDurations'] ?? [5, 10, 20, 25, 30]),
      shortBreakDuration: json['shortBreakDuration'] ?? 5,
      longBreakDuration: json['longBreakDuration'] ?? 15,
      pomodorosUntilLongBreak: json['pomodorosUntilLongBreak'] ?? 4,
      notifyOnPomodoroEnd: json['notifyOnPomodoroEnd'] ?? true,
      notifyOnBreakEnd: json['notifyOnBreakEnd'] ?? true,
      notificationSound: json['notificationSound'] ?? 'default',
      notificationVolume: json['notificationVolume']?.toDouble() ?? 0.7,
      darkMode: json['darkMode'] ?? false,
      customColors: json['customColors'] ?? true,
      autoStartBreak: json['autoStartBreak'] ?? false,
      autoStartPomodoro: json['autoStartPomodoro'] ?? false,
      autoCompleteTaskOnPomodoroEnd:
          json['autoCompleteTaskOnPomodoroEnd'] ?? false,
    );
  }
}
