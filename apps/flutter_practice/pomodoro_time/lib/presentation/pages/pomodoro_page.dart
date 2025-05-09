// lib/presentation/pages/pomodoro_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/presentation/blocs/pomodoro/pomodoro_bloc.dart';
import 'package:task_management_app/presentation/blocs/pomodoro/pomodoro_event.dart';
import 'package:task_management_app/presentation/blocs/pomodoro/pomodoro_state.dart';
import 'package:task_management_app/presentation/blocs/task/task_bloc.dart';
import 'package:task_management_app/presentation/blocs/task/task_state.dart';

class PomodoroPage extends StatelessWidget {
  const PomodoroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTimerDurationSelector(),
            Expanded(
              child: _buildPomodoroTimer(),
            ),
            _buildCurrentTask(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Pomodoro',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerDurationSelector() {
    return BlocBuilder<PomodoroBloc, PomodoroState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDurationButton(context, 5, state),
            _buildDurationButton(context, 10, state),
            _buildDurationButton(context, 20, state),
            _buildDurationButton(context, 25, state),
            _buildDurationButton(context, 30, state),
          ],
        );
      },
    );
  }

  Widget _buildDurationButton(
      BuildContext context, int minutes, PomodoroState state) {
    bool isSelected = false;

    if (state is PomodoroRunning) {
      isSelected = state.pomodoro.duration == minutes;
    } else if (state is PomodoroPaused) {
      isSelected = state.pomodoro.duration == minutes;
    } else if (state is PomodoroCompleted) {
      isSelected = state.pomodoro.duration == minutes;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        onPressed: () {
          context.read<PomodoroBloc>().add(SetPomodoroDurationEvent(minutes));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.blue : Colors.grey[200],
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

  Widget _buildPomodoroTimer() {
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
                    colors: [Colors.blue[300]!, Colors.blue[700]!],
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
                    style: const TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
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
                        ),
                      ] else if (state is PomodoroRunning) ...[
                        _buildControlButton(
                          context,
                          Icons.pause,
                          () => context
                              .read<PomodoroBloc>()
                              .add(PausePomodoroEvent()),
                        ),
                        const SizedBox(width: 20),
                        _buildControlButton(
                          context,
                          Icons.stop,
                          () => context
                              .read<PomodoroBloc>()
                              .add(StopPomodoroEvent()),
                        ),
                      ] else if (state is PomodoroPaused) ...[
                        _buildControlButton(
                          context,
                          Icons.play_arrow,
                          () => context
                              .read<PomodoroBloc>()
                              .add(ResumePomodoroEvent()),
                        ),
                        const SizedBox(width: 20),
                        _buildControlButton(
                          context,
                          Icons.stop,
                          () => context
                              .read<PomodoroBloc>()
                              .add(StopPomodoroEvent()),
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

  Widget _buildControlButton(
      BuildContext context, IconData icon, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(16),
      ),
      child: Icon(icon, size: 32),
    );
  }

  Widget _buildCurrentTask() {
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
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "I'm Focusing on",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currentTask.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // End now logic
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
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
