import 'package:flutter/material.dart';

import 'column_allocator.dart';
import 'time_axis_painter.dart';
import 'timeline_event.dart';

typedef TimelineItemBuilder<T> = Widget Function(
  BuildContext context,
  T data,
  bool isCompact,
);

class TimelineView<T> extends StatelessWidget {
  final List<TimelineEvent<T>> events;
  final TimelineItemBuilder<T> itemBuilder;
  final double hourHeight;
  final Duration minEventDuration;
  final ScrollController? scrollController;
  final TextStyle timeLabelStyle;
  final EdgeInsets padding;

  const TimelineView({
    required this.events,
    required this.itemBuilder,
    this.hourHeight = 60,
    this.minEventDuration = const Duration(minutes: 30),
    this.scrollController,
    this.timeLabelStyle = const TextStyle(color: Colors.grey),
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sorted = List<TimelineEvent<T>>.from(events)
      ..sort((a, b) => a.start.compareTo(b.start));
    final columns = ColumnAllocator<TimelineEvent<T>>().allocate(
      sorted,
      (a, b) => a.start.isBefore(b.end) && b.start.isBefore(a.end),
    );

    final totalHeight = 24 * hourHeight;
    const timeLabelWidth = 68.0;
    final availableWidth =
        MediaQuery.of(context).size.width - timeLabelWidth - padding.horizontal;
    final colCount = columns.length;
    final colWidth = availableWidth / (colCount > 0 ? colCount : 1);

    return SingleChildScrollView(
      controller: scrollController,
      padding: padding,
      child: SizedBox(
        height: totalHeight,
        child: Stack(
          children: [
            CustomPaint(
              size: Size(double.infinity, totalHeight),
              painter: TimeAxisPainter(
                hourHeight: hourHeight,
                labelStyle: timeLabelStyle,
              ),
            ),
            for (var colIdx = 0; colIdx < colCount; colIdx++)
              for (final evt in columns[colIdx])
                _buildEvent(context, evt, colIdx, colWidth, timeLabelWidth),
          ],
        ),
      ),
    );
  }

  Widget _buildEvent(
    BuildContext ctx,
    TimelineEvent<T> evt,
    int colIdx,
    double colWidth,
    double timeLabelWidth,
  ) {
    final startMin = evt.start.hour * 60 + evt.start.minute;
    final endMin = evt.end.hour * 60 + evt.end.minute;
    final top = startMin * (hourHeight / 60);
    final rawHeight = (endMin - startMin) * (hourHeight / 60);

    final minH = minEventDuration.inMinutes * (hourHeight / 60);
    final height = rawHeight < minH ? minH : rawHeight;

    final left = timeLabelWidth + colIdx * colWidth;
    final width = colWidth;
    final isCompact = rawHeight < minH;

    return Positioned(
      top: top,
      left: left,
      width: width,
      height: height,
      child: itemBuilder(ctx, evt.data, isCompact),
    );
  }
}
