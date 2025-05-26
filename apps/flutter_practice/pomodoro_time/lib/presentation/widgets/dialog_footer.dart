import 'package:flutter/material.dart';

class DialogFooter extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback? onSave;

  const DialogFooter({
    super.key,
    required this.onCancel,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: onCancel,
            child: const Text('Cancel'),
          ),
          if (onSave != null) ...[
            const SizedBox(width: 8.0),
            ElevatedButton(
              onPressed: onSave,
              child: const Text('Save'),
            ),
          ]
        ],
      ),
    );
  }
}
