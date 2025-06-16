import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/auth_provider.dart';
import '../providers/task_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/date_selector.dart';
import '../widgets/pomodoro_timer.dart';
import '../widgets/task_detail_dialog.dart';
import '../widgets/timeline_view.dart';

/// Main home screen with timeline view and controls
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showPomodoroTimer = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildTopControls(),
          Expanded(
            child: _buildMainContent(),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButtons(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'TeamTaskTimeline',
        style: GoogleFonts.roboto(
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return IconButton(
              icon: Icon(
                themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              ),
              onPressed: () => themeProvider.toggleTheme(),
              tooltip: 'Toggle theme',
            );
          },
        ),
        PopupMenuButton<String>(
          onSelected: _handleMenuSelection,
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'profile',
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text('Profile'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'settings',
              child: ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'logout',
              child: ListTile(
                leading: Icon(Icons.logout),
                title: Text('Sign Out'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTopControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const DateSelector(),
          const SizedBox(height: 16),
          _buildTeamSelector(),
        ],
      ),
    );
  }

  Widget _buildTeamSelector() {
    return Consumer2<AuthProvider, TaskProvider>(
      builder: (context, authProvider, taskProvider, child) {
        final teams = authProvider.teams;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).dividerColor,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String?>(
              value: taskProvider.selectedTeamId,
              isExpanded: true,
              hint: const Text('Select workspace'),
              items: [
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Row(
                    children: [
                      Icon(Icons.person),
                      SizedBox(width: 8),
                      Text('My Tasks'),
                    ],
                  ),
                ),
                ...teams.map((team) => DropdownMenuItem<String?>(
                      value: team.id,
                      child: Row(
                        children: [
                          const Icon(Icons.group),
                          const SizedBox(width: 8),
                          Text(team.name),
                        ],
                      ),
                    )),
              ],
              onChanged: (value) {
                taskProvider.setSelectedTeam(value);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainContent() {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        if (taskProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final isWideScreen = constraints.maxWidth > 800;

            if (isWideScreen) {
              return _buildWideScreenLayout();
            } else {
              return _buildNarrowScreenLayout();
            }
          },
        );
      },
    );
  }

  Widget _buildWideScreenLayout() {
    return Row(
      children: [
        const Expanded(
          flex: 2,
          child: TimelineView(),
        ),
        Container(
          width: 1,
          color: Theme.of(context).dividerColor,
        ),
        Expanded(
          flex: 1,
          child: _buildTaskList(),
        ),
      ],
    );
  }

  Widget _buildNarrowScreenLayout() {
    return const TimelineView();
  }

  Widget _buildTaskList() {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final tasks = taskProvider.filteredTasks;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Tasks (${tasks.length})',
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Icon(
                        task.status.icon,
                        color: task.status.color,
                      ),
                      title: Text(task.title),
                      subtitle: Text(
                        '${task.startTime.hour.toString().padLeft(2, '0')}:'
                        '${task.startTime.minute.toString().padLeft(2, '0')} - '
                        '${task.endTime.hour.toString().padLeft(2, '0')}:'
                        '${task.endTime.minute.toString().padLeft(2, '0')}',
                      ),
                      trailing: Container(
                        width: 4,
                        height: 40,
                        decoration: BoxDecoration(
                          color: task.priority.color,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      onTap: () => _showTaskDetail(task),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFloatingActionButtons() {
    return Stack(
      children: [
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            heroTag: 'add_task',
            onPressed: _showAddTaskDialog,
            child: const Icon(Icons.add),
          ),
        ),
        Positioned(
          bottom: 88,
          right: 16,
          child: FloatingActionButton(
            heroTag: 'pomodoro',
            mini: true,
            backgroundColor: Colors.red,
            onPressed: () {
              setState(() {
                _showPomodoroTimer = !_showPomodoroTimer;
              });
            },
            child: const Icon(
              Icons.timer,
              color: Colors.white,
            ),
          ),
        ),
        if (_showPomodoroTimer)
          Positioned(
            bottom: 160,
            right: 16,
            child: PomodoroTimer(
              onClose: () {
                setState(() {
                  _showPomodoroTimer = false;
                });
              },
            ),
          ),
      ],
    );
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'profile':
        _showProfileDialog();
        break;
      case 'settings':
        _showSettingsDialog();
        break;
      case 'logout':
        _handleLogout();
        break;
    }
  }

  void _showProfileDialog() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${user?.name ?? 'Unknown'}'),
            const SizedBox(height: 8),
            Text('Email: ${user?.email ?? 'Unknown'}'),
            const SizedBox(height: 8),
            Text('Teams: ${authProvider.teams.length}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Settings'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifications'),
              trailing: Switch(
                value: true,
                onChanged: null,
              ),
            ),
            ListTile(
              leading: Icon(Icons.sync),
              title: Text('Auto Sync'),
              trailing: Switch(
                value: true,
                onChanged: null,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Provider.of<AuthProvider>(context, listen: false).signOut();
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _showTaskDetail(Task task) {
    showDialog(
      context: context,
      builder: (context) => TaskDetailDialog(task: task),
    );
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => const TaskDetailDialog(),
    );
  }
}
