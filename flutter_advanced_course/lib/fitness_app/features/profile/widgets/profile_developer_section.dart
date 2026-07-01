import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/theme_context_ext.dart';
import 'package:flutter_advanced_course/fitness_app/features/profile/widgets/profile_sandbox_item.dart';
import 'package:go_router/go_router.dart';

class ProfileDeveloperSection extends StatelessWidget {
  const ProfileDeveloperSection({super.key});

  void _showSandboxMenu(BuildContext context) {
    final cs = context.cs;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Container(
          height: MediaQuery.of(sheetContext).size.height * 0.6,
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: cs.outlineVariant.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Header
              Row(
                children: [
                  Icon(Icons.terminal_rounded, color: cs.primary, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    'Developer / Lab Sandbox',
                    style: TextStyle(
                      color: cs.onSurface,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Access features for learning and additional statistics '
                'that are not part of the main Fitness App flow.',
                style: TextStyle(
                  color: cs.onSurfaceVariant,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),

              // Items list
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    ProfileSandboxItem(
                      title: 'Projects Dashboard',
                      subtitle: 'Personal project management',
                      icon: Icons.widgets_rounded,
                      color: const Color(0xFFCBFF3E),
                      onTap: () {
                        Navigator.pop(sheetContext);
                        context.push('/projects');
                      },
                    ),
                    ProfileSandboxItem(
                      title: 'Expenses Tracker',
                      subtitle: 'Personal expense tracking',
                      icon: Icons.pie_chart_rounded,
                      color: const Color(0xFF5A94FF),
                      onTap: () {
                        Navigator.pop(sheetContext);
                        context.push('/expenses');
                      },
                    ),
                    ProfileSandboxItem(
                      title: 'Sales KPI Dashboard',
                      subtitle: 'Sales performance indicators',
                      icon: Icons.analytics_rounded,
                      color: const Color(0xFF1DE5C2),
                      onTap: () {
                        Navigator.pop(sheetContext);
                        context.push('/sales');
                      },
                    ),
                    ProfileSandboxItem(
                      title: 'Account Statistics',
                      subtitle: 'Bank financial statistics',
                      icon: Icons.insert_chart_rounded,
                      color: const Color(0xFFFFB347),
                      onTap: () {
                        Navigator.pop(sheetContext);
                        context.push('/account_stats');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Developer tools',
          style: TextStyle(
            color: cs.onSurface,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => _showSandboxMenu(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  cs.primary.withValues(alpha: 0.15),
                  cs.primaryContainer.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: cs.primary.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.terminal_rounded, color: cs.primary, size: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Developer / Lab Sandbox',
                        style: TextStyle(
                          color: cs.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Click to open learning features and additional statistics',
                        style: TextStyle(
                          color: cs.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: cs.primary,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
