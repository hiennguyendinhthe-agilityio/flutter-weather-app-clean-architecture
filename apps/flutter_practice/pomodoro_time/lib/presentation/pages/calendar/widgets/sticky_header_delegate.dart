import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_management_app/core/utils/duration_formatter.dart';
import 'package:task_management_app/presentation/pages/calendar/widgets/date_selector.dart';

class StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final Duration totalTime;
  final int centerIndex;

  StickyHeaderDelegate({
    required this.selectedDate,
    required this.onDateSelected,
    required this.totalTime,
    required this.centerIndex,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      elevation: overlapsContent ? 1 : 0,
      color: const Color.fromARGB(255, 95, 219, 250),
      child: Container(
        constraints: const BoxConstraints(minHeight: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('EEE, d/M/y').format(selectedDate),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  if (totalTime > Duration.zero)
                    Text(
                      DurationFormatter.format(totalTime),
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(
              height: 60,
              child: DateSelectorHorizontalSliver(
                selectedDate: selectedDate,
                onDateSelected: onDateSelected,
                totalTime: totalTime,
                centerIndex: centerIndex,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => 120;

  @override
  double get minExtent => 120;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
