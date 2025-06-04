import 'package:flutter/material.dart';
import 'package:task_management_app/data/models/task.dart';
import 'package:task_management_app/presentation/pages/calendar_page/widgets/task_detail_dialog.dart';

import 'task_card.dart';

class TimelineView extends StatelessWidget {
  final DateTime selectedDate;
  final List<Task> tasks;
  final ScrollController timelineScrollController;

  const TimelineView({
    required this.selectedDate,
    required this.tasks,
    required this.timelineScrollController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filteredTasks = tasks.where((task) {
      final taskDate = DateTime(
        task.startTime.year,
        task.startTime.month,
        task.startTime.day,
      );
      final selDate = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
      );
      return taskDate.isAtSameMomentAs(selDate);
    }).toList();
    const double hourHeight = 60;
    const totalHours = 24;
    const timelineHeight = totalHours * hourHeight;

    return SingleChildScrollView(
      controller: timelineScrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: SizedBox(
        height: timelineHeight,
        child: Stack(
          children: [
            ...List.generate(totalHours + 1, (index) {
              final hour = index;
              return Positioned(
                top: index * hourHeight - 4,
                left: 0,
                right: 0,
                child: Row(
                  children: [
                    SizedBox(
                      width: 60,
                      child: Text(
                        '${hour.toString().padLeft(2, '0')}:00',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: Colors.grey[300], thickness: 1),
                    ),
                  ],
                ),
              );
            }),
            ...filteredTasks.map((task) {
              final startMinutes =
                  task.startTime.hour * 60 + task.startTime.minute;
              final endMinutes = task.endTime.hour * 60 + task.endTime.minute;
              final top = startMinutes * (hourHeight / 60);
              final calculatedHeight =
                  (endMinutes - startMinutes) * (hourHeight / 60);

              const minHeight = 80.0;
              const maxHeight = double.infinity;
              final height = calculatedHeight < minHeight
                  ? minHeight
                  : (calculatedHeight > maxHeight
                      ? maxHeight
                      : calculatedHeight);

              return Positioned(
                top: top,
                left: 68,
                right: 0,
                height: height,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => TaskDetailDialog(task: task),
                    );
                  },
                  child: TaskCard(
                      task: task, isCompactMode: calculatedHeight < minHeight),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
