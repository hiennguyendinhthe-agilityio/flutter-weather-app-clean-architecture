import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../models/event.dart';
import '../services/timeline_service.dart';
import '../theme/app_theme.dart';
import 'event_card.dart';
import 'event_detail_dialog.dart';

/// Main timeline view displaying 24-hour grid with events
///
/// Uses TimelineTile package for rendering timeline structure.
/// Handles event positioning, overlap detection, and interaction.
class TimelineView extends StatefulWidget {
  const TimelineView({super.key});

  @override
  State<TimelineView> createState() => _TimelineViewState();
}

class _TimelineViewState extends State<TimelineView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Auto-scroll to current time on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentTime();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCurrentTime() {
    final now = DateTime.now();
    final currentHour = now.hour;
    final scrollPosition =
        (currentHour * 80.0) - 200; // 80px per hour, offset for visibility

    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        scrollPosition.clamp(0.0, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimelineService>(
      builder: (context, timelineService, child) {
        final events = timelineService.eventsForSelectedDate;
        final eventColumns = _organizeEventsIntoColumns(events);

        return Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: _buildTimelineHeader(timelineService.selectedDate),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildTimelineHour(
                    hour: index,
                    eventColumns: eventColumns,
                    isCurrentHour:
                        _isCurrentHour(index, timelineService.selectedDate),
                  ),
                  childCount: 24,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimelineHeader(DateTime selectedDate) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Text(
            _formatSelectedDate(selectedDate),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineHour({
    required int hour,
    required Map<int, List<TimelineEvent>> eventColumns,
    required bool isCurrentHour,
  }) {
    final hourEvents = eventColumns[hour] ?? [];

    return SizedBox(
      height: 80,
      child: TimelineTile(
        alignment: TimelineAlign.manual,
        lineXY: 0.15,
        isFirst: hour == 0,
        isLast: hour == 23,
        indicatorStyle: IndicatorStyle(
          width: TimelineTheme.indicatorSize,
          height: TimelineTheme.indicatorSize,
          indicator: Container(
            decoration: BoxDecoration(
              color: isCurrentHour
                  ? Theme.of(context).colorScheme.primary
                  : TimelineTheme.getIndicatorColor(context).withOpacity(0.3),
              shape: BoxShape.circle,
              border: Border.all(
                color: TimelineTheme.getLineColor(context),
                width: 2,
              ),
            ),
          ),
        ),
        beforeLineStyle: LineStyle(
          color: TimelineTheme.getLineColor(context),
          thickness: TimelineTheme.lineThickness,
        ),
        afterLineStyle: LineStyle(
          color: TimelineTheme.getLineColor(context),
          thickness: TimelineTheme.lineThickness,
        ),
        startChild: _buildHourLabel(hour, isCurrentHour),
        endChild: _buildEventArea(hourEvents, hour),
      ),
    );
  }

  Widget _buildHourLabel(int hour, bool isCurrentHour) {
    return Container(
      width: TimelineTheme.hourLabelWidth,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 16),
      child: Text(
        '${hour.toString().padLeft(2, '0')}:00',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: isCurrentHour
                  ? Theme.of(context).colorScheme.primary
                  : TimelineTheme.getHourLabelColor(context),
              fontWeight: isCurrentHour ? FontWeight.bold : FontWeight.normal,
            ),
      ),
    );
  }

  Widget _buildEventArea(List<TimelineEvent> events, int hour) {
    if (events.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 16, top: 4, bottom: 4),
      child: Stack(
        children: events.asMap().entries.map((entry) {
          final index = entry.key;
          final event = entry.value;
          return _buildPositionedEventCard(event, index, events.length);
        }).toList(),
      ),
    );
  }

  Widget _buildPositionedEventCard(
      TimelineEvent event, int columnIndex, int totalColumns) {
    final cardWidth = totalColumns > 1
        ? (1.0 / totalColumns) - 0.02 // Small gap between overlapping events
        : 1.0;
    final leftOffset =
        totalColumns > 1 ? (columnIndex * (1.0 / totalColumns)) + 0.01 : 0.0;

    return Positioned(
      left: leftOffset * 300, // Approximate width of event area
      top: 0,
      bottom: 0,
      width: cardWidth * 300,
      child: EventCard(
        event: event,
        onTap: () => _showEventDetails(event),
      ),
    );
  }

  void _showEventDetails(TimelineEvent event) {
    showDialog(
      context: context,
      builder: (context) => EventDetailDialog(event: event),
    );
  }

  /// Organize overlapping events into columns for proper display
  Map<int, List<TimelineEvent>> _organizeEventsIntoColumns(
      List<TimelineEvent> events) {
    final Map<int, List<TimelineEvent>> hourEvents = {};

    // Group events by start hour
    for (final event in events) {
      final hour = event.startHour;
      hourEvents[hour] ??= [];
      hourEvents[hour]!.add(event);
    }

    // Sort events within each hour by start time
    for (final hourEventList in hourEvents.values) {
      hourEventList.sort((a, b) => a.startTime.compareTo(b.startTime));
    }

    return hourEvents;
  }

  bool _isCurrentHour(int hour, DateTime selectedDate) {
    final now = DateTime.now();
    return _isSameDay(selectedDate, now) && now.hour == hour;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _formatSelectedDate(DateTime date) {
    final now = DateTime.now();
    if (_isSameDay(date, now)) {
      return 'Today';
    } else if (_isSameDay(date, now.add(const Duration(days: 1)))) {
      return 'Tomorrow';
    } else if (_isSameDay(date, now.subtract(const Duration(days: 1)))) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
