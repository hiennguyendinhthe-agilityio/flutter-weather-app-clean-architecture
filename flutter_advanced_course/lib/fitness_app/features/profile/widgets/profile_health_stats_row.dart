import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/fitness_app/features/profile/widgets/profile_info_card.dart';

class ProfileHealthStatsRow extends StatelessWidget {
  const ProfileHealthStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ProfileInfoCard(
              title: 'Height',
              value: '180 cm',
              icon: Icons.height_rounded,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: ProfileInfoCard(
              title: 'Weight',
              value: '75 kg',
              icon: Icons.scale_rounded,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: ProfileInfoCard(
              title: 'BMI',
              value: '23.1',
              subtitle: 'Normal',
              icon: Icons.favorite_rounded,
            ),
          ),
        ],
      ),
    );
  }
}
