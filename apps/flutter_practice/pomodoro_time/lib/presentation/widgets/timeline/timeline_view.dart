import 'package:flutter/material.dart';

import 'column_allocator.dart';
import 'timeline_event.dart';

typedef EventBuilder<T> = Widget Function(
  BuildContext context,
  T data,
  bool isCompactMode,
);

class TimelineViewSliver<T> extends StatelessWidget {
  final DateTime selectedDate;
  final List<TimelineEvent<T>> events;
  final EventBuilder<T> eventBuilder;

  const TimelineViewSliver({
    Key? key,
    required this.selectedDate,
    required this.events,
    required this.eventBuilder,
  }) : super(key: key);

  static const double hourHeight = 60.0;
  static const double timeLabelWidth = 68.0;
  static const double horizontalPadding = 16.0;

  @override
  Widget build(BuildContext context) {
    const timelineHeight = 24 * hourHeight;

    final dayStart = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );
    final dayEnd = dayStart.add(const Duration(days: 1));

    final filteredEvents = events
        .where((e) =>
            e.start.isBefore(dayEnd) &&
            e.end.isAfter(dayStart)) // overlaps today
        .toList()
      ..sort((a, b) => a.start.compareTo(b.start));

    final columns = allocateColumns(filteredEvents);
    final columnCount = columns.length;

    final availableWidth = MediaQuery.of(context).size.width -
        timeLabelWidth -
        2 * horizontalPadding;
    final columnWidth =
        columnCount == 0 ? availableWidth : availableWidth / columnCount;

    const double taskPadding = 4.0;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: SizedBox(
          height: timelineHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Timeline hours
              for (int hour = 0; hour <= 24; hour++)
                Positioned(
                  top: hour * hourHeight,
                  left: 0,
                  right: 0,
                  child:
                      _HourLine(label: '${hour.toString().padLeft(2, '0')}:00'),
                ),

              // Events positioned by start time
              for (int colIndex = 0; colIndex < columns.length; colIndex++)
                for (final event in columns[colIndex])
                  Positioned(
                    top: _minutesFromStart(event.start, dayStart) *
                        (hourHeight / 60),
                    left: timeLabelWidth + colIndex * columnWidth + taskPadding,
                    width: columnWidth - taskPadding * 2,
                    height: _durationInMinutes(event) * (hourHeight / 60),
                    child: eventBuilder(
                      context,
                      event.data,
                      _isCompact(event),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  double _minutesFromStart(DateTime dt, DateTime dayStart) {
    return dt.difference(dayStart).inMinutes.toDouble();
  }

  int _durationInMinutes(TimelineEvent<T> e) {
    return e.end.difference(e.start).inMinutes;
  }

  bool _isCompact(TimelineEvent<T> event) {
    return _durationInMinutes(event) * (hourHeight / 60) < 80;
  }
}

class _HourLine extends StatelessWidget {
  final String label;

  const _HourLine({required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: TimelineViewSliver.hourHeight,
      child: Stack(
        children: [
          // line
          Positioned(
            left: TimelineViewSliver.timeLabelWidth,
            right: 0,
            top: 0,
            child: Container(height: 1, color: const Color(0xFFE0E0E0)),
          ),
          // label
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: SizedBox(
              width: TimelineViewSliver.timeLabelWidth,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  label,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
