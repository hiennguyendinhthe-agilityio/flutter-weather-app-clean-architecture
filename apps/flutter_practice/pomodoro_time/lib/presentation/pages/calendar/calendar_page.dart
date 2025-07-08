import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/presentation/pages/calendar/widgets/sticky_header_delegate.dart';
import 'package:task_management_app/presentation/pages/tasks/widgets/add_task_bottomsheet.dart';
import 'package:task_management_app/presentation/providers/task_provider.dart';
import 'package:task_management_app/presentation/widgets/common_gradient_background.dart';
import 'package:task_management_app/presentation/widgets/timeline/timeline_hour_item.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final Map<String, GlobalKey> _taskKeys = {};

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  void initState() {
    super.initState();
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final today = DateTime.now();
    final selected = _normalizeDate(taskProvider.selectedDate);
    final normalizedToday = _normalizeDate(today);

    if (selected != normalizedToday) {
      WidgetsBinding.instance.addPostFrameCallback((_) {});
    }
  }

  void _showAddTaskBottomSheet() {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      builder: (ctx) => AddTaskBottomsheet(
        onAddTask: (task) {
          final taskDate = DateTime(
            task.startTime.year,
            task.startTime.month,
            task.startTime.day,
          );
          Provider.of<TaskProvider>(context, listen: false)
              .setSelectedDate(taskDate);
          taskProvider.addTask(task);
        },
      ),
    );
  }

  void _clearHighlightAfterFrame(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      if (taskProvider.recentlyAddedTaskId != null) {
        taskProvider.clearRecentlyAddedTask();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _clearHighlightAfterFrame(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 95, 219, 250),
        elevation: 0,
        title: const Text('Calendar'),
        centerTitle: false,
        automaticallyImplyLeading: false,
        leading: IconButton(
          color: Colors.black,
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton.icon(
            onPressed: _showAddTaskBottomSheet,
            icon: const Text(
              'New Task',
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            label: const Icon(Icons.add, color: Colors.black, size: 20),
          ),
        ],
      ),
      body: CommonGradientBackground(
        child: Consumer<TaskProvider>(
          builder: (context, taskProvider, _) {
            if (taskProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final tasksForSelectedDay = taskProvider.tasksForSelectedDate;
            final hasTasks = tasksForSelectedDay.isNotEmpty;
            final highlightedTaskId = taskProvider.recentlyAddedTaskId;

            _taskKeys.clear();
            for (var task in tasksForSelectedDay) {
              _taskKeys[task.id] = GlobalKey();
            }

            final slivers = <Widget>[_buildStickyHeader(taskProvider)];
            Key? centerKey;

            if (!hasTasks) {
              slivers.add(
                const SliverToBoxAdapter(
                  child: TimelineHourItem(
                    startHour: 0,
                    endHour: 24,
                    tasks: [],
                  ),
                ),
              );
            } else {
              final firstTaskHour = tasksForSelectedDay.first.startTime.hour;

              if (firstTaskHour > 0) {
                slivers.add(
                  SliverToBoxAdapter(
                    child: TimelineHourItem(
                      startHour: 0,
                      endHour: firstTaskHour,
                      tasks: const [],
                      highlightedTaskId: highlightedTaskId,
                      taskKeys: _taskKeys,
                    ),
                  ),
                );
              }

              final mainTimelineKey = GlobalKey();

              if (highlightedTaskId != null) {
                centerKey = mainTimelineKey;
              }

              slivers.add(
                SliverToBoxAdapter(
                  key: mainTimelineKey,
                  child: TimelineHourItem(
                    highlightedTaskId: highlightedTaskId,
                    startHour: firstTaskHour,
                    endHour: 24,
                    tasks: tasksForSelectedDay,
                    taskKeys: _taskKeys,
                  ),
                ),
              );
            }

            final pageStorageKey = PageStorageKey(
                'calendar_scroll_${_normalizeDate(taskProvider.selectedDate).toIso8601String()}');

            return CustomScrollView(
              key: pageStorageKey,
              center: centerKey,
              physics: const BouncingScrollPhysics(),
              slivers: slivers,
            );
          },
        ),
      ),
    );
  }

  Widget _buildStickyHeader(TaskProvider provider) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: StickyHeaderDelegate(
        selectedDate: provider.selectedDate,
        onDateSelected: (date) {
          provider.setSelectedDate(date);
        },
        totalTime: provider.activeTasks.fold(
          Duration.zero,
          (sum, t) => sum + t.endTime.difference(t.startTime),
        ),
        centerIndex: 30,
      ),
    );
  }
}
