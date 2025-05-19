// lib/presentation/blocs/settings/settings_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/data/datasources/local_data_source.dart';
import 'package:task_management_app/presentation/blocs/settings/setting_event.dart';
import 'package:task_management_app/presentation/blocs/settings/setting_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final LocalDataSourceImpl localDataSource;

  SettingsBloc({required this.localDataSource}) : super(SettingsInitial()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<UpdateSettingsEvent>(_onUpdateSettings);
    on<AddCustomDurationEvent>(_onAddCustomDuration);
    on<RemoveDurationEvent>(_onRemoveDuration);
  }

  Future<void> _onLoadSettings(
      LoadSettingsEvent event, Emitter<SettingsState> emit) async {
    final settings = await localDataSource.getSettings();
    emit(SettingsLoaded(settings));
  }

  Future<void> _onUpdateSettings(
      UpdateSettingsEvent event, Emitter<SettingsState> emit) async {
    await localDataSource.saveSettings(event.settings);
    emit(SettingsLoaded(event.settings));
  }

  Future<void> _onAddCustomDuration(
      AddCustomDurationEvent event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final currentSettings = (state as SettingsLoaded).settings;
      if (!currentSettings.availableDurations.contains(event.duration)) {
        final List<int> newDurations =
            List.from(currentSettings.availableDurations)
              ..add(event.duration)
              ..sort();

        final updatedSettings = currentSettings.copyWith(
          availableDurations: newDurations,
        );

        await localDataSource.saveSettings(updatedSettings);
        emit(SettingsLoaded(updatedSettings));
      }
    }
  }

  Future<void> _onRemoveDuration(
      RemoveDurationEvent event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final currentSettings = (state as SettingsLoaded).settings;
      if (currentSettings.availableDurations.contains(event.duration) &&
          currentSettings.availableDurations.length > 1) {
        final List<int> newDurations =
            List.from(currentSettings.availableDurations)
              ..remove(event.duration);

        final updatedSettings = currentSettings.copyWith(
          availableDurations: newDurations,
        );

        await localDataSource.saveSettings(updatedSettings);
        emit(SettingsLoaded(updatedSettings));
      }
    }
  }
}
