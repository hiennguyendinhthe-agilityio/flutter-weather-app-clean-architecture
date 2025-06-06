// file: widgets/date_time_field.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef DateTimeCallback = Future<void> Function();

class DateTimeField extends StatelessWidget {
  final DateTime? dateTime;
  final String labelPrefix;
  final VoidCallback onTap;

  const DateTimeField({
    Key? key,
    required this.dateTime,
    required this.labelPrefix,
    required this.onTap,
  }) : super(key: key);

  String _formatDateTime(DateTime? dt) {
    if (dt == null) return 'Select date & time';
    final date = DateFormat('yyyy-MM-dd').format(dt);
    final time = DateFormat('HH:mm').format(dt);
    return '$date\n$time';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: Colors.grey.shade600),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '$labelPrefix: ${_formatDateTime(dateTime)}',
                maxLines: 2,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
