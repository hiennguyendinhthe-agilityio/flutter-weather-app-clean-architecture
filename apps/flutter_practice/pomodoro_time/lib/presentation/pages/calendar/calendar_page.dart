// ✅ Cleaned version of CalendarPage with optimized imports, formatting, and type safety
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/data/models/task.dart';
import 'package:task_management_app/presentation/pages/calendar/widgets/sticky_header_delegate.dart';
import 'package:task_management_app/presentation/pages/tasks/widgets/add_task_bottomsheet.dart';
import 'package:task_management_app/presentation/providers/task_provider.dart';
import 'package:task_management_app/presentation/widgets/common_gradient_background.dart';
import 'package:task_management_app/presentation/widgets/timeline/timeline_view.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _selectedDate;
  final List<GlobalKey> _hourKeys = List.generate(24, (_) => GlobalKey());

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

            final hasTask = tasksForSelectedDay.isNotEmpty;
            final firstHour =
                hasTask ? tasksForSelectedDay.first.startTime.hour : 0;

            return hasTask
                ? _buildTaskScrollLayout(
                    taskProvider, tasksForSelectedDay, firstHour)
                : _buildNormalScrollLayout(taskProvider);
          },
        ),
      ),
    );
  }

  Widget _buildNormalScrollLayout(TaskProvider provider) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        _buildAppBar(),
        _buildStickyHeader(provider),
        for (int hour = 0; hour < 24; hour++)
          SliverToBoxAdapter(
            key: _hourKeys[hour],
            child: TimelineViewSliver(
              hour: hour,
              tasks: const [],
            ),
          ),
      ],
    );
  }

  Widget _buildTaskScrollLayout(
      TaskProvider provider, List<Task> tasks, int firstHour) {
    final centerKey = _hourKeys[firstHour];
    final useAnchor = firstHour > 0;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      center: centerKey,
      anchor: useAnchor ? 0.4 : 0.0,
      slivers: [
        _buildAppBar(),
        if (useAnchor) const SliverToBoxAdapter(child: SizedBox(height: 16)),
        _buildStickyHeader(provider),
        for (int hour = 0; hour < 24; hour++)
          SliverToBoxAdapter(
            key: _hourKeys[hour],
            child: TimelineViewSliver(
              hour: hour,
              tasks: tasks.where((t) => t.startTime.hour == hour).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
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
