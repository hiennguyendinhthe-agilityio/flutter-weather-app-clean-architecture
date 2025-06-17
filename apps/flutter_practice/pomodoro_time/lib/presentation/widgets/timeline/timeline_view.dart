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
                _buildPositioned(
                  context,
                  event,
                  colIndex,
                  columnWidth,
                  hourHeight,
                  timeLabelWidth,
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildPositioned(
    BuildContext context,
    TimelineEvent<T> event,
    int colIndex,
    double columnWidth,
    double hourHeight,
    double timeLabelWidth,
  ) {
    final startMin = event.start.hour * 60 + event.start.minute;
    final endMin = event.end.hour * 60 + event.end.minute;
    final top = startMin * (hourHeight / 60);
    final rawHeight = (endMin - startMin) * (hourHeight / 60);
    final height = rawHeight < 80.0 ? 80.0 : rawHeight;

    final left = timeLabelWidth + colIndex * columnWidth;
    final right = MediaQuery.of(context).size.width -
        timeLabelWidth -
        (colIndex + 1) * columnWidth -
        32.0;

    final isCompact = rawHeight < 80.0;

    return Positioned(
      top: top,
      left: left,
      right: right,
      height: height,
      child: eventBuilder(context, event.data, isCompact),
    );
  }
}
