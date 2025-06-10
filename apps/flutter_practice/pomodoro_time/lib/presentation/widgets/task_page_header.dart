import 'package:flutter/material.dart';
import 'package:task_management_app/presentation/pages/calendar/calendar_page.dart';

class TaskPageHeader extends StatelessWidget {
  final int taskCount;
  final VoidCallback onAddTaskPressed;
  const TaskPageHeader({
    super.key,
    required this.taskCount,
    required this.onAddTaskPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$taskCount Task${taskCount == 1 ? '' : 's'}',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              IconButton(
                color: Theme.of(context).colorScheme.scrim,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CalendarPage(),
                      ));
                },
                icon: const Icon(
                  Icons.calendar_today_outlined,
                ),
              ),
              TextButton.icon(
                onPressed: onAddTaskPressed,
                icon: Icon(
                  Icons.add_circle_outline,
                  color: Theme.of(context).colorScheme.scrim,
                ),
                label: const Text('New Task'),
              )
            ],
          )
        ],
      ),
    );
  }
}
