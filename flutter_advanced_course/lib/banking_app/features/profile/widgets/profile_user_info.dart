import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/banking_app/core/constants/app_colors.dart';

class ProfileUserInfo extends StatelessWidget {
  final String initials;
  final String fullName;
  final String email;
  final bool isDark;

  const ProfileUserInfo({
    super.key,
    required this.initials,
    required this.fullName,
    required this.email,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Avatar
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              initials,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        const SizedBox(height: 14),

        Text(
          fullName,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.grey900,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          email,
          style: const TextStyle(color: AppColors.grey600, fontSize: 14),
        ),
      ],
    );
  }
}
