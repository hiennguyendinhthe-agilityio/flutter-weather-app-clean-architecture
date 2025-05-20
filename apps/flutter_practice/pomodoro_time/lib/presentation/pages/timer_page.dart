import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/data/models/task.dart';
import 'package:task_management_app/presentation/blocs/task/task_bloc.dart';
import 'package:task_management_app/presentation/blocs/task/task_event.dart';
import 'package:task_management_app/presentation/blocs/task/task_state.dart';
import 'package:task_management_app/presentation/widgets/add_task_dialog.dart';
import 'package:task_management_app/presentation/widgets/task_item.dart';
import 'package:task_management_app/presentation/widgets/task_list_section.dart';
import 'package:task_management_app/presentation/widgets/timer_page_header.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    context.read<TaskBloc>().add(LoadTasksEvent());
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: BlocProvider.of<TaskBloc>(context),
        child: AddTaskDialog(
          onAddTask: (task) {
            context.read<TaskBloc>().add(AddTaskEvent(task));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: BlocConsumer<TaskBloc, TaskState>(
          listener: (context, state) {
            if (state is TaskError) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
            }
          },
          builder: (context, state) {
            if (state is TasksLoaded) {
              return _buildLoadedUI(state);
            } else if (state is TaskLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoadedUI(TasksLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TimerPageHeader(
          taskCount: state.allTasks.length,
          onAddTaskPressed: _showAddTaskDialog,
        ),
        _buildTabBar(state),
        const SizedBox(height: 16),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildActiveTasksView(state),
              _buildArchivedTasksView(state),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar(TasksLoaded state) {
    return Container(
      height: 45,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: const EdgeInsets.all(4),
        indicator: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 3,
              offset: const Offset(0, 1),
            )
          ],
        ),
        labelColor: Theme.of(context).colorScheme.primary,
        unselectedLabelColor: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.color
            ?.withValues(alpha: 0.7),
        splashBorderRadius: BorderRadius.circular(8),
        tabs: [
          Tab(text: '${state.activeTasks.length} Active'),
          Tab(text: '${state.archivedTasks.length} Archive'),
        ],
      ),
    );
  }

  Widget _buildActiveTasksView(TasksLoaded state) {
    if (state.tasksForActiveTab.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            'All tasks done or archived!\nAdd a new task to keep going.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    final todayTasks = state.todayTasksList;
    final yesterdayTasks = state.yesterdayTasksList;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final otherTasks = state.tasksForActiveTab.where((task) {
      final taskDay = DateTime(
          task.createdAt.year, task.createdAt.month, task.createdAt.day);
      return !taskDay.isAtSameMomentAs(today) &&
          !taskDay.isAtSameMomentAs(yesterday);
    }).toList();

    otherTasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    void toggleTask(String taskId) {
      context.read<TaskBloc>().add(ToggleTaskCompletionEvent(taskId));
    }

    void startTimer(String taskId) {
      context.read<TaskBloc>().add(StartTaskTimerEvent(taskId));
    }

    void stopTimer(String taskId) {
      context.read<TaskBloc>().add(StopTaskTimerEvent(taskId));
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      children: [
        TaskListSection(
          title: 'Today',
          tasks: todayTasks,
          totalTime: todayTasks.fold(
              Duration.zero, (prev, task) => prev + task.timeSpent),
          sectionKeyPrefix: 'active-today',
          onToggleTaskCompletion: toggleTask,
          onStartTaskTimer: startTimer,
          onStopTaskTimer: stopTimer,
        ),
        TaskListSection(
          title: 'Yesterday',
          tasks: yesterdayTasks,
          totalTime: yesterdayTasks.fold(
              Duration.zero, (prev, task) => prev + task.timeSpent),
          sectionKeyPrefix: 'active-yesterday',
          onToggleTaskCompletion: toggleTask,
          onStartTaskTimer: startTimer,
          onStopTaskTimer: stopTimer,
        ),
        TaskListSection(
          title: 'Older / Upcoming',
          tasks: otherTasks,
          totalTime: otherTasks.fold(
              Duration.zero, (prev, task) => prev + task.timeSpent),
          sectionKeyPrefix: 'active-other',
          onToggleTaskCompletion: toggleTask,
          onStartTaskTimer: startTimer,
          onStopTaskTimer: stopTimer,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildArchivedTasksView(TasksLoaded state) {
    if (state.archivedTasks.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            'No archived tasks.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    final sortedArchivedTasks = List<Task>.from(state.archivedTasks)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      children: sortedArchivedTasks
          .map((task) => TaskItem(
                key: ValueKey('archive-${task.id}'),
                task: task,
                onToggleCompletion: () {/* No action */},
                onStartTimer: () {/* No action */},
                onStopTimer: () {/* No action */},
              ))
          .toList(),
    );
  }
}
