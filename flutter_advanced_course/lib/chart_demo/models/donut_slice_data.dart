import 'package:flutter/material.dart';

@immutable
class DonutSliceData {
  const DonutSliceData({
    required this.label,
    required this.value,
    required this.color,
    this.dimmedColor,
    this.metadata,
  }) : assert(value >= 0, 'Value must be non-negative');

  final String label;
  final double value;
  final Color color;
  final Color? dimmedColor;
  final String? metadata;

  Color get resolvedDimmedColor => dimmedColor ?? color.withValues(alpha: 0.22);

  DonutSliceData copyWith({
    String? label,
    double? value,
    Color? color,
    Color? dimmedColor,
    String? metadata,
  }) => DonutSliceData(
    label: label ?? this.label,
    value: value ?? this.value,
    color: color ?? this.color,
    dimmedColor: dimmedColor ?? this.dimmedColor,
    metadata: metadata ?? this.metadata,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DonutSliceData &&
          runtimeType == other.runtimeType &&
          label == other.label &&
          value == other.value &&
          color == other.color &&
          dimmedColor == other.dimmedColor &&
          metadata == other.metadata;

  @override
  int get hashCode => Object.hash(label, value, color, dimmedColor, metadata);
}
