import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/data/models/task.dart';
import 'package:task_management_app/presentation/pages/calendar/widgets/calendar_header.dart';
import 'package:task_management_app/presentation/pages/calendar/widgets/date_selector.dart';
import 'package:task_management_app/presentation/pages/calendar/widgets/task_card.dart';
import 'package:task_management_app/presentation/pages/tasks/widgets/add_task_bottomsheet.dart';
import 'package:task_management_app/presentation/pages/tasks/widgets/task_detail_dialog.dart';
import 'package:task_management_app/presentation/providers/task_provider.dart';
import 'package:task_management_app/presentation/widgets/common_gradient_background.dart';
import 'package:task_management_app/presentation/widgets/timeline/timeline_event.dart';
import 'package:task_management_app/presentation/widgets/timeline/timeline_view.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _selectedDate;
  late ScrollController _dateScrollController;
  late ScrollController _timelineScrollController;
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _dateScrollController = ScrollController();
    _timelineScrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasInitialized) {
        _centerDateSelectorOnToday();
        _scrollToCurrentTime();
        _hasInitialized = true;
      }
    });
  }

  void _centerDateSelectorOnToday() {
    const itemWidth = 68.0;
    const todayIndex = 30;
    final screenW = MediaQuery.of(context).size.width;
    final offset = todayIndex * itemWidth - (screenW - itemWidth) / 2;
    _dateScrollController.jumpTo(
      offset.clamp(0, _dateScrollController.position.maxScrollExtent),
    );
  }

  void _scrollToCurrentTime() {
    final now = TimeOfDay.now();
    final minutes = now.hour * 60 + now.minute;
    const hourH = 60.0;
    final target = minutes * (hourH / 60) - 100;
    _timelineScrollController.jumpTo(
      target.clamp(0, _timelineScrollController.position.maxScrollExtent),
    );
  }

  @override
  void dispose() {
    _dateScrollController.dispose();
    _timelineScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CommonGradientBackground(
        child: SafeArea(
          child: Consumer<TaskProvider>(
            builder: (ctx, provider, _) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              final dayTasks = provider.allTasks.where((t) {
                return t.startTime.year == _selectedDate.year &&
                    t.startTime.month == _selectedDate.month &&
                    t.startTime.day == _selectedDate.day;
              }).toList()
                ..sort((a, b) => a.startTime.compareTo(b.startTime));

              final events = dayTasks
                  .map((t) => TimelineEvent<Task>(
                        start: t.startTime,
                        end: t.endTime,
                        data: t,
                      ))
                  .toList();

              final totalTime = events.fold<Duration>(
                Duration.zero,
                (sum, e) => sum + e.end.difference(e.start),
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CalendarHeader(
                    onNewTaskPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => AddTaskBottomsheet(
                          onAddTask: provider.addTask,
                        ),
                      );
                    },
                  ),
                  DateSelector(
                    selectedDate: _selectedDate,
                    onDateSelected: (d) {
                      setState(() => _selectedDate = d);
                      if (d == DateTime.now()) {
                        _scrollToCurrentTime();
                      } else {
                        _timelineScrollController.jumpTo(0);
                      }
                    },
                    scrollController: _dateScrollController,
                    totalTime: totalTime,
                  ),
                  Expanded(
                    child: TimelineView<Task>(
                      events: events,
                      itemBuilder: (ctx, task, isCompact) => GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  TaskDetailDialog(task: task),
                            );
                          },
                          child:
                              TaskCard(task: task, isCompactMode: isCompact)),
                      scrollController: _timelineScrollController,
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
