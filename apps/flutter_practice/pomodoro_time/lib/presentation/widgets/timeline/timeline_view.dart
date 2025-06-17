import 'package:flutter/material.dart';

import 'column_allocator.dart';
import 'time_axis_painter.dart';
import 'timeline_event.dart';

typedef EventBuilder<T> = Widget Function(
  BuildContext context,
  T data,
  bool isCompactMode,
);

class TimelineView<T> extends StatelessWidget {
  final DateTime selectedDate;
  final List<TimelineEvent<T>> events;
  final ScrollController scrollController;
  final EventBuilder<T> eventBuilder;

  const TimelineView({
    Key? key,
    required this.selectedDate,
    required this.events,
    required this.scrollController,
    required this.eventBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dayZero = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );
    final filtered = events.where((e) {
      final d = e.start;
      final dayOfEvent = DateTime(d.year, d.month, d.day);
      return dayOfEvent.isAtSameMomentAs(dayZero);
    }).toList()
      ..sort((a, b) => a.start.compareTo(b.start));

    final columns = allocateColumns(filtered);

    const hourHeight = 60.0;
    const totalHours = 24;
    const timelineHeight = totalHours * hourHeight;
    const timeLabelWidth = 68.0;
    final availableWidth =
        MediaQuery.of(context).size.width - timeLabelWidth - 32.0;
    final columnWidth =
        columns.isEmpty ? availableWidth : availableWidth / columns.length;

    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: SizedBox(
        height: timelineHeight,
        child: Stack(
          children: [
            const CustomPaint(
              size: Size(double.infinity, timelineHeight),
              painter: TimeAxisPainter(),
            ),
            for (var colIndex = 0; colIndex < columns.length; colIndex++)
              for (var event in columns[colIndex])
                Positioned(
                  top: _minutesToOffset(event.start, hourHeight),
                  left: timeLabelWidth + colIndex * columnWidth,
                  right: MediaQuery.of(context).size.width -
                      timeLabelWidth -
                      (colIndex + 1) * columnWidth -
                      32.0,
                  child: eventBuilder(
                    context,
                    event.data,
                    _isCompact(event, hourHeight),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  double _minutesToOffset(DateTime start, double hourHeight) {
    final startMin = start.hour * 60 + start.minute;
    return startMin * (hourHeight / 60);
  }

  bool _isCompact(TimelineEvent<T> event, double hourHeight) {
    final durationMin = event.end.difference(event.start).inMinutes;
    final rawHeight = durationMin * (hourHeight / 60);
    return rawHeight < 80.0;
  }
}
