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

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_saveCurrentScrollOffset);

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
        onAddTask: (task) => taskProvider.addTask(task),
      ),
    );
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
            if (taskProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final tasksForSelectedDay = taskProvider.tasksForSelectedDate;
            final hasTasks = tasksForSelectedDay.isNotEmpty;
            final slivers = <Widget>[_buildStickyHeader(taskProvider)];

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
                    ),
                  ),
                );
              }

              slivers.add(
                SliverToBoxAdapter(
                  key: _firstTaskSliverKey,
                  child: TimelineHourItem(
                    startHour: firstTaskHour,
                    endHour: 24,
                    tasks: tasksForSelectedDay,
                  ),
                ),
              );
            }

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
