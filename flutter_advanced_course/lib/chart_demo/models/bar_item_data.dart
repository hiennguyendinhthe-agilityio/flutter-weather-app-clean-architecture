import 'package:flutter/material.dart';

@immutable
class BarItemData {
  const BarItemData({
    required this.label,
    required this.value,
    required this.maxValue,
    required this.color,
    this.secondaryValue = 0,
    this.secondaryColor,
    this.valueLabel,
  }) : assert(value >= 0, 'value must be non-negative'),
       assert(secondaryValue >= 0, 'secondaryValue must be non-negative'),
       assert(maxValue > 0, 'maxValue must be positive');

  final String label;

  final double value;

  final double secondaryValue;

  final double maxValue;

  final Color color;

  final Color? secondaryColor;

  final String? valueLabel;

  double get primaryRatio => (value / maxValue).clamp(0.0, 1.0);

  double get totalRatio =>
      ((value + secondaryValue) / maxValue).clamp(0.0, 1.0);

  Color get resolvedSecondaryColor =>
      secondaryColor ?? color.withValues(alpha: 0.35);

  BarItemData copyWith({
    String? label,
    double? value,
    double? secondaryValue,
    double? maxValue,
    Color? color,
    Color? secondaryColor,
    String? valueLabel,
  }) {
    return BarItemData(
      label: label ?? this.label,
      value: value ?? this.value,
      secondaryValue: secondaryValue ?? this.secondaryValue,
      maxValue: maxValue ?? this.maxValue,
      color: color ?? this.color,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      valueLabel: valueLabel ?? this.valueLabel,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BarItemData &&
          runtimeType == other.runtimeType &&
          label == other.label &&
          value == other.value &&
          secondaryValue == other.secondaryValue &&
          maxValue == other.maxValue &&
          color == other.color;

  @override
  int get hashCode =>
      Object.hash(label, value, secondaryValue, maxValue, color);
}
