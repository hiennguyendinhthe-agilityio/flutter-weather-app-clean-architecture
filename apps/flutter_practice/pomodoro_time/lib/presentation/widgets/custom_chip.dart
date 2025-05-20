// lib/presentation/widgets/common/custom_chip.dart
import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  final String label;
  final VoidCallback? onDeleted;

  const CustomChip({
    super.key,
    required this.label,
    this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      deleteIcon: const Icon(Icons.close, size: 16.0),
      onDeleted: onDeleted,
    );
  }
}
