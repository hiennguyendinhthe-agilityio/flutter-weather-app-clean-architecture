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
    super.key,
  });

  @override
  DateSelectorState createState() => DateSelectorState();
}

class DateSelectorState extends State<DateSelector> {
  late final List<DateTime> _days;
  final ScrollController _scrollController = ScrollController();

  bool _isAnimating = false;
  DateTime? _lastSelectedDate;

  static const double _itemWidth = 60.0;
  static const double _itemPadding = 8.0;
  double get _totalItemWidth => _itemWidth + _itemPadding;

  @override
  void initState() {
    super.initState();
    _days = _generateDays();
    _lastSelectedDate = widget.selectedDate;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _scrollToSelectedDate(animate: false);
      }
    });
  }

  @override
  void didUpdateWidget(DateSelector oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!_isSameDay(widget.selectedDate, oldWidget.selectedDate) &&
        !_isAnimating) {
      final isUserInitiated = _lastSelectedDate != null &&
          _isSameDay(_lastSelectedDate!, oldWidget.selectedDate);

      if (!isUserInitiated) {
        final selectedIndex =
            _days.indexWhere((day) => _isSameDay(day, widget.selectedDate));
        if (selectedIndex != -1) {
          _scrollToIndex(selectedIndex, animate: true);
        }
      }
    }
    _lastSelectedDate = widget.selectedDate;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<DateTime> _generateDays() {
    final now = DateTime.now();
    const totalDays = 61;
    return List.generate(
        totalDays, (i) => now.subtract(Duration(days: 30 - i)));
  }

  void _scrollToSelectedDate({bool animate = true}) {
    final selectedIndex =
        _days.indexWhere((day) => _isSameDay(day, widget.selectedDate));
    if (selectedIndex != -1) {
      _scrollToIndex(selectedIndex, animate: animate);
    }
  }

  Future<void> _scrollToIndex(int index, {bool animate = true}) async {
    if (_isAnimating && animate) return;

    final screenWidth = MediaQuery.of(context).size.width;
    final targetOffset =
        (_totalItemWidth * index) - (screenWidth / 2) + (_totalItemWidth / 2);

    final maxScrollExtent = _scrollController.position.maxScrollExtent;
    final clampedOffset = targetOffset.clamp(0.0, maxScrollExtent);

    if (animate) {
      _isAnimating = true;
      try {
        await _scrollController.animateTo(
          clampedOffset,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      } finally {
        if (mounted) {
          _isAnimating = false;
        }
      }
    } else {
      _scrollController.jumpTo(clampedOffset);
    }
  }

  void _onDateTap(DateTime day) {
    _lastSelectedDate = day;
    final selectedIndex =
        _days.indexWhere((dayItem) => _isSameDay(dayItem, day));
    if (selectedIndex != -1) {
      _scrollToIndex(selectedIndex, animate: true);
    }
    widget.onDateSelected(day);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        itemCount: _days.length,
        itemBuilder: (context, i) {
          final day = _days[i];
          final isSelected = _isSameDay(day, widget.selectedDate);

          return Padding(
            padding: const EdgeInsets.only(right: _itemPadding),
            child: GestureDetector(
              onTap: () => _onDateTap(day),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: _itemWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  border: isSelected
                      ? Border.all(color: Colors.black, width: 2)
                      : null,
                  boxShadow: isSelected
                      ? [
                          const BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.1),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          )
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('E').format(day)[0],
                      style: TextStyle(
                        fontSize: 14,
                        color: isSelected ? Colors.black : Colors.grey,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
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
