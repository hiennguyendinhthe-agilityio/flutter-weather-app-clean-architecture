import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/task_utils.dart';
import '../../../../data/models/task.dart';

class TaskDetailDialog extends StatelessWidget {
  final Task task;

  const TaskDetailDialog({required this.task, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFc2e9fb), Color(0xFFa1c4fd)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Task Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              _buildDetailRow(Icons.title, task.title),
              _buildDetailRow(Icons.folder, task.projectName),
              _buildDetailRow(Icons.person, task.assignee),
              _buildDetailRow(
                Icons.access_time,
                '${timeFormat.format(task.startTime)} - ${timeFormat.format(task.endTime)}',
              ),
              _buildDetailRow(Icons.timer, formatDuration(task.timeSpent)),
              _buildDetailRow(
                Icons.attach_money,
                '\$${(task.timeSpent.inMinutes * 0.5).toStringAsFixed(2)}',
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.black54),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
