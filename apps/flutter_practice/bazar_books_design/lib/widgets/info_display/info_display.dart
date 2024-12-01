import 'package:flutter/material.dart';

class BazUiInfoDisplay extends StatelessWidget {
  const BazUiInfoDisplay({
    super.key,
    this.label,
    this.value,
    this.icon,
    this.trailing,
  });

  final String? label;
  final String? value;

  final Widget? icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label ?? '',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade100,
          ),
          child: Row(
            children: [
              ...[
                icon ?? const SizedBox(),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  value ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              trailing ?? const SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}
