// lib/presentation/blocs/settings/settings_event.dart
import 'package:task_management_app/data/models/settings.dart';

abstract class SettingsEvent {}

class LoadSettingsEvent extends SettingsEvent {}

class UpdateSettingsEvent extends SettingsEvent {
  final Settings settings;

  UpdateSettingsEvent(this.settings);
}

class AddCustomDurationEvent extends SettingsEvent {
  final int duration;

  AddCustomDurationEvent(this.duration);
}

class RemoveDurationEvent extends SettingsEvent {
  final int duration;

  RemoveDurationEvent(this.duration);
}
