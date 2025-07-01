import 'package:flutter/material.dart';

class ColorPicker extends StatelessWidget {
  final String selectedColor;
  final Function(String) onColorSelected;

  const ColorPicker({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorOptions = [
      {'value': 'blue', 'color': Colors.blue},
      {'value': 'green', 'color': Colors.green},
      {'value': 'orange', 'color': Colors.orange},
      {'value': 'red', 'color': Colors.red},
      {'value': 'purple', 'color': Colors.purple},
      {'value': 'teal', 'color': Colors.teal},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Project Color:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: colorOptions.map((option) {
            final val = option['value'] as String;
            final color = option['color'] as Color;
            final isSelected = selectedColor == val;

            return GestureDetector(
              onTap: () => onColorSelected(val),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white)
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
