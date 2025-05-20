// lib/presentation/widgets/settings_tabs/notification_settings_tab.dart
import 'package:flutter/material.dart';
import 'package:task_management_app/data/models/settings.dart';
import 'package:task_management_app/presentation/widgets/section_title.dart';
import 'package:task_management_app/presentation/widgets/slider_setting.dart';
import 'package:task_management_app/presentation/widgets/switch_setting.dart';

class NotificationSettingsTab extends StatelessWidget {
  final Settings settings;
  final Function(Settings) onSettingsChanged;

  const NotificationSettingsTab({
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
          title: 'Notify when Pomodoro ends',
          value: settings.notifyOnPomodoroEnd,
          onChanged: (value) {
            onSettingsChanged(settings.copyWith(notifyOnPomodoroEnd: value));
          },
        ),
        SwitchSetting(
          title: 'Notify when short break ends',
          value: settings.notifyOnBreakEnd,
          onChanged: (value) {
            onSettingsChanged(settings.copyWith(notifyOnBreakEnd: value));
          },
        ),
        const SizedBox(height: 16.0),
        const SectionTitle(title: 'Sound'),
        _buildSoundSelector(),
        const SizedBox(height: 16.0),
        SliderSetting(
          title: 'Sound Volume',
          value: settings.notificationVolume,
          min: 0.0,
          max: 1.0,
          onChanged: (value) {
            onSettingsChanged(settings.copyWith(notificationVolume: value));
          },
        ),
      ],
    );
  }

  Widget _buildSoundSelector() {
    return DropdownButtonFormField<String>(
      value: settings.notificationSound,
      decoration: const InputDecoration(
        labelText: 'Select Notification Sound',
        border: OutlineInputBorder(),
      ),
      items: const [
        DropdownMenuItem(value: 'default', child: Text('Default')),
        DropdownMenuItem(value: 'bell', child: Text('Notification Bell')),
        DropdownMenuItem(value: 'digital', child: Text('Digital Clock')),
        DropdownMenuItem(value: 'gentle', child: Text('Gentle Alarm')),
      ],
      onChanged: (value) {
        if (value != null) {
          onSettingsChanged(settings.copyWith(notificationSound: value));
        }
      },
    );
  }
}
