// lib/presentation/widgets/current_task_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/core/themes/pomodoro_color_theme.dart';
import 'package:task_management_app/presentation/providers/pomodoro_provider.dart';
import 'package:task_management_app/presentation/providers/task_provider.dart';

class CurrentTaskCard extends StatelessWidget {
  final PomodoroThemeColors themeColors;

  const CurrentTaskCard({required this.themeColors, super.key});

  @override
  Widget build(BuildContext context) {
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
                  color: themeColors.primary.withValues(alpha: 0.3),
                  width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: themeColors.primary.withValues(alpha: 0.1),
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
                    color: themeColors.primary.withValues(alpha: 0.7),
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
                    final updatedTask = currentTask.copyWith(isCompleted: true);
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
