import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/data/models/task.dart';
import 'package:task_management_app/presentation/pages/tasks/widgets/add_task_bottomsheet.dart';
import 'package:task_management_app/presentation/pages/tasks/widgets/task_detail_dialog.dart';
import 'package:task_management_app/presentation/pages/tasks/widgets/task_item.dart';
import 'package:task_management_app/presentation/pages/tasks/widgets/task_list_section.dart';
import 'package:task_management_app/presentation/pages/tasks/widgets/task_page_header.dart';
import 'package:task_management_app/presentation/providers/task_provider.dart';
import 'package:task_management_app/presentation/widgets/common_gradient_background.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAddTaskBottomSheet() {
    showModalBottomSheet(
      useRootNavigator: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddTaskBottomsheet(
        onAddTask: (task) {
          context.read<TaskProvider>().addTask(task);
        },
      ),
    );
  }

  void _showEditTaskBottomSheet(Task task) {
    showModalBottomSheet(
      useRootNavigator: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddTaskBottomsheet(
        selectedDate: task.startTime,
        taskToEdit: task,
        onAddTask: (_) {},
        onUpdateTask: (updatedTask) {
          context.read<TaskProvider>().updateTask(updatedTask);
        },
      ),
    );
  }

  void _removeTagFromTask(String taskId, String tag) async {
    final taskProvider = context.read<TaskProvider>();
    final task = taskProvider.allTasks.firstWhere((t) => t.id == taskId);
    final updatedTags = List<String>.from(task.tags)..remove(tag);
    final updatedTask = task.copyWith(tags: updatedTags);
    await taskProvider.updateTask(updatedTask);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CommonGradientBackground(
        child: SafeArea(
          child: Consumer<TaskProvider>(
            builder: (context, taskProvider, _) {
              if (taskProvider.errorMessage != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(taskProvider.errorMessage!),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                        action: SnackBarAction(
                          label: 'Dismiss',
                          onPressed: taskProvider.clearError,
                        ),
                      ),
                    );
                });
              }

              if (taskProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return _buildLoadedUI(taskProvider);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoadedUI(TaskProvider taskProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TaskPageHeader(
          taskCount: taskProvider.allTasks.length,
          onAddTaskPressed: _showAddTaskBottomSheet,
        ),
        _buildTabBar(taskProvider),
        const SizedBox(height: 16),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildActiveTasksView(taskProvider),
              _buildArchivedTasksView(taskProvider),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar(TaskProvider taskProvider) {
    return Container(
      height: 45,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color:
            Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(50),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TabBar(
        dividerColor: Colors.transparent,
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: const EdgeInsets.all(4),
        indicator: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25),
              blurRadius: 3,
              offset: const Offset(0, 1),
            )
          ],
        ),
        labelColor: Theme.of(context).colorScheme.primary,
        unselectedLabelColor:
            Theme.of(context).textTheme.bodyMedium?.color?.withAlpha(180),
        splashBorderRadius: BorderRadius.circular(8),
        tabs: [
          Tab(text: '${taskProvider.activeTasks.length} Active'),
          Tab(text: '${taskProvider.archivedTasks.length} Archive'),
        ],
      ),
    );
  }

  Widget _buildActiveTasksView(TaskProvider taskProvider) {
    if (taskProvider.tasksForActiveTab.isEmpty) {
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

    void toggleTask(String taskId) {
      context.read<TaskProvider>().toggleTaskCompletion(taskId);
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final todayTasks = taskProvider.todayTasksList;
    final yesterdayTasks = taskProvider.yesterdayTasksList;

    final upcomingTasks = taskProvider.tasksForActiveTab.where((task) {
      final taskDay = DateTime(
          task.startTime.year, task.startTime.month, task.startTime.day);
      return taskDay.isAfter(today);
    }).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    final olderTasks = taskProvider.tasksForActiveTab.where((task) {
      final taskDay = DateTime(
          task.startTime.year, task.startTime.month, task.startTime.day);
      return taskDay.isBefore(yesterday);
    }).toList()
      ..sort((a, b) => b.startTime.compareTo(a.startTime));

    Duration sumTime(List<Task> tasks) => tasks.fold(
        Duration.zero, (sum, t) => sum + t.endTime.difference(t.startTime));

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      children: [
        if (todayTasks.isNotEmpty)
          TaskListSection(
            onTap: (task) => _showTaskDialog(task),
            title: 'Today',
            tasks: todayTasks,
            totalTime: sumTime(todayTasks),
            sectionKeyPrefix: 'active-today',
            onToggleTaskCompletion: toggleTask,
            onRemoveTag: _removeTagFromTask,
            onEditTask: _showEditTaskBottomSheet,
          ),
        if (yesterdayTasks.isNotEmpty)
          TaskListSection(
            title: 'Yesterday',
            tasks: yesterdayTasks,
            totalTime: sumTime(yesterdayTasks),
            sectionKeyPrefix: 'active-yesterday',
            onToggleTaskCompletion: toggleTask,
            onRemoveTag: _removeTagFromTask,
            onEditTask: _showEditTaskBottomSheet,
            onTap: _showTaskDialog,
          ),
        if (upcomingTasks.isNotEmpty)
          TaskListSection(
            title: 'Upcoming',
            tasks: upcomingTasks,
            totalTime: sumTime(upcomingTasks),
            sectionKeyPrefix: 'active-upcoming',
            onTap: _showTaskDialog,
            onToggleTaskCompletion: toggleTask,
            onRemoveTag: _removeTagFromTask,
            onEditTask: _showEditTaskBottomSheet,
          ),
        if (olderTasks.isNotEmpty)
          TaskListSection(
            title: 'Older',
            tasks: olderTasks,
            totalTime: sumTime(olderTasks),
            sectionKeyPrefix: 'active-older',
            onTap: _showTaskDialog,
            onToggleTaskCompletion: toggleTask,
            onRemoveTag: _removeTagFromTask,
            onEditTask: _showEditTaskBottomSheet,
          ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildArchivedTasksView(TaskProvider taskProvider) {
    if (taskProvider.archivedTasks.isEmpty) {
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

    final sorted = List<Task>.from(taskProvider.archivedTasks)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      children: sorted
          .map((task) => TaskItem(
                key: ValueKey('archive-${task.id}'),
                task: task,
                onToggleCompletion: () {},
                onRemoveTag: (tag) => _removeTagFromTask(task.id, tag),
              ))
          .toList(),
    );
  }

  void _showTaskDialog(Task task) {
    showDialog(
      context: context,
      builder: (context) => TaskDetailDialog(task: task),
    );
  }
}
