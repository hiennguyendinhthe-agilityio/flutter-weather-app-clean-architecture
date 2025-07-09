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
  final GlobalKey _mainTimelineKey = GlobalKey();

  late final ScrollController _scrollController;

  String? _visualHighlightId;

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  Object _getPageStorageIdentifier(DateTime date) {
    return 'calendar_scroll_${_normalizeDate(date).toIso8601String()}';
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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

  void _handleAutoScrollWithCenterKey(TaskProvider taskProvider) {
    if (taskProvider.recentlyAddedTaskId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        final currentOffset = _scrollController.offset;

        PageStorage.of(context).writeState(
          context,
          currentOffset,
          identifier: _getPageStorageIdentifier(
            taskProvider.selectedDate,
          ),
        );

        taskProvider.clearRecentlyAddedTask();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
            final newTaskId = taskProvider.recentlyAddedTaskId;
            if (newTaskId != null && newTaskId != _visualHighlightId) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() {
                    _visualHighlightId = newTaskId;
                  });
                }
              });
            }

            _handleAutoScrollWithCenterKey(taskProvider);

            if (taskProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final tasksForSelectedDay = taskProvider.tasksForSelectedDate;
            final hasTasks = tasksForSelectedDay.isNotEmpty;
            final highlightedTaskId = _visualHighlightId;

            _taskKeys.clear();
            for (var task in tasksForSelectedDay) {
              _taskKeys[task.id] = GlobalKey();
            }

            Key? centerKey;

            if (highlightedTaskId != null) {
              centerKey = _mainTimelineKey;
            }

            if (newTaskId != null) {
              centerKey = _mainTimelineKey;
            }

            final slivers = <Widget>[_buildStickyHeader(taskProvider)];
            if (!hasTasks) {
              slivers.add(
                const SliverToBoxAdapter(
                  child: TimelineHourItem(startHour: 0, endHour: 24, tasks: []),
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
              slivers.add(
                SliverToBoxAdapter(
                  key: _mainTimelineKey,
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

            return PageStorage(
              bucket: PageStorage.of(context),
              child: CustomScrollView(
                key: PageStorageKey(
                    _getPageStorageIdentifier(taskProvider.selectedDate)),
                controller: _scrollController,
                center: centerKey,
                physics: const BouncingScrollPhysics(),
                slivers: slivers,
              ),
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
          if (_visualHighlightId != null) {
            setState(() {
              _visualHighlightId = null;
            });
          }

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
