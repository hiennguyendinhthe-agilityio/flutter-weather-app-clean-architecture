import 'package:flutter/material.dart';
import 'package:task_management_app/data/models/settings.dart';
import 'package:task_management_app/presentation/widgets/custom_chip.dart';
import 'package:task_management_app/presentation/widgets/section_title.dart';
import 'package:task_management_app/presentation/widgets/slider_setting.dart';

class TimeSettingsTab extends StatefulWidget {
  final Settings settings;
  final Function(Settings) onSettingsChanged;
  final Function(int) onAddDuration;
  final Function(int) onRemoveDuration;

  const TimeSettingsTab({
    super.key,
    required this.settings,
    required this.onSettingsChanged,
    required this.onAddDuration,
    required this.onRemoveDuration,
  });

  @override
  State<TimeSettingsTab> createState() => _TimeSettingsTabState();
}

class _TimeSettingsTabState extends State<TimeSettingsTab> {
  final TextEditingController _customDurationController =
      TextEditingController();

  @override
  void dispose() {
    _customDurationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const SectionTitle(title: 'Pomodoro time'),
        _buildAvailableDurations(),
        const SizedBox(height: 16.0),
        _buildAddCustomDuration(),
        const SizedBox(height: 24.0),
        const SectionTitle(title: 'Breaks time'),
        SliderSetting(
          title: 'Short Break Duration',
          value: widget.settings.shortBreakDuration.toDouble(),
          min: 1.0,
          max: 30.0,
          onChanged: (value) {
            widget.onSettingsChanged(
              widget.settings.copyWith(shortBreakDuration: value.round()),
            );
          },
        ),
        SliderSetting(
          title: 'Long break duration (minutes)',
          value: widget.settings.longBreakDuration.toDouble(),
          min: 5.0,
          max: 60.0,
          onChanged: (value) {
            widget.onSettingsChanged(
              widget.settings.copyWith(longBreakDuration: value.round()),
            );
          },
        ),
        SliderSetting(
          title: 'Number of Pomodoros until long break',
          value: widget.settings.pomodorosUntilLongBreak.toDouble(),
          min: 1.0,
          max: 10.0,
          divisions: 9,
          onChanged: (value) {
            widget.onSettingsChanged(
              widget.settings.copyWith(pomodorosUntilLongBreak: value.round()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAvailableDurations() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        ...widget.settings.availableDurations.map((duration) {
          return CustomChip(
            label: '$duration minutes',
            onDeleted: widget.settings.availableDurations.length > 1
                ? () => widget.onRemoveDuration(duration)
                : null,
          );
        }).toList(),
      ],
    );
  }

  Widget _buildAddCustomDuration() {
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
                widget.onAddDuration(duration);
                _customDurationController.clear();
              }
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
