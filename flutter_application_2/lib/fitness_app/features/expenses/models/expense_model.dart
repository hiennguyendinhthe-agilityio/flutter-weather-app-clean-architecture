import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class ExpenseCategory extends Equatable {
  final String name;
  final double amount;
  final double percentage;
  final Color color;

  const ExpenseCategory({
    required this.name,
    required this.amount,
    required this.percentage,
    required this.color,
  });

  ExpenseCategory copyWith({
    String? name,
    double? amount,
    double? percentage,
    Color? color,
  }) {
    return ExpenseCategory(
      name: name ?? this.name,
      amount: amount ?? this.amount,
      percentage: percentage ?? this.percentage,
      color: color ?? this.color,
    );
  }

  @override
  List<Object?> get props => [name, amount, percentage, color.toARGB32()];
}
