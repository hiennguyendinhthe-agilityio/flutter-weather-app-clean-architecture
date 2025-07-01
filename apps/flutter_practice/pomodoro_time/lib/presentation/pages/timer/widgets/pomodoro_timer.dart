import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/core/themes/pomodoro_color_theme.dart';
import 'package:task_management_app/presentation/pages/timer/widgets/circle_progress_painter.dart';
import 'package:task_management_app/presentation/pages/timer/widgets/control_button.dart';
import 'package:task_management_app/presentation/providers/pomodoro_provider.dart';

class PomodoroTimer extends StatelessWidget {
  final PomodoroThemeColors themeColors;
  const PomodoroTimer({required this.themeColors, super.key});

  Color _getNumberColor(bool isActive, Color activeColor) {
    return isActive ? activeColor : activeColor.withValues(alpha: 0.3);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PomodoroProvider>(
      builder: (context, pomodoroProvider, child) {
        int remainingSeconds = pomodoroProvider.remainingTime;
        final totalSeconds = pomodoroProvider.duration * 60;

        final isTrackInfoVisible =
            pomodoroProvider.isRunning || pomodoroProvider.isPaused;
        final progress =
            totalSeconds > 0 ? remainingSeconds / totalSeconds : 0.0;
        final angle = 2 * pi * progress;
        final showKnob = remainingSeconds > 0;

        final hoursNum = (remainingSeconds ~/ 3600);
        final minutesNum = ((remainingSeconds % 3600) ~/ 60);
        final secondsNum = (remainingSeconds % 60);

        final hours = hoursNum.toString().padLeft(2, '0');
        final minutes = minutesNum.toString().padLeft(2, '0');
        final seconds = secondsNum.toString().padLeft(2, '0');

        final isHoursActive = hoursNum > 0;
        final isMinutesActive = minutesNum > 0 || isHoursActive;
        const isSecondsActive = true;

        return LayoutBuilder(
          builder: (context, constraints) {
            final size = min(constraints.maxWidth, constraints.maxHeight);
            final radius = size / 2 - 26;
            final knobOffset = Offset(
              radius * cos(angle),
              radius * sin(angle),
            );

            final fontSize = size * 0.08;

            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        size: Size.infinite,
                        painter: CircleProgressPainter(
                          progress: progress,
                          colorStart: themeColors.secondary,
                          colorEnd: themeColors.primary,
                          strokeWidth: 20,
                        ),
                      ),
                      if (isTrackInfoVisible && showKnob) ...[
                        Transform.translate(
                          offset: knobOffset * 1.2,
                          child: _buildTrackInfoBubble(
                            pomodoroProvider.currentSongTitle,
                            pomodoroProvider.currentSongArtist,
                            themeColors,
                          ),
                        ),
                      ],
                      if (showKnob) ...[
                        Transform.translate(
                          offset: knobOffset,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: themeColors.primary, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FittedBox(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                for (final c in hours.characters)
                                  _buildTimeChar(c, isHoursActive, fontSize),
                                _buildTimeChar(':', false, fontSize),
                                for (final c in minutes.characters)
                                  _buildTimeChar(c, isMinutesActive, fontSize),
                                _buildTimeChar(':', false, fontSize),
                                for (final c in seconds.characters)
                                  _buildTimeChar(c, isSecondsActive, fontSize),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 16,
                            runSpacing: 8,
                            children: [
                              if (pomodoroProvider.isLoading) ...[
                                const CircularProgressIndicator()
                              ] else if (pomodoroProvider.isInitial ||
                                  pomodoroProvider.isCompleted) ...[
                                ControlButton(
                                  icon: Icons.play_arrow,
                                  onPressed: () =>
                                      pomodoroProvider.startPomodoro(),
                                  backgroundColor: themeColors.primary,
                                )
                              ] else if (pomodoroProvider.isRunning) ...[
                                ControlButton(
                                  icon: Icons.pause,
                                  onPressed: () =>
                                      pomodoroProvider.pausePomodoro(),
                                  backgroundColor: themeColors.primary,
                                ),
                                ControlButton(
                                  icon: Icons.stop,
                                  onPressed: () =>
                                      pomodoroProvider.stopPomodoro(),
                                  backgroundColor: themeColors.primary,
                                )
                              ] else if (pomodoroProvider.isPaused) ...[
                                ControlButton(
                                  icon: Icons.play_arrow,
                                  onPressed: () =>
                                      pomodoroProvider.resumePomodoro(),
                                  backgroundColor: themeColors.primary,
                                ),
                                ControlButton(
                                  icon: Icons.stop,
                                  onPressed: () =>
                                      pomodoroProvider.stopPomodoro(),
                                  backgroundColor: themeColors.primary,
                                )
                              ]
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTimeChar(String c, bool isActive, double fontSize) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: Text(
        c,
        key: ValueKey(c),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'SFProDisplay',
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          color: _getNumberColor(isActive, themeColors.primary),
        ),
      ),
    );
  }

  Widget _buildTrackInfoBubble(
      String title, String artist, PomodoroThemeColors themeColors) {
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🎵', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 6),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      artist,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
