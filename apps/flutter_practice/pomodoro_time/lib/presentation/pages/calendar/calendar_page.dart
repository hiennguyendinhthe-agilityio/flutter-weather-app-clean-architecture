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
  late DateTime _selectedDate;
  final GlobalKey _firstTaskSliverKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  void _showAddTaskBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      builder: (ctx) => AddTaskBottomsheet(
        onAddTask: (task) {
          Provider.of<TaskProvider>(ctx, listen: false).addTask(task);
        },
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

            final dayStart = DateTime(
              _selectedDate.year,
              _selectedDate.month,
              _selectedDate.day,
            );
            final dayEnd = dayStart.add(const Duration(days: 1));

            final tasksForSelectedDay = taskProvider.allTasks
                .where((task) =>
                    !task.startTime.isBefore(dayStart) &&
                    task.startTime.isBefore(dayEnd))
                .toList()
              ..sort((a, b) => a.startTime.compareTo(b.startTime));

            final bool hasTasks = tasksForSelectedDay.isNotEmpty;

            final List<Widget> slivers;

            if (!hasTasks) {
              slivers = [
                _buildStickyHeader(taskProvider),
                const SliverToBoxAdapter(
                  child: TimelineHourItem(
                    startHour: 0,
                    endHour: 24,
                    tasks: [],
                  ),
                ),
              ];
            } else {
              final firstTask = tasksForSelectedDay.first;

              final firstTaskHour = firstTask.startTime.hour;

              slivers = [_buildStickyHeader(taskProvider)];

              if (firstTaskHour > 0) {
                slivers.add(SliverToBoxAdapter(
                  child: TimelineHourItem(
                    startHour: 0,
                    endHour: firstTaskHour,
                    tasks: const [],
                  ),
                ));
              }

              slivers.add(SliverToBoxAdapter(
                key: _firstTaskSliverKey,
                child: TimelineHourItem(
                  startHour: firstTaskHour,
                  endHour: 24,
                  tasks: tasksForSelectedDay,
                ),
              ));
            }

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              center: hasTasks ? _firstTaskSliverKey : null,
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
        selectedDate: _selectedDate,
        onDateSelected: (date) => setState(() => _selectedDate = date),
        totalTime: provider.activeTasks.fold(
          Duration.zero,
          (sum, t) => sum + t.endTime.difference(t.startTime),
        ),
        centerIndex: 30,
      ),
    );
  }
}
