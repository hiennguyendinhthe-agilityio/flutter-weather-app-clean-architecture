import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/event.dart';
import '../services/timeline_service.dart';
import 'event_card.dart';
import 'event_detail_dialog.dart';

/// Side panel showing event summary for wide screen layouts
///
/// Displays today's events in a compact list format with statistics.
class EventSummaryPanel extends StatelessWidget {
  const EventSummaryPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TimelineService>(
      builder: (context, timelineService, child) {
        final events = timelineService.eventsForSelectedDate;
        final selectedDate = timelineService.selectedDate;

        return Container(
          color: Theme.of(context).cardColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, selectedDate, events.length),
              _buildStatistics(context, events),
              const Divider(),
              _buildEventsList(context, events),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, DateTime date, int eventCount) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Events Summary',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('EEEE, MMM d').format(date),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '$eventCount ${eventCount == 1 ? 'event' : 'events'}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics(BuildContext context, List<TimelineEvent> events) {
    if (events.isEmpty) return const SizedBox.shrink();

    final totalDuration = events.fold<int>(
      0,
      (sum, event) => sum + event.durationInMinutes,
    );

    final categoryStats = <String, int>{};
    for (final event in events) {
      categoryStats[event.category] = (categoryStats[event.category] ?? 0) + 1;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistics',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          _buildStatItem(
            context,
            Icons.schedule,
            'Total Time',
            _formatDuration(totalDuration),
          ),
          const SizedBox(height: 4),
          _buildStatItem(
            context,
            Icons.category,
            'Categories',
            categoryStats.length.toString(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }

  Widget _buildEventsList(BuildContext context, List<TimelineEvent> events) {
    if (events.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.event_busy,
                size: 48,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'No events today',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your schedule is clear!',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade500,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: EventCard(
              event: event,
              isCompact: true,
              onTap: () => _showEventDetails(context, event),
            ),
          );
        },
      ),
    );
  }

  void _showEventDetails(BuildContext context, TimelineEvent event) {
    showDialog(
      context: context,
      builder: (context) => EventDetailDialog(event: event),
    );
  }

  String _formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (hours > 0 && remainingMinutes > 0) {
      return '${hours}h ${remainingMinutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${remainingMinutes}m';
    }
  }
}
