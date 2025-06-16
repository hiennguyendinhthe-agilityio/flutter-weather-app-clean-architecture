import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/event.dart';

/// Individual event card widget for timeline display
///
/// Displays event information with color coding, duration,
/// and interactive tap handling.
class EventCard extends StatelessWidget {
  final TimelineEvent event;
  final VoidCallback? onTap;
  final bool isCompact;

  const EventCard({
    super.key,
    required this.event,
    this.onTap,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          color: event.color.withOpacity(0.1),
          border: Border.all(
            color: event.color,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: event.color.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: isCompact ? _buildCompactContent() : _buildFullContent(),
      ),
    );
  }

  Widget _buildFullContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(
              event.icon,
              size: 16,
              color: event.color,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                event.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _buildPriorityIndicator(),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          _formatTimeRange(),
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (event.description.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            event.description,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _buildCompactContent() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Icon(
            event.icon,
            size: 14,
            color: event.color,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _formatTimeRange(),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          _buildPriorityIndicator(),
        ],
      ),
    );
  }

  Widget _buildPriorityIndicator() {
    if (event.priority <= 3) return const SizedBox.shrink();

    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: event.priority == 5 ? Colors.red : Colors.orange,
        shape: BoxShape.circle,
      ),
    );
  }

  String _formatTimeRange() {
    final startFormat = DateFormat('HH:mm');
    final endFormat = DateFormat('HH:mm');
    return '${startFormat.format(event.startTime)} - ${endFormat.format(event.endTime)}';
  }
}
