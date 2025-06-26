import 'package:flutter/material.dart';
import 'package:task_management_app/core/utils/task_utils.dart';

import '../../../../data/models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final bool isCompactMode;
  static const double _hourHeight = 60.0;
  static const double _minHeight = 80.0;
  static const double _badgeHeight = 24.0; // Base height of the badge

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
        final avatarSize = isCompactMode
            ? (height * 0.25).clamp(24.0, 32.0)
            : (height * 0.2).clamp(19.0, 25.0);

        return SizedBox(
          width: constraints.maxWidth,
          height: height,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Main card, with bottom margin to accommodate half-overlap of badge
              Container(
                margin: const EdgeInsets.only(bottom: _badgeHeight / 2),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: isCompactMode
                    ? _buildCompactTaskContent(avatarSize)
                    : _buildNormalTaskContent(avatarSize),
              ),

              // Badge half inside, half outside the card
              Positioned(
                bottom: -_badgeHeight / 150,
                right: 8,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: constraints.maxWidth - 24,
                    // Allow badge to stretch a bit if needed
                    maxHeight: height + (_badgeHeight / 2),
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
        );
      },
    );
  }

  Widget _buildCompactTaskContent(double avatarSize) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildAvatar(avatarSize),
          const SizedBox(width: 8),
          Expanded(
              child: _buildTextColumn(
                  fontSize: avatarSize * 0.4, dotSize: avatarSize * 0.19)),
        ],
      );

  Widget _buildNormalTaskContent(double avatarSize) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAvatar(avatarSize),
          const SizedBox(width: 12),
          Expanded(
              child: _buildTextColumn(
                  fontSize: avatarSize * 0.5, dotSize: avatarSize * 0.2)),
        ],
      );

  Widget _buildAvatar(double size) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          border: Border.all(color: getColorFromName(task.projectColor)),
          borderRadius: BorderRadius.circular(size * 0.2),
        ),
        child: Center(
          child: Text(
            task.assignee.isNotEmpty ? task.assignee[0].toUpperCase() : '',
            style: TextStyle(
              fontSize: size * 0.45,
              color: getColorFromName(task.projectColor),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );

  Widget _buildTextColumn(
          {required double fontSize, required double dotSize}) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task.title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
            maxLines: isCompactMode ? 1 : 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                width: dotSize,
                height: dotSize,
                decoration: BoxDecoration(
                  color: getColorFromName(task.projectColor),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${task.projectName} (${task.assignee})',
                  style: TextStyle(
                      fontSize: fontSize * 0.75, color: Colors.grey[600]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      );

  Widget _buildDurationBadge() {
    final dur = task.endTime.difference(task.startTime);
    final price = (dur.inMinutes * 0.5).toStringAsFixed(2);
    return Container(
      height: _badgeHeight,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFDFE3E8)),
        borderRadius: BorderRadius.circular(_badgeHeight / 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              formatDuration(dur),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 8),
            Text(
              '\$$price',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[700]),
            ),
          ],
        ),
      ),
    );
  }
}
