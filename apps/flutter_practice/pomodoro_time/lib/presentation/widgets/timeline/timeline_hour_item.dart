import 'package:flutter/material.dart';
import 'package:task_management_app/data/models/task.dart';
import 'package:task_management_app/presentation/pages/calendar/widgets/task_card.dart';
import 'package:task_management_app/presentation/pages/tasks/widgets/task_detail_dialog.dart';

const double hourHeight = 80.0;

class TimelineHourItem extends StatelessWidget {
  final int startHour;
  final int endHour;
  final List<Task> tasks;

  const TimelineHourItem({
    Key? key,
    required this.startHour,
    required this.endHour,
    required this.tasks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalHours = endHour - startHour;
    final totalHeight = totalHours * hourHeight;

    return SizedBox(
      height: totalHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Hour markers and grid lines
          ...List.generate(totalHours, (index) {
            final hour = startHour + index;
            final topOffset = index * hourHeight;

            return Positioned(
              left: 0,
              right: 0,
              top: topOffset,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 80,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, top: 4),
                      child: Text(
                        '${hour.toString().padLeft(2, '0')}:00',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
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
            );
          }),

          // Group overlapping tasks and layout side-by-side
          ..._buildGroupedTaskCards(context),
        ],
      ),
    );
  }

  List<Widget> _buildGroupedTaskCards(BuildContext context) {
    final List<Widget> positionedCards = [];
    final List<List<Task>> overlapGroups = _groupOverlappingTasks(tasks);

    for (final group in overlapGroups) {
      final double taskWidthFactor = 1.0 / group.length;

      for (int i = 0; i < group.length; i++) {
        final task = group[i];
        final topOffset = _calculateTopOffset(task);
        final cardHeight = _calculateCardHeight(task);
        final leftOffset = 80.0 +
            (i * taskWidthFactor * (MediaQuery.of(context).size.width - 96));
        final cardWidth =
            taskWidthFactor * (MediaQuery.of(context).size.width - 96);

        positionedCards.add(
          Positioned(
            top: topOffset,
            left: leftOffset,
            width: cardWidth,
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
          ),
        );
      }
    }

    return positionedCards;
  }

  List<List<Task>> _groupOverlappingTasks(List<Task> inputTasks) {
    List<Task> sorted = [...inputTasks]
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
    List<List<Task>> groups = [];

    for (final task in sorted) {
      bool placed = false;
      for (final group in groups) {
        if (group.any((t) => _tasksOverlap(task, t))) {
          group.add(task);
          placed = true;
          break;
        }
      }
      if (!placed) {
        groups.add([task]);
      }
    }
    return groups;
  }

  bool _tasksOverlap(Task a, Task b) {
    return !(a.endTime.isBefore(b.startTime) || a.startTime.isAfter(b.endTime));
  }

  double _calculateTopOffset(Task task) {
    final taskStartHour = task.startTime.hour;
    final taskStartMinute = task.startTime.minute;
    final hoursFromStart = taskStartHour - startHour;
    return (hoursFromStart * hourHeight) +
        (taskStartMinute / 60.0) * hourHeight;
  }

  double _calculateCardHeight(Task task) {
    final durationInHours =
        task.endTime.difference(task.startTime).inMinutes / 60.0;
    return durationInHours * hourHeight;
  }
}
