import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/theme_context_ext.dart';

class ProjectHorizontalBar extends StatelessWidget {
  final String label;
  final double percentage;
  final String valueText;
  final Color color;
  final Animation<double> animation;

  const ProjectHorizontalBar({
    super.key,
    required this.label,
    required this.percentage,
    required this.valueText,
    required this.color,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.projectHorizontalBarTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(label, style: theme.titleStyle)),
          Expanded(
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: theme.trackColor ?? Colors.black12,
                borderRadius: BorderRadius.circular(4),
              ),
              child: AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  return FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: (percentage * animation.value).clamp(0.0, 1.0),
                    child: child,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withValues(alpha: 0.8)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.6),
                        blurRadius: 8,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 50,
            child: Text(
              valueText,
              style: theme.valueStyle,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
