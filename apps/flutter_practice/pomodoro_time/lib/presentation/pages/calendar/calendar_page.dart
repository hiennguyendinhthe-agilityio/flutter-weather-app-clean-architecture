import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/data/models/task.dart';
import 'package:task_management_app/presentation/pages/calendar/widgets/calendar_header.dart';
import 'package:task_management_app/presentation/pages/calendar/widgets/date_selector.dart';
import 'package:task_management_app/presentation/pages/calendar/widgets/task_card.dart';
import 'package:task_management_app/presentation/pages/tasks/widgets/add_task_bottomsheet.dart';
import 'package:task_management_app/presentation/pages/tasks/widgets/task_detail_dialog.dart';
import 'package:task_management_app/presentation/widgets/common_gradient_background.dart';
import 'package:task_management_app/presentation/widgets/timeline/timeline_event.dart';
import 'package:task_management_app/presentation/widgets/timeline/timeline_view.dart';

import '../../providers/task_provider.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _selectedDate;
  late ScrollController _headerScrollController;
  late ScrollController _timelineScrollController;
  bool _hasScrolledToSelectedDate = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _headerScrollController = ScrollController();
    _timelineScrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasScrolledToSelectedDate && _headerScrollController.hasClients) {
        _jumpToToday();
        _scrollToCurrentTime();
        _hasScrolledToSelectedDate = true;
      }
    });
  }

  void _jumpToToday() {
    const itemWidth = 60.0 + 8.0;
    const todayIndex = 30;
    final offset = todayIndex * itemWidth -
        (MediaQuery.of(context).size.width / 2) +
        (itemWidth / 2);
    _headerScrollController.jumpTo(offset.clamp(
      0.0,
      _headerScrollController.position.maxScrollExtent,
    ));
  }

  void _scrollToCurrentTime() {
    final now = TimeOfDay.now();
    final minutesFromStart = now.hour * 60 + now.minute;
    const hourHeight = 60.0;
    final offset = minutesFromStart * (hourHeight / 60) - 100;
    _timelineScrollController.jumpTo(offset.clamp(
      0.0,
      _timelineScrollController.position.maxScrollExtent,
    ));
  }

  @override
  void dispose() {
    _headerScrollController.dispose();
    _timelineScrollController.dispose();
    super.dispose();
  }

  void _showAddTaskBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AddTaskBottomsheet(onAddTask: (task) {
        Provider.of<TaskProvider>(ctx, listen: false).addTask(task);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CommonGradientBackground(
        child: SafeArea(
          child: Consumer<TaskProvider>(
            builder: (context, taskProvider, child) {
              if (taskProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              final events = taskProvider.allTasks
                  .map((t) => TimelineEvent<Task>(
                        data: t,
                        start: t.startTime,
                        end: t.endTime,
                      ))
                  .toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CalendarHeader(onNewTaskPressed: _showAddTaskBottomSheet),
                  DateSelector(
                    selectedDate: _selectedDate,
                    onDateSelected: (date) {
                      setState(() => _selectedDate = date);
                      if (_timelineScrollController.hasClients) {
                        if (date == DateTime.now()) {
                          _scrollToCurrentTime();
                        } else {
                          _timelineScrollController.jumpTo(0);
                        }
                      }
                    },
                    scrollController: _headerScrollController,
                    totalTime: taskProvider.activeTasks.fold(
                      Duration.zero,
                      (sum, t) => sum + t.endTime.difference(t.startTime),
                    ),
                  ),
                  Expanded(
                    child: TimelineView<Task>(
                      selectedDate: _selectedDate,
                      events: events,
                      scrollController: _timelineScrollController,
                      eventBuilder: (ctx, task, isCompact) => GestureDetector(
                        onTap: () => showDialog(
                          context: ctx,
                          builder: (_) => TaskDetailDialog(task: task),
                        ),
                        child: TaskCard(
                          task: task,
                          isCompactMode: isCompact,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
