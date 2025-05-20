// lib/presentation/widgets/settings_tabs/ui_settings_tab.dart
import 'package:flutter/material.dart';
import 'package:task_management_app/core/themes/pomodoro_color_theme.dart';
import 'package:task_management_app/data/models/settings.dart';
import 'package:task_management_app/presentation/widgets/color_circle.dart';
import 'package:task_management_app/presentation/widgets/section_title.dart';
import 'package:task_management_app/presentation/widgets/switch_setting.dart';

class UISettingsTab extends StatelessWidget {
  final Settings settings;
  final Function(Settings) onSettingsChanged;

  const UISettingsTab({
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
          title: 'Dark mode',
          value: settings.darkMode,
          onChanged: (value) {
            onSettingsChanged(settings.copyWith(darkMode: value));
          },
        ),
        SwitchSetting(
          title: 'Custom colors',
          value: settings.customColors,
          onChanged: (value) {
            onSettingsChanged(settings.copyWith(customColors: value));
          },
        ),
        const SizedBox(height: 16.0),
        const SectionTitle(title: 'Color Theme'),
        _buildColorPreview(),
      ],
    );
  }

  Widget _buildColorPreview() {
    return Column(
      children: [
        ...settings.availableDurations.map((duration) {
          final themeColors = PomodoroColorTheme.getThemeColors(duration);
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: themeColors.background,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                ColorCircle(color: themeColors.primary),
                const SizedBox(width: 8.0),
                ColorCircle(color: themeColors.secondary),
                const SizedBox(width: 16.0),
                Text(
                  '$duration phút',
                  style: TextStyle(
                    color: themeColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}
