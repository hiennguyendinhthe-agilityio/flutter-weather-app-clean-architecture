import 'package:flutter/material.dart';

import '../../constants/text_styles.dart';

class ProjectHorizontalBar extends StatelessWidget {
  final String label;
  final double percentage;
  final String valueText;
  final Color color;
  final double progress;

  const ProjectHorizontalBar({
    super.key,
    required this.label,
    required this.percentage,
    required this.valueText,
    required this.color,
    this.progress = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: FitnessTextStyles.projectNameBold),
          ),
          Expanded(
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: (percentage * progress).clamp(0.0, 1.0),
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
              style: FitnessTextStyles.projectHoursText,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
