import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/fitness_app/features/profile/widgets/profile_avatar_section.dart';
import 'package:flutter_advanced_course/fitness_app/features/profile/widgets/profile_developer_section.dart';
import 'package:flutter_advanced_course/fitness_app/features/profile/widgets/profile_health_stats_row.dart';
import 'package:flutter_advanced_course/fitness_app/features/profile/widgets/profile_settings_section.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), centerTitle: true),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          children: const [
            ProfileAvatarSection(),
            SizedBox(height: 32),
            ProfileHealthStatsRow(),
            SizedBox(height: 32),
            ProfileSettingsSection(),
            SizedBox(height: 32),
            ProfileDeveloperSection(),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
