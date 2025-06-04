import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/presentation/pages/calendar_page/widgets/date_selector.dart';
import 'package:task_management_app/presentation/pages/calendar_page/widgets/task_header.dart';
import 'package:task_management_app/presentation/pages/calendar_page/widgets/timeline_view.dart';
import 'package:task_management_app/presentation/widgets/add_task_bottomsheet.dart';
import 'package:task_management_app/presentation/widgets/common_gradient_background.dart';

import '../../providers/task_provider.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _selectedDate;
  late ScrollController _scrollController;
  bool _hasScrolledToSelectedDate = false;

  late ScrollController _timelineScrollController;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _scrollController = ScrollController();
    _timelineScrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasScrolledToSelectedDate && _scrollController.hasClients) {
        _jumpToToday();
        _scrollToCurrentTime();
        _hasScrolledToSelectedDate = true;
      }
    });
  }

  void _scrollToCurrentTime() {
    final now = TimeOfDay.now();
    final minutesFromStart = (now.hour) * 60 + now.minute;
    const hourHeight = 60.0;
    final offset = minutesFromStart * (hourHeight / 60) - 100;
    if (_timelineScrollController.hasClients) {
      _timelineScrollController.jumpTo(offset.clamp(
          0.0, _timelineScrollController.position.maxScrollExtent));
    }
  }

  void _jumpToToday() {
    const itemWidth = 60.0 + 8.0;
    const todayIndex = 30;

    final offset = todayIndex * itemWidth -
        (MediaQuery.of(context).size.width / 2) +
        (itemWidth / 2);

    _scrollController
        .jumpTo(offset.clamp(0.0, _scrollController.position.maxScrollExtent));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _timelineScrollController.dispose();
    super.dispose();
  }

  void _showAddTaskBottomSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => AddTaskBottomsheet(onAddTask: (task) {
              Provider.of<TaskProvider>(context, listen: false).addTask(task);
            }));
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
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TaskHeader(onNewTaskPressed: _showAddTaskBottomSheet),
                    DateSelector(
                      selectedDate: _selectedDate,
                      onDateSelected: (date) {
                        setState(() {
                          _selectedDate = date;
                        });
                        if (_timelineScrollController.hasClients) {
                          if (date == DateTime.now()) {
                            _scrollToCurrentTime();
                          } else {
                            _timelineScrollController.jumpTo(0);
                          }
                        }
                      },
                      scrollController: _scrollController,
                    ),
                    Expanded(
                      child: TimelineView(
                        selectedDate: _selectedDate,
                        tasks: taskProvider.allTasks,
                        timelineScrollController: _timelineScrollController,
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
