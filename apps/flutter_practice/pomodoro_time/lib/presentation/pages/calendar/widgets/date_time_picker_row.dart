import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimePickerRow extends StatelessWidget {
  const DateTimePickerRow({
    super.key,
    required this.startDateTime,
    required this.endDateTime,
    required this.onPickDate,
    required this.onPickStartTime,
    required this.onPickEndTime,
    required this.labelText,
  });

  /// Selected start date & time
  final DateTime? startDateTime;

  /// Selected end time
  final DateTime? endDateTime;

  /// Callback when user picks a date
  final Function(DateTime) onPickDate;

  /// Callback when user picks start time
  final Function(DateTime) onPickStartTime;

  /// Callback when user picks end time
  final Function(DateTime) onPickEndTime;

  // Optional label text to display above the input fields
  final String? labelText;

  /// Show date picker and return selected date
  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: startDateTime ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) onPickDate(picked);
  }

  /// Show time picker for either start or end time
  Future<void> _pickTime(BuildContext context, bool isStart) async {
    final base = (isStart ? startDateTime : endDateTime) ?? DateTime.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(base),
    );
    if (picked != null) {
      final dt = DateTime(
        base.year,
        base.month,
        base.day,
        picked.hour,
        picked.minute,
      );
      if (isStart) {
        onPickStartTime(dt);
      } else {
        onPickEndTime(dt);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          const SizedBox(height: 8),
          Text(
            labelText ?? 'Tags',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
        ],
        Row(
          children: [
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () => _pickDate(context),
                child: _buildTile(
                    context,
                    startDateTime != null
                        ? DateFormat('EEE, MMM d').format(startDateTime!)
                        : 'Select date'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: GestureDetector(
                onTap: () => _pickTime(context, true),
                child: _buildTile(
                    context,
                    startDateTime != null
                        ? DateFormat('h:mma').format(startDateTime!)
                        : 'Start'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: GestureDetector(
                onTap: () => _pickTime(context, false),
                child: _buildTile(
                    context,
                    endDateTime != null
                        ? DateFormat('h:mma').format(endDateTime!)
                        : 'End'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTile(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: const TextStyle(fontSize: 14)),
    );
  }
}
