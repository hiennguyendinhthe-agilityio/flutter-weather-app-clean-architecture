import 'package:flutter/material.dart';
import 'package:task_management_app/core/utils/duration_formatter.dart';
import 'package:task_management_app/core/utils/task_utils.dart';

import '../../../../data/models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final bool isCompactMode;
  static const double _hourHeight = 60.0;
  static const double _minHeight = 80.0;

  const TaskCard({
    required this.task,
    this.isCompactMode = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final duration = task.endTime.difference(task.startTime);
    final rawHeight = duration.inMinutes * (_hourHeight / 60);
    final height = rawHeight < _minHeight ? _minHeight : rawHeight;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: height,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: const Color(0xFFE5E7EB),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Main content stretches to fill remaining space
                  Expanded(
                    child: isCompactMode
                        ? _buildCompactTaskContent()
                        : _buildNormalTaskContent(),
                  ),
                  // Duration badge pinned at bottom-right
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: constraints.maxWidth - 24,
                        maxHeight: height - 16,
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.bottomRight,
                        child: _buildDurationBadge(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompactTaskContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            border: Border.all(
              color: getColorFromName(task.projectColor),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(
              task.assignee.isNotEmpty ? task.assignee[0].toUpperCase() : '',
              style: TextStyle(
                color: getColorFromName(task.projectColor),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  task.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: getColorFromName(task.projectColor),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        '${task.projectName} (${task.assignee})',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNormalTaskContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(
              color: getColorFromName(task.projectColor),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              task.assignee.isNotEmpty ? task.assignee[0].toUpperCase() : '',
              style: TextStyle(
                color: getColorFromName(task.projectColor),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: getColorFromName(task.projectColor),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      '${task.projectName} (${task.assignee})',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDurationBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFDFE3E8),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            DurationFormatter.format(
              task.endTime.difference(task.startTime),
            ),
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '\$${(task.endTime.difference(task.startTime).inMinutes * 0.5).toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.blue[700],
            ),
          ),
        ],
      ),
    );
  }
}
