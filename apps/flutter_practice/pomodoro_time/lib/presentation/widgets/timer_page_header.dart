import 'package:flutter/material.dart';

class TimerPageHeader extends StatelessWidget {
  final int taskCount;
  final VoidCallback onAddTaskPressed;
  const TimerPageHeader({
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
              Icon(Icons.calendar_today_outlined,
                  color: Theme.of(context).colorScheme.scrim),
              TextButton.icon(
                onPressed: onAddTaskPressed,
                icon: Icon(
                  Icons.add_circle_outline,
                  color: Theme.of(context).colorScheme.scrim,
                ),
                label: const Text('New Task'),
                style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.scrim,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
              )
            ],
          )
        ],
      ),
    );
  }
}
