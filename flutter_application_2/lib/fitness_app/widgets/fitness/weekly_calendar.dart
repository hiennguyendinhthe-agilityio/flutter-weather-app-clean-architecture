import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/text_styles.dart';

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
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    currentDayLabel,
                    style: FitnessTextStyles.calendarDay.copyWith(
                      color: isSelected
                          ? FitnessColors.textPrimary
                          : FitnessColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentDateNum,
                    style: isSelected
                        ? FitnessTextStyles.calendarDate.copyWith(
                            color: FitnessColors.textPrimary,
                          )
                        : FitnessTextStyles.calendarDate,
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
