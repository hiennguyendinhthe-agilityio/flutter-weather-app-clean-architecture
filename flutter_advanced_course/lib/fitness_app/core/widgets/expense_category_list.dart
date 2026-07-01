import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/theme_context_ext.dart';
import 'package:flutter_advanced_course/fitness_app/features/sandbox/expenses/models/expense_model.dart';

class ExpenseCategoryList extends StatelessWidget {
  final List<ExpenseCategory> categories;

  const ExpenseCategoryList({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    // Split categories into left and right columns
    final leftColumn = categories
        .where((c) => c.name == 'Utility' || c.name == 'Entertainment')
        .toList();
    final rightColumn = categories
        .where((c) => c.name == 'Supermarkets' || c.name == 'Education')
        .toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: leftColumn
                .map((category) => _buildCategoryItem(context, category))
                .toList(),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            children: rightColumn
                .map((category) => _buildCategoryItem(context, category))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(BuildContext context, ExpenseCategory category) {
    final theme = context.expenseCategoryListTheme;
    // Assuming max amount is around 800 for scaling the progress bar
    const maxAmount = 800.0;
    final progress = (category.amount / maxAmount).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(category.name, style: theme.categoryNameStyle),
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: category.amount),
                duration: const Duration(milliseconds: 1500),
                curve: Curves.easeInOutCubic,
                builder: (context, value, child) {
                  return Text(
                    '\$ ${value.toInt()}',
                    style: theme.categoryAmountStyle,
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          _CustomProgressBar(progress: progress, color: category.color),
        ],
      ),
    );
  }
}

class _CustomProgressBar extends StatelessWidget {
  final double progress;
  final Color color;

  const _CustomProgressBar({required this.progress, required this.color});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return Stack(
          children: [
            // Track
            Container(
              height: 10,
              width: width,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            // Progress
            AnimatedContainer(
              duration: const Duration(milliseconds: 1500),
              curve: Curves.easeInOutCubic,
              height: 10,
              width: width * progress,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
