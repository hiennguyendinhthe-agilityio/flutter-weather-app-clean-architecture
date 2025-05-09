// lib/presentation/pages/task_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/presentation/blocs/task/task_bloc.dart';
import 'package:task_management_app/presentation/blocs/task/task_event.dart';
import 'package:task_management_app/presentation/blocs/task/task_state.dart';
import 'package:task_management_app/presentation/widgets/add_task_dialog.dart';
import 'package:task_management_app/presentation/widgets/task_item.dart';

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

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => AddTaskDialog(
        onAddTask: (task) {
          context.read<TaskBloc>().add(AddTaskEvent(task));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            if (state is TaskLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TasksLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${state.tasks.length} Tasks',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.calendar_today),
                              onPressed: () {},
                            ),
                            TextButton.icon(
                              icon: const Icon(Icons.add),
                              label: const Text('New Task'),
                              onPressed: _showAddTaskDialog,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TabBar(
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorPadding: const EdgeInsets.all(4),
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(text: '${state.activeTasks.length} Active'),
                        Tab(text: '${state.archivedTasks.length} Archive'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildTaskList(state),
                        _buildArchivedTaskList(state),
                      ],
                    ),
                  ),
                ],
              );
            } else if (state is TaskError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('No tasks found'));
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskList(TasksLoaded state) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: [
        if (state.todayTasks.isNotEmpty) ...[
          _buildSectionHeader(
              'Today',
              state.todayTasks.fold(
                Duration.zero,
                (prev, task) => prev + task.timeSpent,
              )),
          ...state.todayTasks.map((task) => TaskItem(
                task: task,
                onToggleCompletion: () {
                  context
                      .read<TaskBloc>()
                      .add(ToggleTaskCompletionEvent(task.id));
                },
                onDelete: () {
                  context.read<TaskBloc>().add(DeleteTaskEvent(task.id));
                },
                onStartTimer: () {
                  context.read<TaskBloc>().add(StartTaskTimerEvent(task.id));
                },
                onStopTimer: () {
                  context.read<TaskBloc>().add(StopTaskTimerEvent(task.id));
                },
              )),
        ],
        if (state.yesterdayTasks.isNotEmpty) ...[
          _buildSectionHeader(
              'Yesterday',
              state.yesterdayTasks.fold(
                Duration.zero,
                (prev, task) => prev + task.timeSpent,
              )),
          ...state.yesterdayTasks.map((task) => TaskItem(
                task: task,
                onToggleCompletion: () {
                  context
                      .read<TaskBloc>()
                      .add(ToggleTaskCompletionEvent(task.id));
                },
                onDelete: () {
                  context.read<TaskBloc>().add(DeleteTaskEvent(task.id));
                },
                onStartTimer: () {
                  context.read<TaskBloc>().add(StartTaskTimerEvent(task.id));
                },
                onStopTimer: () {
                  context.read<TaskBloc>().add(StopTaskTimerEvent(task.id));
                },
              )),
        ],
      ],
    );
  }

  Widget _buildArchivedTaskList(TasksLoaded state) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: state.archivedTasks
          .map((task) => TaskItem(
                task: task,
                onToggleCompletion: () {
                  context
                      .read<TaskBloc>()
                      .add(ToggleTaskCompletionEvent(task.id));
                },
                onDelete: () {
                  context.read<TaskBloc>().add(DeleteTaskEvent(task.id));
                },
                onStartTimer: () {
                  context.read<TaskBloc>().add(StartTaskTimerEvent(task.id));
                },
                onStopTimer: () {
                  context.read<TaskBloc>().add(StopTaskTimerEvent(task.id));
                },
              ))
          .toList(),
    );
  }

  Widget _buildSectionHeader(String title, Duration totalTime) {
    final hours = totalTime.inHours;
    final minutes = totalTime.inMinutes.remainder(60);
    final seconds = totalTime.inSeconds.remainder(60);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
