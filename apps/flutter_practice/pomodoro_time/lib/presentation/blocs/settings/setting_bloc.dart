import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/data/datasources/local_data_source.dart';
import 'package:task_management_app/data/models/setting.dart';
import 'package:task_management_app/presentation/blocs/settings/setting_event.dart';
import 'package:task_management_app/presentation/blocs/settings/setting_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final LocalDataSourceImpl localDataSource;

  SettingsBloc({required this.localDataSource}) : super(SettingsInitial()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<UpdatePomodoroTimeEvent>(_onUpdatePomodoroTime);
    on<UpdateShortBreakTimeEvent>(_onUpdateShortBreakTime);
    on<UpdateLongBreakTimeEvent>(_onUpdateLongBreakTime);
    on<UpdateLongBreakIntervalEvent>(_onUpdateLongBreakInterval);
    on<ToggleAutoStartBreaksEvent>(_onToggleAutoStartBreaks);
    on<ToggleAutoStartPomodorosEvent>(_onToggleAutoStartPomodoros);
    on<ToggleAutoCheckTasksEvent>(_onToggleAutoCheckTasks);
    on<ToggleAutoSwitchTasksEvent>(_onToggleAutoSwitchTasks);
    on<UpdateAlarmSoundEvent>(_onUpdateAlarmSound);
    on<UpdateAlarmVolumeEvent>(_onUpdateAlarmVolume);
    on<UpdateAlarmRepeatEvent>(_onUpdateAlarmRepeat);
    on<UpdateTickingSoundEvent>(_onUpdateTickingSound);
    on<UpdateTickingVolumeEvent>(_onUpdateTickingVolume);
    on<UpdateThemeColorEvent>(_onUpdateThemeColor);
  }

  Future<void> _onLoadSettings(
      LoadSettingsEvent event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    try {
      final settings = await localDataSource.getSettings();
      emit(SettingsLoaded(settings ?? const PomodoroSettings()));
    } catch (e) {
      emit(SettingsError('Failed to load settings: $e'));
    }
  }

  Future<void> _updateSettings(
      PomodoroSettings settings, Emitter<SettingsState> emit) async {
    try {
      await localDataSource.saveSettings(settings);
      emit(SettingsLoaded(settings));
    } catch (e) {
      emit(SettingsError('Failed to update settings: $e'));
    }
  }

  Future<void> _onUpdatePomodoroTime(
      UpdatePomodoroTimeEvent event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final currentSettings = (state as SettingsLoaded).settings;
      final updatedSettings = currentSettings.copyWith(
        pomodoroTime: event.minutes,
      );
      await _updateSettings(updatedSettings, emit);
    }
  }

  Future<void> _onUpdateShortBreakTime(
      UpdateShortBreakTimeEvent event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final currentSettings = (state as SettingsLoaded).settings;
      final updatedSettings = currentSettings.copyWith(
        shortBreakTime: event.minutes,
      );
      await _updateSettings(updatedSettings, emit);
    }
  }

  Future<void> _onUpdateLongBreakTime(
      UpdateLongBreakTimeEvent event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final currentSettings = (state as SettingsLoaded).settings;
      final updatedSettings = currentSettings.copyWith(
        longBreakTime: event.minutes,
      );
      await _updateSettings(updatedSettings, emit);
    }
  }

  Future<void> _onUpdateLongBreakInterval(
      UpdateLongBreakIntervalEvent event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final currentSettings = (state as SettingsLoaded).settings;
      final updatedSettings = currentSettings.copyWith(
        longBreakInterval: event.interval,
      );
      await _updateSettings(updatedSettings, emit);
    }
  }

  Future<void> _onToggleAutoStartBreaks(
      ToggleAutoStartBreaksEvent event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final currentSettings = (state as SettingsLoaded).settings;
      final updatedSettings = currentSettings.copyWith(
        autoStartBreaks: event.enabled,
      );
      await _updateSettings(updatedSettings, emit);
    }
  }

  Future<void> _onToggleAutoStartPomodoros(
      ToggleAutoStartPomodorosEvent event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final currentSettings = (state as SettingsLoaded).settings;
      final updatedSettings = currentSettings.copyWith(
        autoStartPomodoros: event.enabled,
      );
      await _updateSettings(updatedSettings, emit);
    }
  }

  Future<void> _onToggleAutoCheckTasks(
      ToggleAutoCheckTasksEvent event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final currentSettings = (state as SettingsLoaded).settings;
      final updatedSettings = currentSettings.copyWith(
        autoCheckTasks: event.enabled,
      );
      await _updateSettings(updatedSettings, emit);
    }
  }

  Future<void> _onToggleAutoSwitchTasks(
      ToggleAutoSwitchTasksEvent event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final currentSettings = (state as SettingsLoaded).settings;
      final updatedSettings = currentSettings.copyWith(
        autoSwitchTasks: event.enabled,
      );
      await _updateSettings(updatedSettings, emit);
    }
  }

  Future<void> _onUpdateAlarmSound(
      UpdateAlarmSoundEvent event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final currentSettings = (state as SettingsLoaded).settings;
      final updatedSettings = currentSettings.copyWith(
        alarmSound: event.sound,
      );
      await _updateSettings(updatedSettings, emit);
    }
  }

  Future<void> _onUpdateAlarmVolume(
      UpdateAlarmVolumeEvent event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final currentSettings = (state as SettingsLoaded).settings;
      final updatedSettings = currentSettings.copyWith(
        alarmVolume: event.volume,
      );
      await _updateSettings(updatedSettings, emit);
    }
  }

  Future<void> _onUpdateAlarmRepeat(
      UpdateAlarmRepeatEvent event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final currentSettings = (state as SettingsLoaded).settings;
      final updatedSettings = currentSettings.copyWith(
        alarmRepeat: event.repeat,
      );
      await _updateSettings(updatedSettings, emit);
    }
  }

  Future<void> _onUpdateTickingSound(
      UpdateTickingSoundEvent event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final currentSettings = (state as SettingsLoaded).settings;
      final updatedSettings = currentSettings.copyWith(
        tickingSound: event.sound,
      );
      await _updateSettings(updatedSettings, emit);
    }
  }

  Future<void> _onUpdateTickingVolume(
      UpdateTickingVolumeEvent event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final currentSettings = (state as SettingsLoaded).settings;
      final updatedSettings = currentSettings.copyWith(
        tickingVolume: event.volume,
      );
      await _updateSettings(updatedSettings, emit);
    }
  }

  Future<void> _onUpdateThemeColor(
      UpdateThemeColorEvent event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final currentSettings = (state as SettingsLoaded).settings;
      final updatedSettings = currentSettings.copyWith(
        themeColor: event.color,
      );
      await _updateSettings(updatedSettings, emit);
    }
  }
}
