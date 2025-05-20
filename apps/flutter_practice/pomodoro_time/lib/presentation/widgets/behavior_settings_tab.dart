// lib/presentation/widgets/settings_tabs/behavior_settings_tab.dart
import 'package:flutter/material.dart';
import 'package:task_management_app/data/models/settings.dart';
import 'package:task_management_app/presentation/widgets/switch_setting.dart';

class BehaviorSettingsTab extends StatelessWidget {
  final Settings settings;
  final Function(Settings) onSettingsChanged;

  const BehaviorSettingsTab({
    super.key,
    required this.settings,
    required this.onSettingsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        SwitchSetting(
          title: 'Auto start break after Pomodoro ends',
          value: settings.autoStartBreak,
          onChanged: (value) {
            onSettingsChanged(settings.copyWith(autoStartBreak: value));
          },
        ),
        SwitchSetting(
          title: 'Auto start Pomodoro after break ends',
          value: settings.autoStartPomodoro,
          onChanged: (value) {
            onSettingsChanged(settings.copyWith(autoStartPomodoro: value));
          },
        ),
        SwitchSetting(
          title: 'Auto complete task on Pomodoro end',
          value: settings.autoCompleteTaskOnPomodoroEnd,
          onChanged: (value) {
            onSettingsChanged(
              settings.copyWith(autoCompleteTaskOnPomodoroEnd: value),
            );
          },
        ),
      ],
    );
  }
}
