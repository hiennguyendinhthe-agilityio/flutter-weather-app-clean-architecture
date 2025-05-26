import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/core/utils/duration_formatter.dart';
import 'package:task_management_app/data/models/task.dart';
import 'package:task_management_app/presentation/providers/task_provider.dart';

typedef TaskCallback = void Function(String taskId);
typedef TagCallback = void Function(String tag);
typedef TaskTagCallback = void Function(String taskId, String tag);

class TaskItem extends StatelessWidget {
  final Task task;

  final VoidCallback onToggleCompletion;
  final VoidCallback onStartTimer;
  final VoidCallback onStopTimer;
  final TagCallback? onRemoveTag;
  final VoidCallback? onEdit;

  const TaskItem({
    super.key,
    required this.task,
    required this.onToggleCompletion,
    required this.onStartTimer,
    required this.onStopTimer,
    required this.onRemoveTag,
    this.onEdit,
  });

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
                onPressed: (context) {
                  taskProvider.unarchiveTask(task.id);
                },
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                icon: Icons.unarchive,
                label: 'Unarchive',
              )
            else
              SlidableAction(
                onPressed: (context) {
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
              onPressed: (context) {
                if (onEdit != null) onEdit!();
              },
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
            SlidableAction(
              onPressed: (contextSA) {
                final taskProvider =
                    Provider.of<TaskProvider>(context, listen: false);

                showDialog(
                  context: contextSA,
                  builder: (BuildContext ctxDialog) {
                    return AlertDialog(
                      title: const Text('Confirm Delete'),
                      content: const Text(
                          'Are you sure you want to delete this task?'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            if (ctxDialog.mounted) {
                              Navigator.of(ctxDialog).pop();
                            }
                          },
                        ),
                        TextButton(
                          child: const Text('Delete'),
                          onPressed: () {
                            taskProvider.deleteTask(task.id);

                            if (ctxDialog.mounted) {
                              Navigator.of(ctxDialog).pop();
                            }
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
                color: Colors.black.withValues(alpha: 0.05),
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
                        color: _getColorFromName(task.projectColor),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        task.assignee.isNotEmpty ? task.assignee[0] : '',
                        style: TextStyle(
                          color: _getColorFromName(task.projectColor),
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
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                task.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  decoration: task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                  color: task.isCompleted
                                      ? Colors.grey
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _getColorFromName(task.projectColor),
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
                                onTap: () => onRemoveTag!(tag),
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
                    Row(
                      children: [
                        Text(
                          DurationFormatter.format(task.timeSpent),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (!task.isCompleted)
                          IconButton(
                            icon: Icon(
                              task.isActive ? Icons.pause : Icons.play_arrow,
                              color: _getColorFromName(task.projectColor),
                            ),
                            onPressed:
                                task.isActive ? onStopTimer : onStartTimer,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getColorFromName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'orange':
        return Colors.orange;
      case 'red':
        return Colors.red;
      case 'purple':
        return Colors.purple;
      case 'teal':
        return Colors.teal;
      case 'pink':
        return Colors.pink;
      case 'amber':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }
}
