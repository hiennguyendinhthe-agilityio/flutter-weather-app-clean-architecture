import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';

class SalesKpiCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String amount;
  final String percentage;

  const SalesKpiCard({
    super.key,
    required this.icon,
    required this.title,
    required this.amount,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: FitnessColors.salesCardBackground,
          borderRadius: BorderRadius.circular(24.0), // Large border radius
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: FitnessColors.textSecondary,
              size: 24.0,
            ),
            const SizedBox(height: 16.0),
            Text(
              title,
              style: FitnessTextStyles.salesCardTitle,
            ),
            const SizedBox(height: 8.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  amount,
                  style: FitnessTextStyles.salesCardAmount,
                ),
                const SizedBox(width: 4.0),
                Text(
                  percentage,
                  style: FitnessTextStyles.salesCardPercentage,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
