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
  final GlobalKey _firstTaskSliverKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  final Map<DateTime, double> _scrollOffsets = {};
  final Map<String, GlobalKey> _taskKeys = {};

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_saveCurrentScrollOffset);

    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final today = DateTime.now();
    final selected = _normalizeDate(taskProvider.selectedDate);
    final normalizedToday = _normalizeDate(today);
    if (selected != normalizedToday) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        taskProvider.setSelectedDate(normalizedToday);
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToFirstTask();
    });
  }

  void _saveCurrentScrollOffset() {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final currentDate = _normalizeDate(taskProvider.selectedDate);
    if (_scrollController.hasClients) {
      _scrollOffsets[currentDate] = _scrollController.offset;
    }
  }

  void _scrollToFirstTask() {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    if (taskProvider.tasksForSelectedDate.isNotEmpty) {
      final keyContext = _firstTaskSliverKey.currentContext;
      if (keyContext != null) {
        Scrollable.ensureVisible(
          keyContext,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          alignment: 0.0,
        );
      }
    }
  }

  void _scrollToRecentlyAddedTask(String? taskId) {
    if (taskId == null) return;
    final key = _taskKeys[taskId];
    if (key == null) return;
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.1,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollController.removeListener(_saveCurrentScrollOffset);
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
              task.startTime.year, task.startTime.month, task.startTime.day);
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
            final slivers = <Widget>[_buildStickyHeader(taskProvider)];
            final highlightedTaskId = taskProvider.recentlyAddedTaskId;

            _taskKeys.clear();
            for (var task in tasksForSelectedDay) {
              _taskKeys[task.id] = GlobalKey();
            }

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

              slivers.add(
                SliverToBoxAdapter(
                  key: _firstTaskSliverKey,
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

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (highlightedTaskId != null) {
                _scrollToRecentlyAddedTask(highlightedTaskId);
              }
            });

            return CustomScrollView(
              controller: _scrollController,
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
          final normalizedDate = _normalizeDate(date);

          provider.setSelectedDate(date);

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollOffsets.containsKey(normalizedDate)) {
              _scrollController.jumpTo(_scrollOffsets[normalizedDate]!);
            } else {
              _scrollToFirstTask();
            }
          });
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
