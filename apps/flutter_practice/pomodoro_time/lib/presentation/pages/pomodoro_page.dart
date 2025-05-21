import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/core/themes/pomodoro_color_theme.dart';
import 'package:task_management_app/data/models/settings.dart';
import 'package:task_management_app/presentation/providers/pomodoro_provider.dart';
import 'package:task_management_app/presentation/providers/task_provider.dart';
import 'package:task_management_app/presentation/widgets/settings_dialog.dart';

class PomodoroPage extends StatelessWidget {
  const PomodoroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PomodoroProvider>(
      builder: (context, pomodoroProvider, child) {
        int currentDuration = 25;

        if (pomodoroProvider.isRunning ||
            pomodoroProvider.isPaused ||
            pomodoroProvider.isCompleted) {
          currentDuration = pomodoroProvider.duration;
        }

        final themeColors = PomodoroColorTheme.getThemeColors(currentDuration);

        return Scaffold(
          backgroundColor: themeColors.background,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          _buildHeader(context, themeColors),
                          _buildTimerDurationSelector(
                              context, pomodoroProvider, themeColors),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: _buildPomodoroTimer(
                              context,
                              pomodoroProvider,
                              themeColors,
                            ),
                          ),
                          _buildCurrentTask(
                              context, pomodoroProvider, themeColors),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, PomodoroThemeColors themeColors) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 48), // For balance
          Text(
            'Pomodoro',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: themeColors.primary,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.settings,
              color: themeColors.primary,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => SettingsDialog(
                  settings: const Settings(
                    darkMode: false,
                    customColors: false,
                    availableDurations: [5, 10, 20, 25, 30],
                  ),
                  onSettingsChanged: (Settings) {},
                  onAddDuration: (int) {},
                  onRemoveDuration: (int) {},
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimerDurationSelector(BuildContext context,
      PomodoroProvider pomodoroProviderm, PomodoroThemeColors themeColors) {
    return Consumer<PomodoroProvider>(
      builder: (context, pomodoroProvider, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDurationButton(context, 5, pomodoroProvider, themeColors),
                _buildDurationButton(
                    context, 10, pomodoroProvider, themeColors),
                _buildDurationButton(
                    context, 20, pomodoroProvider, themeColors),
                _buildDurationButton(
                    context, 25, pomodoroProvider, themeColors),
                _buildDurationButton(
                    context, 30, pomodoroProvider, themeColors),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDurationButton(BuildContext context, int minutes,
      PomodoroProvider pomodoroProvider, PomodoroThemeColors themeColors) {
    bool isSelected = false;

    if (pomodoroProvider.isRunning ||
        pomodoroProvider.isPaused ||
        pomodoroProvider.isCompleted) {
      isSelected = pomodoroProvider.duration == minutes;
    } else {
      isSelected = pomodoroProvider.duration == minutes;
    }

    final buttonThemeColors = PomodoroColorTheme.getThemeColors(minutes);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isSelected ? buttonThemeColors.primary : Colors.grey[200],
          foregroundColor: isSelected ? Colors.white : Colors.black,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(16),
        ),
        child: Text(
          '$minutes',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildPomodoroTimer(BuildContext context,
      PomodoroProvider pomodoroProvider, PomodoroThemeColors themeColors) {
    int remainingSeconds = pomodoroProvider.remainingTime;
    final minutes = (remainingSeconds / 60).floor();
    final seconds = remainingSeconds % 60;

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [themeColors.primary, themeColors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Container(
            width: 280,
            height: 280,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: themeColors.primary,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (pomodoroProvider.isInitial ||
                      pomodoroProvider.isCompleted) ...[
                    _buildControlButton(
                      context,
                      Icons.play_arrow,
                      () =>
                          Provider.of<PomodoroProvider>(context, listen: false)
                              .startPomodoro(),
                      themeColors,
                    ),
                  ] else if (pomodoroProvider.isRunning) ...[
                    _buildControlButton(
                      context,
                      Icons.pause,
                      () =>
                          Provider.of<PomodoroProvider>(context, listen: false)
                              .pausePomodoro(),
                      themeColors,
                    ),
                    const SizedBox(width: 20),
                    _buildControlButton(
                      context,
                      Icons.stop,
                      () =>
                          Provider.of<PomodoroProvider>(context, listen: false)
                              .stopPomodoro(),
                      themeColors,
                    ),
                  ] else if (pomodoroProvider.isPaused) ...[
                    _buildControlButton(
                      context,
                      Icons.play_arrow,
                      () =>
                          Provider.of<PomodoroProvider>(context, listen: false)
                              .resumePomodoro(),
                      themeColors,
                    ),
                    const SizedBox(width: 20),
                    _buildControlButton(
                      context,
                      Icons.stop,
                      () =>
                          Provider.of<PomodoroProvider>(context, listen: false)
                              .stopPomodoro(),
                      themeColors,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(BuildContext context, IconData icon,
      VoidCallback onPressed, PomodoroThemeColors themeColors) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: themeColors.primary,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(16),
      ),
      child: Icon(
        icon,
        size: 32,
        color: Colors.white,
      ),
    );
  }

  Widget _buildCurrentTask(BuildContext context,
      PomodoroProvider pomodoroProvider, PomodoroThemeColors themeColors) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final currentTask = taskProvider.activeTasks.isNotEmpty
            ? taskProvider.activeTasks.first
            : null;

        if (currentTask != null) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                  color: themeColors.primary.withOpacity(0.3), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: themeColors.primary.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "I'm Focusing on",
                  style: TextStyle(
                    fontSize: 12,
                    color: themeColors.primary.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  currentTask.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: themeColors.primary,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final updatedTask = currentTask.copyWith(
                      isCompleted: true,
                    );
                    Provider.of<TaskProvider>(context, listen: false)
                        .updateTask(updatedTask);
                    Provider.of<PomodoroProvider>(context, listen: false)
                        .stopPomodoro();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('End Now'),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
