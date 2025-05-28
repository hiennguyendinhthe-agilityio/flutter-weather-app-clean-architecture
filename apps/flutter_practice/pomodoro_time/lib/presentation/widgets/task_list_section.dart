import 'package:flutter/material.dart';
import 'package:task_management_app/core/utils/duration_formatter.dart';
import 'package:task_management_app/data/models/task.dart';
import 'package:task_management_app/presentation/widgets/task_item.dart';

class TaskListSection extends StatelessWidget {
  final String title;
  final List<Task> tasks;
  final Duration totalTime;
  final String sectionKeyPrefix;
  final Function(String taskId) onToggleTaskCompletion;
  final Function(String taskId) onStartTaskTimer;
  final Function(String taskId) onStopTaskTimer;
  final void Function(String taskId, String tag)? onRemoveTag;
  final void Function(Task task)? onEditTask;
  final void Function(Task task)? onTap;

  const TaskListSection({
    super.key,
    required this.title,
    required this.tasks,
    required this.totalTime,
    required this.sectionKeyPrefix,
    required this.onToggleTaskCompletion,
    required this.onStartTaskTimer,
    required this.onStopTaskTimer,
    this.onRemoveTag,
    this.onEditTask,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              if (totalTime > Duration.zero)
                Text(
                  DurationFormatter.formatHoursMinutesSeconds(totalTime),
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ),
        ...tasks.map(
          (task) => GestureDetector(
            onTap: () => onTap?.call(task),
            child: TaskItem(
              key: ValueKey('$sectionKeyPrefix-${task.id}'),
              task: task,
              onToggleCompletion: () => onToggleTaskCompletion(task.id),
              onStartTimer: () => onStartTaskTimer(task.id),
              onStopTimer: () => onStopTaskTimer(task.id),
              onRemoveTag: onRemoveTag != null
                  ? (tag) => onRemoveTag!(task.id, tag)
                  : null,
              onEdit: onEditTask != null ? () => onEditTask!(task) : null,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
