// Events
import 'dart:ui';

abstract class SettingsEvent {}

class LoadSettingsEvent extends SettingsEvent {}

class UpdatePomodoroTimeEvent extends SettingsEvent {
  final int minutes;
  UpdatePomodoroTimeEvent(this.minutes);
}

class UpdateShortBreakTimeEvent extends SettingsEvent {
  final int minutes;
  UpdateShortBreakTimeEvent(this.minutes);
}

class UpdateLongBreakTimeEvent extends SettingsEvent {
  final int minutes;
  UpdateLongBreakTimeEvent(this.minutes);
}

class UpdateLongBreakIntervalEvent extends SettingsEvent {
  final int interval;
  UpdateLongBreakIntervalEvent(this.interval);
}

class ToggleAutoStartBreaksEvent extends SettingsEvent {
  final bool enabled;
  ToggleAutoStartBreaksEvent(this.enabled);
}

class ToggleAutoStartPomodorosEvent extends SettingsEvent {
  final bool enabled;
  ToggleAutoStartPomodorosEvent(this.enabled);
}

class ToggleAutoCheckTasksEvent extends SettingsEvent {
  final bool enabled;
  ToggleAutoCheckTasksEvent(this.enabled);
}

class ToggleAutoSwitchTasksEvent extends SettingsEvent {
  final bool enabled;
  ToggleAutoSwitchTasksEvent(this.enabled);
}

class UpdateAlarmSoundEvent extends SettingsEvent {
  final String sound;
  UpdateAlarmSoundEvent(this.sound);
}

class UpdateAlarmVolumeEvent extends SettingsEvent {
  final int volume;
  UpdateAlarmVolumeEvent(this.volume);
}

class UpdateAlarmRepeatEvent extends SettingsEvent {
  final int repeat;
  UpdateAlarmRepeatEvent(this.repeat);
}

class UpdateTickingSoundEvent extends SettingsEvent {
  final String sound;
  UpdateTickingSoundEvent(this.sound);
}

class UpdateTickingVolumeEvent extends SettingsEvent {
  final int volume;
  UpdateTickingVolumeEvent(this.volume);
}

class UpdateThemeColorEvent extends SettingsEvent {
  final Color color;
  UpdateThemeColorEvent(this.color);
}
