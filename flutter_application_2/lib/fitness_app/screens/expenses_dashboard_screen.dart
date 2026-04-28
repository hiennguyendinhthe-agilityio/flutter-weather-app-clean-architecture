import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../models/expense_model.dart';
import '../widgets/expense_category_list.dart';
import '../widgets/expense_donut_chart.dart';

class ExpensesDashboardScreen extends StatefulWidget {
  const ExpensesDashboardScreen({super.key});

  @override
  State<ExpensesDashboardScreen> createState() =>
      _ExpensesDashboardScreenState();
}

class _ExpensesDashboardScreenState extends State<ExpensesDashboardScreen> {
  late DateTime _selectedDate;
  late double _totalAmount;
  late List<ExpenseCategory> _categories;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime(2022, 6); // Default to June 2022 to match UI
    _generateMockData(_selectedDate);
  }

  void _generateMockData(DateTime date) {
    // Generate deterministic random data based on year and month
    final random = Random(date.year * 100 + date.month);

    _totalAmount = 1500.0 + random.nextInt(2000); // Between 1500 and 3500

    // Generate random weights
    final double utilityWeight = 10 + random.nextDouble() * 30; // 10-40
    final double supermarketWeight = 10 + random.nextDouble() * 30; // 10-40
    final double entertainmentWeight = 10 + random.nextDouble() * 40; // 10-50
    final double educationWeight = 10 + random.nextDouble() * 20; // 10-30

    final double totalWeight =
        utilityWeight +
        supermarketWeight +
        entertainmentWeight +
        educationWeight;

    // Calculate percentages
    final double pUtility = utilityWeight / totalWeight;
    final double pSupermarket = supermarketWeight / totalWeight;
    final double pEntertainment = entertainmentWeight / totalWeight;
    final double pEducation = educationWeight / totalWeight;

    _categories = [
      ExpenseCategory(
        name: 'Utility',
        amount: _totalAmount * pUtility,
        percentage: pUtility,
        color: FitnessColors.expenseYellow,
      ),
      ExpenseCategory(
        name: 'Supermarkets',
        amount: _totalAmount * pSupermarket,
        percentage: pSupermarket,
        color: FitnessColors.expensePink,
      ),
      ExpenseCategory(
        name: 'Entertainment',
        amount: _totalAmount * pEntertainment,
        percentage: pEntertainment,
        color: FitnessColors.expenseBlue,
      ),
      ExpenseCategory(
        name: 'Education',
        amount: _totalAmount * pEducation,
        percentage: pEducation,
        color: FitnessColors.expenseCyan,
      ),
    ];
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime tempDate = _selectedDate;
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
                      if (tempDate != _selectedDate) {
                        setState(() {
                          _selectedDate = tempDate;
                          _generateMockData(_selectedDate);
                        });
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: _selectedDate,
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
    return Scaffold(
      backgroundColor: FitnessColors.background,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildHeader(),
              const SizedBox(height: 40),
              ExpenseDonutChart(
                categories: _categories,
                totalAmount: _totalAmount,
              ),
              const SizedBox(height: 40),
              ExpenseCategoryList(categories: _categories),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.white,
          size: 20,
        ),
        onPressed: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        },
      ),
      title: const Text('Expenses', style: FitnessTextStyles.titleLarge),
      actions: [
        IconButton(
          icon: const Icon(Icons.tune, color: Colors.white, size: 24),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('MMMM yyyy').format(_selectedDate),
              style: FitnessTextStyles.expenseMonth,
            ),
            const SizedBox(height: 4),
            Row(
              children: const [
                // We will animate the total in the Donut Chart, this is just a static label if needed
                // But in the original UI, the header had $2460. Let's keep it static or remove it?
                // Actually the design has "$ 2460 (+5.65%)" in the header AND in the center of the chart.
                // We'll update the total in the header dynamically but without animation for simplicity,
                // or use a TweenAnimationBuilder here too. Let's use TweenAnimationBuilder.
              ],
            ),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: _totalAmount),
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Row(
                  children: [
                    Text(
                      '\$ ${value.toInt()}',
                      style: FitnessTextStyles.expenseTotal,
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      '(+5.65%)',
                      style: FitnessTextStyles.expenseTotalGreen,
                    ),
                    const Icon(
                      Icons.arrow_drop_up,
                      color: FitnessColors.health,
                      size: 20,
                    ),
                  ],
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
              color: FitnessColors.cardBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: FitnessColors.cardBorder),
            ),
            child: const Icon(
              Icons.settings_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }
}
