import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';

/// Horizontal scrollable date selector widget
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
    _pageController =
        PageController(initialPage: 7); // Start at today (middle of 15 days)
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        return SizedBox(
          height: 100,
          child: Column(
            children: [
              _buildMonthYearHeader(taskProvider.selectedDate),
              const SizedBox(height: 8),
              Expanded(
                child: _buildDateList(taskProvider),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMonthYearHeader(DateTime selectedDate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          DateFormat('MMMM yyyy').format(selectedDate),
          style: GoogleFonts.roboto(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () => _navigateMonth(-1),
            ),
            IconButton(
              icon: const Icon(Icons.today),
              onPressed: () => _goToToday(),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () => _navigateMonth(1),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateList(TaskProvider taskProvider) {
    final today = DateTime.now();
    final selectedDate = taskProvider.selectedDate;

    return ListView.builder(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      itemCount: 30, // Show 30 days
      itemBuilder: (context, index) {
        final date = today
            .add(Duration(days: index - 15)); // 15 days before and after today
        final isSelected = _isSameDay(date, selectedDate);
        final isToday = _isSameDay(date, today);

        return GestureDetector(
          onTap: () => _selectDate(taskProvider, date),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : isToday
                      ? Theme.of(context).primaryColor.withOpacity(0.1)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isToday && !isSelected
                  ? Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 1,
                    )
                  : null,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('E').format(date),
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date.day.toString(),
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Colors.white
                          : isToday
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void _selectDate(TaskProvider taskProvider, DateTime date) {
    taskProvider.setSelectedDate(date);
    _scrollToSelectedDate();
  }

  void _navigateMonth(int direction) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final currentDate = taskProvider.selectedDate;
    final newDate = DateTime(
      currentDate.year,
      currentDate.month + direction,
      currentDate.day,
    );
    taskProvider.setSelectedDate(newDate);
    _scrollToSelectedDate();
  }

  void _goToToday() {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    taskProvider.setSelectedDate(DateTime.now());
    _scrollToSelectedDate();
  }

  void _scrollToSelectedDate() {
    // Animate scroll to center the selected date
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent * 0.5,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }
}
