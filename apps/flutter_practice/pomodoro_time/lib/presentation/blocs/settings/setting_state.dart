// lib/presentation/blocs/settings/settings_state.dart
import 'package:task_management_app/data/models/settings.dart';

abstract class SettingsState {}

class SettingsInitial extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final Settings settings;

  SettingsLoaded(this.settings);
}
