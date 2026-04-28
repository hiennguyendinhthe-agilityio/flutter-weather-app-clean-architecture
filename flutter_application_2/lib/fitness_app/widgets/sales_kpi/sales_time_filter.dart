import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';

class SalesTimeFilterBar extends StatelessWidget {
  final List<String> filters;
  final String selectedFilter;
  final ValueChanged<String> onFilterSelected;

  const SalesTimeFilterBar({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      decoration: BoxDecoration(
        color: FitnessColors.salesBackground,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: filters.map((filter) {
          final isSelected = filter == selectedFilter;
          return GestureDetector(
            onTap: () => onFilterSelected(filter),
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              decoration: BoxDecoration(
                color: isSelected ? FitnessColors.salesCardBackground : Colors.transparent,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                filter,
                style: isSelected
                    ? FitnessTextStyles.salesFilterTextActive
                    : FitnessTextStyles.salesFilterText,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
