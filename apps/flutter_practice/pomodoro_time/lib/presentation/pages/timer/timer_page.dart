// ignore_for_file: avoid_types_as_parameter_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/core/themes/pomodoro_color_theme.dart';
import 'package:task_management_app/presentation/pages/tasks/widgets/current_task_card.dart';
import 'package:task_management_app/presentation/pages/timer/widgets/duration_selector.dart';
import 'package:task_management_app/presentation/pages/timer/widgets/pomodoro_timer.dart';
import 'package:task_management_app/presentation/providers/pomodoro_provider.dart';
import 'package:task_management_app/presentation/widgets/common_gradient_background.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({super.key});

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
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: PomodoroTimer(themeColors: themeColors),
                              ),
                            ),
                            CurrentTaskCard(themeColors: themeColors),
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Pomodoro',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings, size: 24, color: Colors.black54),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
