import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/core/themes/pomodoro_color_theme.dart';
import 'package:task_management_app/presentation/pages/tasks/widgets/task_selection.dart';
import 'package:task_management_app/presentation/providers/pomodoro_provider.dart';
import 'package:task_management_app/presentation/providers/task_provider.dart';

class CurrentTaskCard extends StatelessWidget {
  final PomodoroThemeColors themeColors;

  const CurrentTaskCard({required this.themeColors, super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final selectedTask = taskProvider.selectedTask;
        final runningTask = taskProvider.runningTask;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "I'm Focusing on",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    selectedTask?.title ?? 'No task selected',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: themeColors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.7,
                        ),
                        isScrollControlled: true,
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        builder: (context) => const TaskSelection(),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: 160,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {
                      if (runningTask != null) {
                        final updatedTask =
                            runningTask.copyWith(isCompleted: true);
                        Provider.of<TaskProvider>(context, listen: false)
                            .updateTask(updatedTask);
                        Provider.of<PomodoroProvider>(context, listen: false)
                            .stopPomodoro();
                      }
                    },
                    child: const Center(
                      child: Text(
                        'End Now',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
