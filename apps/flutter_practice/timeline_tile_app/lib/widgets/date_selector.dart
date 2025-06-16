import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile_app/services/timeline_service.dart';

/// Horizontal scrollable date selector widget
///
/// Displays a week view with smooth scrolling and selection highlighting.
/// Automatically centers on the selected date.
class DateSelector extends StatefulWidget {
  const DateSelector({super.key});

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  late ScrollController _scrollController;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _pageController = PageController(
      initialPage: 1000, // Start in the middle for infinite scroll effect
      viewportFraction: 0.15,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Consumer<TimelineService>(
        builder: (context, timelineService, child) {
          return _buildDateList(timelineService);
        },
      ),
    );
  }

  Widget _buildDateList(TimelineService timelineService) {
    final today = DateTime.now();
    final selectedDate = timelineService.selectedDate;

    return ListView.builder(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: 365, // Show a year's worth of dates
      itemBuilder: (context, index) {
        final date = today.subtract(Duration(days: 182 - index));
        final isSelected = _isSameDay(date, selectedDate);
        final isToday = _isSameDay(date, today);
        final hasEvents = timelineService.getEventsForDate(date).isNotEmpty;

        return _buildDateItem(
          date: date,
          isSelected: isSelected,
          isToday: isToday,
          hasEvents: hasEvents,
          onTap: () => timelineService.selectDate(date),
        );
      },
    );
  }

  Widget _buildDateItem({
    required DateTime date,
    required bool isSelected,
    required bool isToday,
    required bool hasEvents,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: isToday && !isSelected
              ? Border.all(color: theme.colorScheme.primary, width: 2)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('EEE').format(date),
              style: theme.textTheme.labelSmall?.copyWith(
                color: isSelected
                    ? Colors.white
                    : theme.textTheme.labelSmall?.color,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date.day.toString(),
              style: theme.textTheme.titleMedium?.copyWith(
                color: isSelected
                    ? Colors.white
                    : theme.textTheme.titleMedium?.color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            if (hasEvents)
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color:
                      isSelected ? Colors.white : theme.colorScheme.secondary,
                  shape: BoxShape.circle,
                ),
              )
            else
              const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
