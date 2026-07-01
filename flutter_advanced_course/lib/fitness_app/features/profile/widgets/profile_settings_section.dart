import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/providers/theme_provider.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/theme_context_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Section "App settings" with 2 switches: Dark mode + Daily notifications.
class ProfileSettingsSection extends ConsumerStatefulWidget {
  const ProfileSettingsSection({super.key});

  @override
  ConsumerState<ProfileSettingsSection> createState() =>
      _ProfileSettingsSectionState();
}

class _ProfileSettingsSectionState
    extends ConsumerState<ProfileSettingsSection> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'App settings',
          style: TextStyle(
            color: cs.onSurface,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: cs.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Dark mode'),
                value: isDark,
                activeTrackColor: cs.primary,
                activeThumbColor: cs.onPrimary,
                onChanged: (val) {
                  ref
                      .read(themeModeProvider.notifier)
                      .setThemeMode(val ? ThemeMode.dark : ThemeMode.light);
                },
              ),
              Divider(
                color: cs.outlineVariant.withValues(alpha: 0.3),
                height: 1,
              ),
              SwitchListTile(
                title: const Text('Daily notifications'),
                value: _notificationsEnabled,
                activeTrackColor: cs.primary,
                activeThumbColor: cs.onPrimary,
                onChanged: (val) {
                  setState(() {
                    _notificationsEnabled = val;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
