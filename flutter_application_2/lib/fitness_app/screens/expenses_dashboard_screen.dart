import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/expense_model.dart';
import '../theme/theme_context_ext.dart';
import '../widgets/expense_category_list.dart';
import '../widgets/expense_donut_chart.dart';

class ExpensesDashboardScreen extends StatefulWidget {
  const ExpensesDashboardScreen({super.key});

  @override
  State<ExpensesDashboardScreen> createState() =>
      _ExpensesDashboardScreenState();
}

class _ExpensesDashboardScreenState extends State<ExpensesDashboardScreen> {
  late final ValueNotifier<DateTime> _dateNotifier;
  late final ValueNotifier<List<ExpenseCategory>> _categoriesNotifier;
  late final ValueNotifier<double> _totalAmountNotifier;

  @override
  void initState() {
    super.initState();
    final initialDate = DateTime(2022, 6);
    _dateNotifier = ValueNotifier<DateTime>(initialDate);
    _categoriesNotifier = ValueNotifier<List<ExpenseCategory>>([]);
    _totalAmountNotifier = ValueNotifier<double>(0);
  }

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final mockData = _generateMockData(_dateNotifier.value);
      _categoriesNotifier.value = mockData.categories;
      _totalAmountNotifier.value = mockData.total;
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _dateNotifier.dispose();
    _categoriesNotifier.dispose();
    _totalAmountNotifier.dispose();
    super.dispose();
  }

  ({List<ExpenseCategory> categories, double total}) _generateMockData(
    DateTime date,
  ) {
    final ft = context.fitnessTheme;
    final random = Random(date.year * 100 + date.month);
    final totalAmount = 1500.0 + random.nextInt(2000);

    final double uW = 10 + random.nextDouble() * 30;
    final double sW = 10 + random.nextDouble() * 30;
    final double eW = 10 + random.nextDouble() * 40;
    final double edW = 10 + random.nextDouble() * 20;

    final double totalW = uW + sW + eW + edW;

    return (
      categories: [
        ExpenseCategory(
          name: 'Utility',
          amount: totalAmount * (uW / totalW),
          percentage: uW / totalW,
          color: ft.accentLime,
        ),
        ExpenseCategory(
          name: 'Supermarkets',
          amount: totalAmount * (sW / totalW),
          percentage: sW / totalW,
          color: ft.accentPink,
        ),
        ExpenseCategory(
          name: 'Entertainment',
          amount: totalAmount * (eW / totalW),
          percentage: eW / totalW,
          color: ft.accentBlue,
        ),
        ExpenseCategory(
          name: 'Education',
          amount: totalAmount * (edW / totalW),
          percentage: edW / totalW,
          color: ft.accentCyan,
        ),
      ],
      total: totalAmount,
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime tempDate = _dateNotifier.value;
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
                      if (tempDate != _dateNotifier.value) {
                        _dateNotifier.value = tempDate;
                        final newData = _generateMockData(tempDate);
                        _categoriesNotifier.value = newData.categories;
                        _totalAmountNotifier.value = newData.total;
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: _dateNotifier.value,
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
  Widget build(BuildContext context) {
    final ft = context.fitnessTheme;

    return Scaffold(
      backgroundColor: ft.scaffoldBackground,
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

              ValueListenableBuilder<DateTime>(
                valueListenable: _dateNotifier,
                builder: (context, date, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('MMMM yyyy').format(date),
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                              color: ft.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          ValueListenableBuilder<double>(
                            valueListenable: _totalAmountNotifier,
                            builder: (context, total, _) {
                              return TweenAnimationBuilder<double>(
                                tween: Tween<double>(begin: 0, end: total),
                                duration: const Duration(milliseconds: 1000),
                                curve: Curves.easeOutCubic,
                                builder: (context, value, child) {
                                  return Row(
                                    children: [
                                      Text(
                                        '\$ ${value.toInt()}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: ft.textSecondary,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        '(+5.65%)',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: ft.healthColor,
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_drop_up,
                                        color: ft.healthColor,
                                        size: 20,
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: ft.cardBackground,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: ft.cardBorder),
                          ),
                          child: Icon(
                            Icons.settings_outlined,
                            color: ft.textPrimary,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 40),

              ValueListenableBuilder<List<ExpenseCategory>>(
                valueListenable: _categoriesNotifier,
                builder: (context, categories, _) {
                  return Column(
                    children: [
                      RepaintBoundary(
                        child: ExpenseDonutChart(
                          categories: categories,
                          totalAmount: _totalAmountNotifier.value,
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
