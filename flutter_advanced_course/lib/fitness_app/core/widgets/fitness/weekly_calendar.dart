import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/theme_context_ext.dart';

class WeeklyCalendar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDaySelected;

  final DateTime? startDate;

  const WeeklyCalendar({
    super.key,
    required this.selectedIndex,
    required this.onDaySelected,
    this.startDate,
  });

  static const List<String> _daysOfWeek = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = context.weeklyCalendarTheme;
    final baseDate = startDate ?? DateTime(2024, 4, 15);
    final currentDates = List.generate(
      7,
      (index) => baseDate.add(Duration(days: index)),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (index) {
          final isSelected = selectedIndex == index;
          final currentDayLabel = _daysOfWeek[currentDates[index].weekday - 1];
          final currentDateNum = currentDates[index].day.toString();

          return GestureDetector(
            onTap: () => onDaySelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(
                vertical: 14.0,
                horizontal: 12.0,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.selectedBackgroundColor ??
                          Colors.white.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    currentDayLabel,
                    style:
                        theme.dayTextStyle?.copyWith(
                          color: isSelected
                              ? theme.todayIndicatorColor
                              : theme.dayTextStyle?.color,
                        ) ??
                        TextStyle(
                          color: isSelected ? Colors.white : Colors.white54,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentDateNum,
                    style: isSelected
                        ? theme.selectedDateTextStyle
                        : theme.dateTextStyle,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
