import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/data/models/task.dart';
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

  final Map<DateTime, GlobalKey> _taskKeys = {};

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _headerScrollController = ScrollController();
    _timelineScrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_headerScrollController.hasClients) {
        _jumpToToday();
      }
    });
  }

  void _scrollToFirstTask(DateTime date) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    final dayZero = DateTime(date.year, date.month, date.day);
    final dayEvents = taskProvider.allTasks
        .where((t) =>
            t.startTime.year == dayZero.year &&
            t.startTime.month == dayZero.month &&
            t.startTime.day == dayZero.day)
        .toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    if (dayEvents.isNotEmpty) {
      final key = _taskKeys[dayEvents.first.startTime];

      if (key?.currentContext != null) {
        Scrollable.ensureVisible(
          key!.currentContext!,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          alignment: 0.2,
        );
      }
    } else {
      if (_timelineScrollController.hasClients) {
        _timelineScrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    }
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
        child: Consumer<TaskProvider>(
          builder: (context, taskProvider, child) {
            if (taskProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                _scrollToFirstTask(_selectedDate);
              }
            });

            final events = taskProvider.allTasks
                .map((t) => TimelineEvent<Task>(
                      data: t,
                      start: t.startTime,
                      end: t.endTime,
                    ))
                .toList();

            _taskKeys.clear();
            return CustomScrollView(
              controller: _timelineScrollController,
              slivers: [
                SliverAppBar(
                  centerTitle: false,
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
                      label:
                          const Icon(Icons.add, color: Colors.black, size: 20),
                    ),
                  ],
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  title: const Text(
                    'Calendar',
                  ),
                  pinned: true,
                  backgroundColor: const Color.fromARGB(255, 95, 219, 250),
                  elevation: 0,
                  automaticallyImplyLeading: false,
                ),
                SliverAppBar(
                  pinned: true,
                  backgroundColor: const Color.fromARGB(255, 95, 219, 250),
                  elevation: 0,
                  toolbarHeight: 120,
                  automaticallyImplyLeading: false,
                  flexibleSpace: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: DateSelector(
                      selectedDate: _selectedDate,
                      onDateSelected: (date) {
                        setState(() {
                          _selectedDate = date;
                        });
                      },
                      scrollController: _headerScrollController,
                      totalTime: taskProvider.activeTasks.fold(
                        Duration.zero,
                        (sum, t) => sum + t.endTime.difference(t.startTime),
                      ),
                    ),
                  ),
                ),
                TimelineViewSliver<Task>(
                  selectedDate: _selectedDate,
                  events: events,
                  taskKeys: _taskKeys,
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
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
