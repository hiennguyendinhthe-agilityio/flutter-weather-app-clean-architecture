import 'package:flutter/material.dart';

class CancelSaveButtonRow extends StatelessWidget {
  const CancelSaveButtonRow({
    super.key,
    required this.isEditing,
    required this.onCancel,
    required this.onSave,
  });

  /// Determines button text based on edit mode.
  final bool isEditing;

  /// Callback when Cancel is pressed.
  final VoidCallback onCancel;

  /// Callback when Save/Add is pressed.
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onCancel,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: onSave,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(isEditing ? 'Save Changes' : 'Add Task'),
          ),
        ),
      ],
    );
  }
}
