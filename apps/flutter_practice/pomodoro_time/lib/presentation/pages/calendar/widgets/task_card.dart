import 'package:flutter/material.dart';
import 'package:task_management_app/core/utils/task_utils.dart';

import '../../../../data/models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final bool isCompactMode;
  static const double _badgeHeight = 24.0;
  final bool isHighlighted;

  const TaskCard({
    required this.task,
    this.isCompactMode = false,
    this.isHighlighted = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final avatarSize = _calculateAvatarSize(constraints.maxHeight);

        return Stack(
          clipBehavior: Clip.none,
          children: [
            _buildCardContent(avatarSize, constraints),
            _buildBadgeOverlay(constraints),
          ],
        );
      },
    );
  }

  Widget _buildCardContent(double avatarSize, BoxConstraints constraints) {
    final cardColor = isHighlighted ? Colors.yellow[200] : Colors.blue[100];
    final borderColor = isHighlighted ? Colors.green : Colors.transparent;
    final borderWidth = isHighlighted ? 3.0 : 0.0;

    return Container(
      width: constraints.maxWidth,
      height: constraints.maxHeight,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: cardColor,
        border: Border.all(color: borderColor, width: borderWidth),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: isCompactMode
          ? _buildCompactTaskContent(avatarSize)
          : _buildNormalTaskContent(avatarSize),
    );
  }

  Widget _buildBadgeOverlay(BoxConstraints constraints) {
    return Positioned(
      bottom: -_badgeHeight / 2,
      right: 8,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: constraints.maxWidth - 24),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.bottomRight,
          child: _buildDurationBadge(),
        ),
      ),
    );
  }

  double _calculateAvatarSize(double cardHeight) {
    final scale = isCompactMode ? 0.25 : 0.2;
    final min = isCompactMode ? 24.0 : 19.0;
    final max = isCompactMode ? 32.0 : 25.0;
    return (cardHeight * scale).clamp(min, max);
  }

  Widget _buildCompactTaskContent(double avatarSize) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildAvatar(avatarSize),
          const SizedBox(width: 8),
          Expanded(child: _buildTextColumn(avatarSize, compact: true)),
        ],
      );

  Widget _buildNormalTaskContent(double avatarSize) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAvatar(avatarSize),
          const SizedBox(width: 8),
          Expanded(child: _buildTextColumn(avatarSize, compact: false)),
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
              fontSize: size * 0.55,
              color: getColorFromName(task.projectColor),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );

  Widget _buildTextColumn(double avatarSize, {required bool compact}) {
    final fontSize = avatarSize * (compact ? 0.6 : 0.8);
    final dotSize = avatarSize * (compact ? 0.19 : 0.2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          task.title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
          maxLines: compact ? 1 : 2,
          overflow: TextOverflow.ellipsis,
        ),
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
                    fontSize: fontSize * 0.7, color: Colors.grey[600]),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

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
            color: Colors.black.withOpacity(0.08),
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
