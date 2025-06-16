import 'package:flutter/material.dart';

import 'column_allocator.dart';
import 'time_axis_painter.dart';
import 'timeline_event.dart';

// Define a callback function type for building timeline items
typedef TimelineItemBuilder<T> = Widget Function(
  BuildContext context,
  T data,
  bool isCompact,
);

// A widget for displaying a timeline of events
class TimelineView<T> extends StatelessWidget {
  // The list of events to display
  final List<TimelineEvent<T>> events;

  // A callback function for building individual timeline items
  final TimelineItemBuilder<T> itemBuilder;

  // The height of each hour in the timeline
  final double hourHeight;

  // The minimum duration of an event
  final Duration minEventDuration;

  // An optional scroll controller for the timeline
  final ScrollController? scrollController;

  // The style for time labels
  final TextStyle timeLabelStyle;

  // The padding for the timeline
  final EdgeInsets padding;

  // The spacing between events
  final double eventSpacing;

  const TimelineView({
    required this.events,
    required this.itemBuilder,
    this.hourHeight = 60,
    this.minEventDuration = const Duration(minutes: 30),
    this.scrollController,
    this.timeLabelStyle = const TextStyle(color: Colors.grey),
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    this.eventSpacing = 8,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sort the events by start time
    final sorted = List<TimelineEvent<T>>.from(events)
      ..sort((a, b) => a.start.compareTo(b.start));

    // Allocate events to columns
    final columns = ColumnAllocator<TimelineEvent<T>>().allocate(
      sorted,
      (a, b) => a.start.isBefore(b.end) && b.start.isBefore(a.end),
    );

    // Calculate the total height of the timeline
    final totalHeight = 24 * hourHeight;

    // Define the width of time labels
    const timeLabelWidth = 68.0;

    // Calculate the available width for events
    final availableWidth =
        MediaQuery.of(context).size.width - timeLabelWidth - padding.horizontal;

    // Calculate the number of columns and the width of each column
    final colCount = columns.length;
    final totalGaps = eventSpacing * (colCount - 1);
    final colWidth =
        (availableWidth - totalGaps) / (colCount > 0 ? colCount : 1);

    // Return a scrollable timeline
    return SingleChildScrollView(
      controller: scrollController,
      padding: padding,
      child: SizedBox(
        height: totalHeight,
        child: Stack(
          children: [
            // Paint the time axis
            CustomPaint(
              size: Size(double.infinity, totalHeight),
              painter: TimeAxisPainter(
                hourHeight: hourHeight,
                labelStyle: timeLabelStyle,
              ),
            ),
            // Build events for each column
            for (var colIdx = 0; colIdx < colCount; colIdx++)
              for (final evt in columns[colIdx])
                _buildEvent(context, evt, colIdx, colWidth, timeLabelWidth),
          ],
        ),
      ),
    );
  }

  // Build an individual event
  Widget _buildEvent(
    BuildContext ctx,
    TimelineEvent<T> evt,
    int colIdx,
    double colWidth,
    double timeLabelWidth,
  ) {
    // Calculate the start and end times of the event
    final startMin = evt.start.hour * 60 + evt.start.minute;
    final endMin = evt.end.hour * 60 + evt.end.minute;

    // Calculate the position and size of the event
    final top = startMin * (hourHeight / 60);
    final rawHeight = (endMin - startMin) * (hourHeight / 60);
    final minH = minEventDuration.inMinutes * (hourHeight / 60);
    final height = rawHeight < minH ? minH : rawHeight;
    final left = timeLabelWidth + colIdx * (colWidth + eventSpacing);
    final width = colWidth;
    final isCompact = rawHeight < minH;

    // Return a positioned event
    return Positioned(
      top: top,
      left: left,
      width: width,
      height: height,
      child: itemBuilder(ctx, evt.data, isCompact),
    );
  }
}
