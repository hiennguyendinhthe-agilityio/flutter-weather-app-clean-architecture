import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/fitness_app/features/sandbox/expenses/models/expense_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'expenses_provider.g.dart';

class ExpenseDataPayload {
  final List<ExpenseCategory> categories;
  final double total;

  ExpenseDataPayload({required this.categories, required this.total});
}

@riverpod
class SelectedExpenseDate extends _$SelectedExpenseDate {
  @override
  DateTime build() => DateTime(2022, 6);

  void setDate(DateTime date) {
    state = date;
  }
}

@riverpod
ExpenseDataPayload expenseData(Ref ref) {
  final date = ref.watch(selectedExpenseDateProvider);

  // Note: we need context to access fitnessExt colors, but provider doesn't have it natively.
  // In a real app, theme colors shouldn't be in the model, or they should come from a ThemeProvider.
  // We'll return mock colors if context isn't available, but we expect the UI to pass it or we hardcode for now.

  final random = Random(date.year * 100 + date.month);
  final totalAmount = 1500.0 + random.nextInt(2000);

  final double uW = 10 + random.nextDouble() * 30;
  final double sW = 10 + random.nextDouble() * 30;
  final double eW = 10 + random.nextDouble() * 40;
  final double edW = 10 + random.nextDouble() * 20;
  final double totalW = uW + sW + eW + edW;

  return ExpenseDataPayload(
    categories: [
      ExpenseCategory(
        name: 'Utility',
        amount: totalAmount * (uW / totalW),
        percentage: uW / totalW,
        color: const Color(0xFFD4E157), // Lime
      ),
      ExpenseCategory(
        name: 'Supermarkets',
        amount: totalAmount * (sW / totalW),
        percentage: sW / totalW,
        color: const Color(0xFFF06292), // Pink
      ),
      ExpenseCategory(
        name: 'Entertainment',
        amount: totalAmount * (eW / totalW),
        percentage: eW / totalW,
        color: const Color(0xFF64B5F6), // Blue
      ),
      ExpenseCategory(
        name: 'Education',
        amount: totalAmount * (edW / totalW),
        percentage: edW / totalW,
        color: const Color(0xFF4DD0E1), // Cyan
      ),
    ],
    total: totalAmount,
  );
}
