import 'package:flutter/material.dart';
import 'package:task_management_app/data/models/task.dart';
import 'package:task_management_app/presentation/pages/calendar/widgets/task_card.dart';
import 'package:task_management_app/presentation/pages/tasks/widgets/task_detail_dialog.dart';

const double hourHeight = 80.0;

class TimelineViewSliver extends StatelessWidget {
  final int hour;
  final List<Task> tasks;

  const TimelineViewSliver({
    Key? key,
    required this.hour,
    required this.tasks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: hourHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 80,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 4),
                  child: Text(
                    '${hour.toString().padLeft(2, '0')}:00',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  color: Colors.grey[300],
                  margin: const EdgeInsets.only(top: 12),
                ),
              ),
            ],
          ),
          ...tasks.map((task) => _buildTaskCard(context, task)).toList(),
        ],
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, Task task) {
    final topOffset = (task.startTime.minute / 60.0) * hourHeight;

    final durationInHours =
        task.endTime.difference(task.startTime).inMinutes / 60.0;
    final cardHeight = durationInHours * hourHeight;

    return Positioned(
      left: 80,
      top: topOffset,
      right: 16,
      height: cardHeight,
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => TaskDetailDialog(task: task),
          );
        },
        child: TaskCard(task: task),
      ),
    );
  }
}
