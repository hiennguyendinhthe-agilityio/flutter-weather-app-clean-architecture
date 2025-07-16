import 'package:flutter/material.dart';
import 'package:todo_app/config/theme_extensions.dart';
import '../constants/app_constants.dart';

/// Reusable profile header widget
class ProfileHeaderWidget extends StatelessWidget {
  const ProfileHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.profilePadding),
      color: context.backgroundColor,
      child: const Column(
        children: [
          SizedBox(height: 20),
          _ProfileAvatar(),
          SizedBox(height: 16),
          _ProfileName(),
          SizedBox(height: 8),
          _ProfileDescription(),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar();

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      radius: AppConstants.avatarRadius,
      backgroundImage: NetworkImage(AppConstants.profileAvatarUrl),
    );
  }
}

class _ProfileName extends StatelessWidget {
  const _ProfileName();

  @override
  Widget build(BuildContext context) {
    return ThemedText(
      AppConstants.profileName,
      style: const TextStyle(
        fontSize: AppConstants.profileNameFontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _ProfileDescription extends StatelessWidget {
  const _ProfileDescription();

  @override
  Widget build(BuildContext context) {
    return ThemedText(
      AppConstants.profileDescription,
      style: const TextStyle(
        fontSize: AppConstants.profileDescriptionFontSize,
      ),
      isSecondary: true,
    );
  }
}