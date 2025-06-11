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
        const radius = 150.0;
        final knobOffset = Offset(
          radius * cos(angle),
          radius * sin(angle),
        );
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

        return Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 320,
                height: 320,
                child: CustomPaint(
                  painter: CircleProgressPainter(
                    progress: progress,
                    colorStart: themeColors.secondary,
                    colorEnd: themeColors.primary,
                    strokeWidth: 20,
                  ),
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
                      border: Border.all(color: themeColors.primary, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
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
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        hours.substring(0, 1),
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: _getNumberColor(
                              isHoursActive, themeColors.primary),
                        ),
                      ),
                      Text(
                        hours.substring(1, 2),
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: _getNumberColor(
                              isHoursActive, themeColors.primary),
                        ),
                      ),
                      Text(
                        ':',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: themeColors.primary.withValues(alpha: 0.3),
                        ),
                      ),
                      Text(
                        minutes.substring(0, 1),
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: _getNumberColor(
                              isMinutesActive, themeColors.primary),
                        ),
                      ),
                      Text(
                        minutes.substring(1, 2),
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: _getNumberColor(
                              isMinutesActive, themeColors.primary),
                        ),
                      ),
                      Text(
                        ':',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: themeColors.primary.withValues(alpha: 0.3),
                        ),
                      ),
                      Text(
                        seconds.substring(0, 1),
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: _getNumberColor(
                              isSecondsActive, themeColors.primary),
                        ),
                      ),
                      Text(
                        seconds.substring(1, 2),
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: _getNumberColor(
                              isSecondsActive, themeColors.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Use spread operator with conditional lists
                      ...pomodoroProvider.isLoading
                          ? [const CircularProgressIndicator()]
                          : pomodoroProvider.isInitial ||
                                  pomodoroProvider.isCompleted
                              ? [
                                  ControlButton(
                                    icon: Icons.play_arrow,
                                    onPressed: () =>
                                        pomodoroProvider.startPomodoro(),
                                    backgroundColor: themeColors.primary,
                                  ),
                                ]
                              : pomodoroProvider.isRunning
                                  ? [
                                      ControlButton(
                                        icon: Icons.pause,
                                        onPressed: () =>
                                            pomodoroProvider.pausePomodoro(),
                                        backgroundColor: themeColors.primary,
                                      ),
                                      const SizedBox(width: 20),
                                      ControlButton(
                                        icon: Icons.stop,
                                        onPressed: () =>
                                            pomodoroProvider.stopPomodoro(),
                                        backgroundColor: themeColors.primary,
                                      ),
                                    ]
                                  : pomodoroProvider.isPaused
                                      ? [
                                          ControlButton(
                                            icon: Icons.play_arrow,
                                            onPressed: () => pomodoroProvider
                                                .resumePomodoro(),
                                            backgroundColor:
                                                themeColors.primary,
                                          ),
                                          const SizedBox(width: 20),
                                          ControlButton(
                                            icon: Icons.stop,
                                            onPressed: () =>
                                                pomodoroProvider.stopPomodoro(),
                                            backgroundColor:
                                                themeColors.primary,
                                          ),
                                        ]
                                      : <Widget>[],
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
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
                  color: Colors.black.withOpacity(0.15),
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
