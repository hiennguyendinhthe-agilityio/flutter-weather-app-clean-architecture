import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/core/utils/duration_formatter.dart';
import 'package:task_management_app/data/models/task.dart';
import 'package:task_management_app/presentation/providers/task_provider.dart';

import '../../core/utils/task_utils.dart';

typedef TagCallback = void Function(String tag);

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onToggleCompletion;
  final VoidCallback onStartTimer;
  final VoidCallback onStopTimer;
  final TagCallback? onRemoveTag;
  final VoidCallback? onEdit;

  const TaskItem({
    Key? key,
    required this.task,
    required this.onToggleCompletion,
    required this.onStartTimer,
    required this.onStopTimer,
    this.onRemoveTag,
    this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Slidable(
        key: ValueKey(task.id),
        startActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            if (task.isArchived)
              SlidableAction(
                onPressed: (ctx) {
                  taskProvider.unarchiveTask(task.id);
                },
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                icon: Icons.unarchive,
                label: 'Unarchive',
              )
            else
              SlidableAction(
                onPressed: (ctx) {
                  taskProvider.archiveTask(task.id);
                },
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                icon: Icons.archive,
                label: 'Archive',
              ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: (ctx) {
                if (onEdit != null) onEdit!();
              },
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
            SlidableAction(
              onPressed: (ctx) {
                showDialog(
                  context: ctx,
                  builder: (dialogCtx) {
                    return AlertDialog(
                      title: const Text('Confirm Delete'),
                      content: const Text(
                          'Are you sure you want to delete this task?'),
                      actions: [
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            if (dialogCtx.mounted)
                              Navigator.of(dialogCtx).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('Delete'),
                          onPressed: () {
                            taskProvider.deleteTask(task.id);
                            if (dialogCtx.mounted)
                              Navigator.of(dialogCtx).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Container(
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: getColorFromName(task.projectColor),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        task.assignee.isNotEmpty ? task.assignee[0] : '',
                        style: TextStyle(
                          color: getColorFromName(task.projectColor),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color:
                                task.isCompleted ? Colors.grey : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: getColorFromName(task.projectColor),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${task.projectName} (${task.assignee})',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: task.tags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          children: [
                            Text(
                              tag,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[800],
                              ),
                            ),
                            if (!task.isCompleted && !task.isArchived) ...[
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () {
                                  if (onRemoveTag != null) onRemoveTag!(tag);
                                },
                                child: Icon(
                                  Icons.close,
                                  size: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  if (!task.isArchived)
                    Text(
                      DurationFormatter.format(
                        task.endTime.difference(task.startTime),
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
