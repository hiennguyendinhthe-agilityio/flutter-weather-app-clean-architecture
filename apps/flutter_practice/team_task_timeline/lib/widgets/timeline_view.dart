import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/timeline_event.dart';
import '../providers/task_provider.dart';
import 'task_card.dart';

/// Main timeline view widget displaying tasks in a 24-hour grid
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

    // Auto-scroll to current time
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentTime();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final events = taskProvider.timelineEvents;

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: Row(
            children: [
              _buildTimeColumn(),
              Expanded(
                child: _buildTimelineContent(events),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimeColumn() {
    return Container(
      width: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          right: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: 24,
        itemBuilder: (context, index) {
          return Container(
            height: 60,
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              '${index.toString().padLeft(2, '0')}:00',
              style: GoogleFonts.roboto(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimelineContent(List<TimelineEvent> events) {
    return Stack(
      children: [
        _buildGridLines(),
        _buildCurrentTimeLine(),
        _buildTaskEvents(events),
      ],
    );
  }

  Widget _buildGridLines() {
    return ListView.builder(
      controller: ScrollController(),
      itemCount: 24,
      itemBuilder: (context, index) {
        return Container(
          height: 60,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor.withOpacity(0.3),
                width: 0.5,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCurrentTimeLine() {
    final now = DateTime.now();
    final currentHour = now.hour;
    final currentMinute = now.minute;
    final topPosition = (currentHour * 60.0) + (currentMinute * 60.0 / 60.0);

    return Positioned(
      top: topPosition,
      left: 0,
      right: 0,
      child: Container(
        height: 2,
        decoration: BoxDecoration(
          color: Colors.red,
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.3),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: Container(
                height: 2,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskEvents(List<TimelineEvent> events) {
    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_note,
              size: 64,
              color: Theme.of(context).disabledColor,
            ),
            const SizedBox(height: 16),
            Text(
              'No tasks for this day',
              style: GoogleFonts.roboto(
                fontSize: 16,
                color: Theme.of(context).disabledColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to add a task',
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: Theme.of(context).disabledColor,
              ),
            ),
          ],
        ),
      );
    }

    // Calculate the maximum number of columns needed
    final maxColumns = events.isEmpty
        ? 1
        : events.map((e) => e.column).reduce((a, b) => a > b ? a : b) + 1;
    final columnWidth = maxColumns > 0 ? 1.0 / maxColumns : 1.0;

    return SizedBox(
      height: 24 * 60.0, // 24 hours * 60 pixels per hour
      child: Stack(
        children: events.map((event) {
          return Positioned(
            top: event.topPosition,
            left: event.column *
                columnWidth *
                MediaQuery.of(context).size.width *
                0.8,
            width: columnWidth * MediaQuery.of(context).size.width * 0.8 - 8,
            height: event.height,
            child: TaskCard(
              task: event.task,
              onTap: () => _showTaskDetail(event.task),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _scrollToCurrentTime() {
    if (!_scrollController.hasClients) return;

    final now = DateTime.now();
    final currentHour = now.hour;
    final scrollPosition =
        (currentHour - 2) * 60.0; // Scroll to 2 hours before current time

    _scrollController.animateTo(
      scrollPosition.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _showTaskDetail(task) {
    // This will be handled by the parent widget
    // For now, we'll just show a simple dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(task.title),
        content: Text(task.description),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
