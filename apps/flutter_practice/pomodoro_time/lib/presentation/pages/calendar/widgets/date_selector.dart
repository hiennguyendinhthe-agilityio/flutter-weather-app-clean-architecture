import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateSelector extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final Duration totalTime;
  final int centerIndex;

  const DateSelector({
    required this.selectedDate,
    required this.onDateSelected,
    required this.totalTime,
    required this.centerIndex,
    Key? key,
  }) : super(key: key);

  @override
  DateSelectorState createState() => DateSelectorState();
}

class DateSelectorState extends State<DateSelector> {
  late final List<DateTime> _days;
  final ScrollController _scrollController = ScrollController();

  double get _totalItemWidth => 60.0 + 8.0;

  @override
  void initState() {
    super.initState();
    _days = _generateDays();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate();
    });
  }

  @override
  void didUpdateWidget(DateSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isSameDay(widget.selectedDate, oldWidget.selectedDate)) {
      final selectedIndex =
          _days.indexWhere((day) => _isSameDay(day, widget.selectedDate));
      if (selectedIndex != -1) {
        _scrollToIndex(selectedIndex, jump: false);
      }
    }
  }

  List<DateTime> _generateDays() {
    final now = DateTime.now();
    const totalDays = 61;
    return List.generate(
        totalDays, (i) => now.subtract(Duration(days: 30 - i)));
  }

  void _scrollToSelectedDate() {
    final selectedIndex =
        _days.indexWhere((day) => _isSameDay(day, widget.selectedDate));
    if (selectedIndex != -1) {
      _scrollToIndex(selectedIndex);
    }
  }

  void _scrollToIndex(int index, {bool jump = false}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final targetOffset =
        (_totalItemWidth * index) - (screenWidth / 2) + (_totalItemWidth / 2);

    if (jump) {
      _scrollController.jumpTo(targetOffset);
    } else {
      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.0 + 16.0, // item height + padding
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        itemCount: _days.length,
        itemBuilder: (context, i) {
          final day = _days[i];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => widget.onDateSelected(day),
              child: Container(
                width: 60.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  border: _isSameDay(day, widget.selectedDate)
                      ? Border.all(color: Colors.black, width: 2)
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('E').format(day)[0],
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      day.day.toString(),
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
          );
        },
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
