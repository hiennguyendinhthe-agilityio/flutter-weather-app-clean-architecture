import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/theme_context_ext.dart';
import 'package:flutter_advanced_course/fitness_app/core/widgets/expense_category_list.dart';
import 'package:flutter_advanced_course/fitness_app/core/widgets/expense_donut_chart.dart';
import 'package:flutter_advanced_course/fitness_app/features/sandbox/expenses/providers/expenses_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ExpensesDashboardScreen extends ConsumerWidget {
  const ExpensesDashboardScreen({super.key});

  Future<void> _selectDate(BuildContext context, WidgetRef ref) async {
    final selectedDate = ref.read(selectedExpenseDateProvider);
    DateTime tempDate = selectedDate;
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoButton(
                    child: const Text('Done'),
                    onPressed: () {
                      if (tempDate != selectedDate) {
                        ref
                            .read(selectedExpenseDateProvider.notifier)
                            .setDate(tempDate);
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: selectedDate,
                  minimumDate: DateTime(2020, 1),
                  maximumDate: DateTime(2030, 12),
                  onDateTimeChanged: (DateTime newDate) {
                    tempDate = newDate;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = context.cs;
    final tt = context.tt;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text('Expenses'),
        actions: [
          IconButton(icon: const Icon(Icons.tune, size: 24), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              Builder(
                builder: (context) {
                  final date = ref.watch(selectedExpenseDateProvider);
                  final expenseDataPayload = ref.watch(expenseDataProvider);
                  final total = expenseDataPayload.total;
                  final categories = expenseDataPayload.categories;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('MMMM yyyy').format(date),
                                style: tt.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: cs.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              TweenAnimationBuilder<double>(
                                tween: Tween<double>(begin: 0, end: total),
                                duration: const Duration(milliseconds: 1000),
                                curve: Curves.easeOutCubic,
                                builder: (context, value, child) {
                                  return Row(
                                    children: [
                                      Text(
                                        '\$ ${value.toInt()}',
                                        style: tt.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: cs.onSurfaceVariant,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        '(+5.65%)',
                                        style: tt.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: cs.secondary,
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_drop_up,
                                        color: cs.secondary,
                                        size: 20,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => _selectDate(context, ref),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: cs.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: cs.outlineVariant),
                              ),
                              child: Icon(
                                Icons.settings_outlined,
                                color: cs.onSurface,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      RepaintBoundary(
                        child: ExpenseDonutChart(
                          categories: categories,
                          totalAmount: total,
                        ),
                      ),
                      const SizedBox(height: 40),
                      ExpenseCategoryList(categories: categories),
                    ],
                  );
                },
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
