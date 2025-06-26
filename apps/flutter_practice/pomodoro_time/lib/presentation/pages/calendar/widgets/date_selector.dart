import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateSelectorHorizontalSliver extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final Duration totalTime;
  final int centerIndex;

  const DateSelectorHorizontalSliver({
    required this.selectedDate,
    required this.onDateSelected,
    required this.totalTime,
    required this.centerIndex,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    const totalDays = 61;
    final days =
        List.generate(totalDays, (i) => now.subtract(Duration(days: 30 - i)));

    return CustomScrollView(
      scrollDirection: Axis.horizontal,
      center: ValueKey('day-$centerIndex'),
      anchor: 0.5,
      slivers: [
        for (int i = 0; i < days.length; i++)
          SliverToBoxAdapter(
            key: ValueKey('day-$i'),
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => onDateSelected(days[i]),
                child: Container(
                  width: 60.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    border: _isSameDay(days[i], selectedDate)
                        ? Border.all(color: Colors.black, width: 2)
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('E').format(days[i])[0],
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        days[i].day.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
