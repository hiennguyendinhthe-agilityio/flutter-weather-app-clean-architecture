import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/text_styles.dart';

class UserProfileHeader extends StatelessWidget {
  final String monthYear;
  final String subtitle;

  const UserProfileHeader({
    super.key,
    required this.monthYear,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE03E),
              borderRadius: BorderRadius.circular(14),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                'https://i.pravatar.cc/150?img=44',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.person, color: Color(0xFF14141E)),
              ),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(monthYear, style: FitnessTextStyles.profileMonth),
                const SizedBox(height: 2),
                Text(subtitle, style: FitnessTextStyles.profileSubtitle),
              ],
            ),
          ),

          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: FitnessColors.cardBackground,
              border: Border.all(color: FitnessColors.cardBorder, width: 1.0),
            ),
            child: const Center(
              child: Icon(
                Icons.settings_outlined,
                color: FitnessColors.textSecondary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
