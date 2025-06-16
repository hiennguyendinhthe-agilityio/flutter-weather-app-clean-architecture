import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';

/// Task card widget displayed in the timeline
class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: _getCardColor(context),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: task.priority.color,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              if (task.description.isNotEmpty) ...[
                const SizedBox(height: 4),
                _buildDescription(),
              ],
              const Spacer(),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          task.status.icon,
          size: 16,
          color: task.status.color,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            task.title,
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: task.status == TaskStatus.completed ? Colors.grey : null,
              decoration: task.status == TaskStatus.completed
                  ? TextDecoration.lineThrough
                  : null,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      task.description,
      style: GoogleFonts.roboto(
        fontSize: 12,
        color: Colors.grey[600],
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        Text(
          _formatTimeRange(),
          style: GoogleFonts.roboto(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        const Spacer(),
        if (task.tags.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: task.priority.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              task.tags.first,
              style: GoogleFonts.roboto(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: task.priority.color,
              ),
            ),
          ),
      ],
    );
  }

  Color _getCardColor(BuildContext context) {
    if (task.isActive) {
      return task.priority.color.withOpacity(0.1);
    } else if (task.isOverdue) {
      return Colors.red.withOpacity(0.1);
    } else if (task.status == TaskStatus.completed) {
      return Colors.green.withOpacity(0.1);
    } else {
      return Theme.of(context).cardColor;
    }
  }

  String _formatTimeRange() {
    final startTime = DateFormat('HH:mm').format(task.startTime);
    final endTime = DateFormat('HH:mm').format(task.endTime);
    return '$startTime - $endTime';
  }
}
