// ignore_for_file: avoid_types_as_parameter_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/core/themes/pomodoro_color_theme.dart';
import 'package:task_management_app/data/models/settings.dart';
import 'package:task_management_app/presentation/providers/pomodoro_provider.dart';
import 'package:task_management_app/presentation/widgets/common_gradient_background.dart';
import 'package:task_management_app/presentation/widgets/current_task_card.dart';
import 'package:task_management_app/presentation/widgets/duration_selector.dart';
import 'package:task_management_app/presentation/widgets/pomodoro_timer.dart';
import 'package:task_management_app/presentation/widgets/settings_dialog.dart';

class PomodoroPage extends StatelessWidget {
  const PomodoroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PomodoroProvider>(
      builder: (context, pomodoroProvider, child) {
        int currentDuration = 25;

        if (pomodoroProvider.isRunning ||
            pomodoroProvider.isPaused ||
            pomodoroProvider.isCompleted) {
          currentDuration = pomodoroProvider.duration;
        }

        final themeColors = PomodoroColorTheme.getThemeColors(currentDuration);

        return Scaffold(
          body: CommonGradientBackground(
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            _buildHeader(context, themeColors),
                            DurationSelector(themeColors: themeColors),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: PomodoroTimer(themeColors: themeColors),
                            ),
                            CurrentTaskCard(themeColors: themeColors),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, PomodoroThemeColors themeColors) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Pomodoro',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: themeColors.primary,
            ),
          ),
          IconButton(
            icon: Icon(Icons.settings, color: themeColors.primary),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => SettingsDialog(
                  settings: const Settings(
                    darkMode: false,
                    customColors: false,
                    availableDurations: [5, 10, 20, 25, 30],
                  ),
                  onSettingsChanged: (Settings) {},
                  onAddDuration: (int) {},
                  onRemoveDuration: (int) {},
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
