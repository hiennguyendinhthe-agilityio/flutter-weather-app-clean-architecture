import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/theme_context_ext.dart';

class RingLegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final IconData icon;
  final bool isDimmed;
  final VoidCallback onTap;
  final bool isLast;

  const RingLegendItem({
    super.key,
    required this.color,
    required this.label,
    required this.icon,
    required this.isDimmed,
    required this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.ringLegendItemTheme;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isDimmed ? 0.3 : 1.0,
        child: Padding(
          padding: EdgeInsets.only(
            right: isLast ? 0.0 : 20.0,
            top: 8,
            bottom: 8,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Text(
                label,
                style:
                    theme.labelStyle?.copyWith(color: color) ??
                    TextStyle(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
