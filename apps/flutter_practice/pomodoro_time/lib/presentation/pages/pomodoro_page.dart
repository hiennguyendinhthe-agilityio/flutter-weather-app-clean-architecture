import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/core/themes/pomodoro_color_theme.dart';
import 'package:task_management_app/data/models/settings.dart';
import 'package:task_management_app/presentation/blocs/pomodoro/pomodoro_bloc.dart';
import 'package:task_management_app/presentation/blocs/pomodoro/pomodoro_event.dart';
import 'package:task_management_app/presentation/blocs/pomodoro/pomodoro_state.dart';
import 'package:task_management_app/presentation/blocs/task/task_bloc.dart';
import 'package:task_management_app/presentation/blocs/task/task_event.dart';
import 'package:task_management_app/presentation/blocs/task/task_state.dart';
import 'package:task_management_app/presentation/widgets/settings_dialog.dart';

class PomodoroPage extends StatelessWidget {
  const PomodoroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PomodoroBloc, PomodoroState>(
      builder: (context, state) {
        int currentDuration = 25;

        if (state is PomodoroRunning) {
          currentDuration = state.pomodoro.duration;
        } else if (state is PomodoroPaused) {
          currentDuration = state.pomodoro.duration;
        } else if (state is PomodoroCompleted) {
          currentDuration = state.pomodoro.duration;
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
                          _buildTimerDurationSelector(themeColors),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: _buildPomodoroTimer(themeColors),
                          ),
                          _buildCurrentTask(themeColors),
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

// Chỉnh sửa _buildHeader trong lib/presentation/pages/pomodoro_page.dart

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

  Widget _buildTimerDurationSelector(PomodoroThemeColors themeColors) {
    return BlocBuilder<PomodoroBloc, PomodoroState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDurationButton(context, 5, state, themeColors),
                _buildDurationButton(context, 10, state, themeColors),
                _buildDurationButton(context, 20, state, themeColors),
                _buildDurationButton(context, 25, state, themeColors),
                _buildDurationButton(context, 30, state, themeColors),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDurationButton(BuildContext context, int minutes,
      PomodoroState state, PomodoroThemeColors themeColors) {
    bool isSelected = false;

    if (state is PomodoroRunning) {
      isSelected = state.pomodoro.duration == minutes;
    } else if (state is PomodoroPaused) {
      isSelected = state.pomodoro.duration == minutes;
    } else if (state is PomodoroCompleted) {
      isSelected = state.pomodoro.duration == minutes;
    }

    final buttonThemeColors = PomodoroColorTheme.getThemeColors(minutes);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        onPressed: () {
          context.read<PomodoroBloc>().add(SetPomodoroDurationEvent(minutes));
        },
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

  Widget _buildPomodoroTimer(PomodoroThemeColors themeColors) {
    return BlocBuilder<PomodoroBloc, PomodoroState>(
      builder: (context, state) {
        int remainingSeconds = 0;

        if (state is PomodoroRunning) {
          remainingSeconds = state.pomodoro.remainingTime;
        } else if (state is PomodoroPaused) {
          remainingSeconds = state.pomodoro.remainingTime;
        } else if (state is PomodoroCompleted) {
          remainingSeconds = 0;
        }

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
                      if (state is PomodoroInitial ||
                          state is PomodoroCompleted) ...[
                        _buildControlButton(
                          context,
                          Icons.play_arrow,
                          () => context
                              .read<PomodoroBloc>()
                              .add(StartPomodoroEvent()),
                          themeColors,
                        ),
                      ] else if (state is PomodoroRunning) ...[
                        _buildControlButton(
                          context,
                          Icons.pause,
                          () => context
                              .read<PomodoroBloc>()
                              .add(PausePomodoroEvent()),
                          themeColors,
                        ),
                        const SizedBox(width: 20),
                        _buildControlButton(
                          context,
                          Icons.stop,
                          () => context
                              .read<PomodoroBloc>()
                              .add(StopPomodoroEvent()),
                          themeColors,
                        ),
                      ] else if (state is PomodoroPaused) ...[
                        _buildControlButton(
                          context,
                          Icons.play_arrow,
                          () => context
                              .read<PomodoroBloc>()
                              .add(ResumePomodoroEvent()),
                          themeColors,
                        ),
                        const SizedBox(width: 20),
                        _buildControlButton(
                          context,
                          Icons.stop,
                          () => context
                              .read<PomodoroBloc>()
                              .add(StopPomodoroEvent()),
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
      },
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

  Widget _buildCurrentTask(PomodoroThemeColors themeColors) {
    return BlocBuilder<PomodoroBloc, PomodoroState>(
      builder: (context, pomodoroState) {
        return BlocBuilder<TaskBloc, TaskState>(
          builder: (context, taskState) {
            if (taskState is TasksLoaded) {
              final currentTask = taskState.activeTasks.isNotEmpty
                  ? taskState.activeTasks.first
                  : null;

              if (currentTask != null) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                        color: themeColors.primary.withOpacity(0.3),
                        width: 1.5),
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
                          context.read<TaskBloc>().add(
                                UpdateTaskEvent(
                                  currentTask.copyWith(
                                    isCompleted: true,
                                  ),
                                ),
                              );
                          context.read<PomodoroBloc>().add(StopPomodoroEvent());
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
            }
            return const SizedBox.shrink();
          },
        );
      },
    );
  }
}
