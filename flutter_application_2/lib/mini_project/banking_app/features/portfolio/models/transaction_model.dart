import 'package:flutter/material.dart';

enum TxType { income, expense, transfer }

class TransactionModel {
  final String id;
  final String title;
  final String subtitle;
  final double amount;
  final TxType txType;
  final DateTime date;
  final String category;
  final IconData icon;

  const TransactionModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.txType,
    required this.date,
    required this.category,
    required this.icon,
  });

  bool get isExpense => txType == TxType.expense;
  bool get isIncome => txType == TxType.income;

  String get type => isExpense ? 'expense' : 'income';

  static List<TransactionModel> mockData() {
    final now = DateTime.now();
    return [
      TransactionModel(
        id: 'tx001',
        title: 'Netflix',
        subtitle: 'Entertainment',
        amount: 15.99,
        txType: TxType.expense,
        date: now.subtract(const Duration(hours: 2)),
        category: 'Entertainment',
        icon: Icons.movie_outlined,
      ),
      TransactionModel(
        id: 'tx002',
        title: 'Salary',
        subtitle: 'Monthly payment',
        amount: 5000.00,
        txType: TxType.income,
        date: now.subtract(const Duration(hours: 5)),
        category: 'Income',
        icon: Icons.account_balance_wallet_outlined,
      ),
      TransactionModel(
        id: 'tx003',
        title: 'Starbucks',
        subtitle: 'Food & Drink',
        amount: 6.50,
        txType: TxType.expense,
        date: now.subtract(const Duration(days: 1)),
        category: 'Food',
        icon: Icons.local_cafe_outlined,
      ),
      TransactionModel(
        id: 'tx004',
        title: 'Amazon',
        subtitle: 'Shopping',
        amount: 89.99,
        txType: TxType.expense,
        date: now.subtract(const Duration(days: 1)),
        category: 'Shopping',
        icon: Icons.shopping_bag_outlined,
      ),
      TransactionModel(
        id: 'tx005',
        title: 'Freelance',
        subtitle: 'Design project',
        amount: 1200.00,
        txType: TxType.income,
        date: now.subtract(const Duration(days: 2)),
        category: 'Income',
        icon: Icons.work_outline_rounded,
      ),
      TransactionModel(
        id: 'tx006',
        title: 'Uber',
        subtitle: 'Transportation',
        amount: 12.30,
        txType: TxType.expense,
        date: now.subtract(const Duration(days: 2)),
        category: 'Transport',
        icon: Icons.directions_car_outlined,
      ),
      TransactionModel(
        id: 'tx007',
        title: 'Gym Membership',
        subtitle: 'Health & Fitness',
        amount: 45.00,
        txType: TxType.expense,
        date: now.subtract(const Duration(days: 4)),
        category: 'Health',
        icon: Icons.fitness_center_outlined,
      ),
      TransactionModel(
        id: 'tx008',
        title: 'Transfer',
        subtitle: 'To savings',
        amount: 500.00,
        txType: TxType.transfer,
        date: now.subtract(const Duration(days: 5)),
        category: 'Transfer',
        icon: Icons.swap_horiz_rounded,
      ),
    ];
  }
}
