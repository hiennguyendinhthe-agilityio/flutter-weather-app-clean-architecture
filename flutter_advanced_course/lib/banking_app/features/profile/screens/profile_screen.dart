import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/banking_app/core/constants/app_colors.dart';
import 'package:flutter_advanced_course/banking_app/core/router/app_router.dart';
import 'package:flutter_advanced_course/banking_app/features/auth/providers/auth_notifier.dart';
import 'package:flutter_advanced_course/banking_app/features/profile/widgets/profile_menu_item.dart';
import 'package:flutter_advanced_course/banking_app/features/profile/widgets/profile_user_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
          title: Text(
            'Profile',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.grey900,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Avatar
                ProfileUserInfo(
                  initials: user?.initials ?? 'U',
                  fullName: user?.fullName ?? 'User',
                  email: user?.email ?? '',
                  isDark: isDark,
                ),

                const SizedBox(height: 28),

                // Menu
                ProfileMenuItem(
                  icon: Icons.person_outlined,
                  label: 'Edit Profile',
                  isDark: isDark,
                  onTap: () {},
                ),
                ProfileMenuItem(
                  icon: Icons.notifications_outlined,
                  label: 'Notifications',
                  isDark: isDark,
                  onTap: () {},
                ),
                ProfileMenuItem(
                  icon: Icons.security_outlined,
                  label: 'Security',
                  isDark: isDark,
                  onTap: () {},
                ),
                ProfileMenuItem(
                  icon: Icons.help_outline_rounded,
                  label: 'Help & Support',
                  isDark: isDark,
                  onTap: () {},
                ),

                const SizedBox(height: 20),

                // Logout
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await ref.read(authProvider.notifier).logout();
                      if (context.mounted) {
                        await Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.login,
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.logout_rounded,
                      color: AppColors.error,
                    ),
                    label: const Text(
                      'Sign Out',
                      style: TextStyle(color: AppColors.error),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: AppColors.error.withValues(alpha: 0.4),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
