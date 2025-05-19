// lib/presentation/widgets/settings_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/core/themes/pomodoro_color_theme.dart';
import 'package:task_management_app/data/models/settings.dart';
import 'package:task_management_app/presentation/blocs/settings/setting_bloc.dart';
import 'package:task_management_app/presentation/blocs/settings/setting_event.dart';
import 'package:task_management_app/presentation/blocs/settings/setting_state.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _customDurationController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _customDurationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state is SettingsLoaded) {
          final settings = state.settings;
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 500.0,
                maxHeight: 600.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(),
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(icon: Icon(Icons.timer), text: 'Timers'),
                      Tab(
                          icon: Icon(Icons.notifications),
                          text: 'Notifications'),
                      Tab(icon: Icon(Icons.palette), text: 'Theme'),
                      Tab(icon: Icon(Icons.settings), text: 'Behavior'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildTimeSettings(context, settings),
                        _buildNotificationSettings(context, settings),
                        _buildUISettings(context, settings),
                        _buildBehaviorSettings(context, settings),
                      ],
                    ),
                  ),
                  _buildFooter(context),
                ],
              ),
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const Text(
            'Settings',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSettings(BuildContext context, Settings settings) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildSectionTitle('Pomodoro time'),
        _buildAvailableDurations(context, settings),
        const SizedBox(height: 16.0),
        _buildAddCustomDuration(context),
        const SizedBox(height: 24.0),
        _buildSectionTitle('Breaks time'),
        _buildSliderSetting(
          context,
          'Short Break Duration',
          settings.shortBreakDuration.toDouble(),
          1.0,
          30.0,
          (value) {
            _updateSettings(
              settings.copyWith(shortBreakDuration: value.round()),
            );
          },
        ),
        _buildSliderSetting(
          context,
          'Long break duration (minutes)',
          settings.longBreakDuration.toDouble(),
          5.0,
          60.0,
          (value) {
            _updateSettings(
              settings.copyWith(longBreakDuration: value.round()),
            );
          },
        ),
        _buildSliderSetting(
          context,
          'Number of Pomodoros until long break',
          settings.pomodorosUntilLongBreak.toDouble(),
          1.0,
          10.0,
          (value) {
            _updateSettings(
              settings.copyWith(pomodorosUntilLongBreak: value.round()),
            );
          },
          divisions: 9,
        ),
      ],
    );
  }

  Widget _buildAvailableDurations(BuildContext context, Settings settings) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        ...settings.availableDurations.map((duration) {
          return Chip(
            label: Text('$duration minutes'),
            deleteIcon: const Icon(Icons.close, size: 16.0),
            onDeleted: settings.availableDurations.length > 1
                ? () {
                    context
                        .read<SettingsBloc>()
                        .add(RemoveDurationEvent(duration));
                  }
                : null,
          );
        }).toList(),
      ],
    );
  }

  Widget _buildAddCustomDuration(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _customDurationController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Add custom duration (minutes)',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 8.0),
        ElevatedButton(
          onPressed: () {
            final text = _customDurationController.text;
            if (text.isNotEmpty) {
              final duration = int.tryParse(text);
              if (duration != null && duration > 0) {
                context
                    .read<SettingsBloc>()
                    .add(AddCustomDurationEvent(duration));
                _customDurationController.clear();
              }
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

  Widget _buildNotificationSettings(BuildContext context, Settings settings) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildSwitchSetting(
          context,
          'Notify when Pomodoro ends',
          settings.notifyOnPomodoroEnd,
          (value) {
            _updateSettings(settings.copyWith(notifyOnPomodoroEnd: value));
          },
        ),
        _buildSwitchSetting(
          context,
          'Notify when short break ends',
          settings.notifyOnBreakEnd,
          (value) {
            _updateSettings(settings.copyWith(notifyOnBreakEnd: value));
          },
        ),
        const SizedBox(height: 16.0),
        _buildSectionTitle('Sound'),
        DropdownButtonFormField<String>(
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
              _updateSettings(settings.copyWith(notificationSound: value));
            }
          },
        ),
        const SizedBox(height: 16.0),
        _buildSliderSetting(
          context,
          'Sound Volume',
          settings.notificationVolume,
          0.0,
          1.0,
          (value) {
            _updateSettings(settings.copyWith(notificationVolume: value));
          },
        ),
      ],
    );
  }

  Widget _buildUISettings(BuildContext context, Settings settings) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildSwitchSetting(
          context,
          'Dark mode',
          settings.darkMode,
          (value) {
            _updateSettings(settings.copyWith(darkMode: value));
          },
        ),
        _buildSwitchSetting(
          context,
          'Custom colors',
          settings.customColors,
          (value) {
            _updateSettings(settings.copyWith(customColors: value));
          },
        ),
        const SizedBox(height: 16.0),
        _buildSectionTitle('Color Theme'),
        _buildColorPreview(context, settings),
      ],
    );
  }

  Widget _buildColorPreview(BuildContext context, Settings settings) {
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
                Container(
                  width: 24.0,
                  height: 24.0,
                  decoration: BoxDecoration(
                    color: themeColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8.0),
                Container(
                  width: 24.0,
                  height: 24.0,
                  decoration: BoxDecoration(
                    color: themeColors.secondary,
                    shape: BoxShape.circle,
                  ),
                ),
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

  Widget _buildBehaviorSettings(BuildContext context, Settings settings) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildSwitchSetting(
          context,
          'Auto start break after Pomodoro ends',
          settings.autoStartBreak,
          (value) {
            _updateSettings(settings.copyWith(autoStartBreak: value));
          },
        ),
        _buildSwitchSetting(
          context,
          'Auto start Pomodoro after break ends',
          settings.autoStartPomodoro,
          (value) {
            _updateSettings(settings.copyWith(autoStartPomodoro: value));
          },
        ),
        _buildSwitchSetting(
          context,
          'Auto complete task on Pomodoro end',
          settings.autoCompleteTaskOnPomodoroEnd,
          (value) {
            _updateSettings(
              settings.copyWith(autoCompleteTaskOnPomodoroEnd: value),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSwitchSetting(
    BuildContext context,
    String title,
    bool value,
    Function(bool) onChanged,
  ) {
    return ListTile(
      title: Text(title),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSliderSetting(
    BuildContext context,
    String title,
    double value,
    double min,
    double max,
    Function(double) onChanged, {
    int? divisions,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title: ${value.round()}',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          label: value.round().toString(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _updateSettings(Settings settings) {
    context.read<SettingsBloc>().add(UpdateSettingsEvent(settings));
  }
}
