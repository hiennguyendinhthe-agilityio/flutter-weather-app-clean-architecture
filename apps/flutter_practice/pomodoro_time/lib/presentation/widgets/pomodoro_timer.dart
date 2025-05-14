import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class PomodoroTimer extends StatelessWidget {
  final int remainingSeconds;
  final int totalSeconds;
  final bool isRunning;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onStop;

  const PomodoroTimer({
    super.key,
    required this.remainingSeconds,
    required this.totalSeconds,
    required this.isRunning,
    required this.onStart,
    required this.onPause,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    final minutes = (remainingSeconds / 60).floor();
    final seconds = remainingSeconds % 60;
    final percent = totalSeconds > 0 ? remainingSeconds / totalSeconds : 0.0;

    return Center(
      child: CircularPercentIndicator(
        radius: 140.0,
        lineWidth: 15.0,
        percent: percent,
        center: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
              style: const TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isRunning) ...[
                  _buildControlButton(
                    context,
                    Icons.play_arrow,
                    onStart,
                  ),
                ] else ...[
                  _buildControlButton(
                    context,
                    Icons.pause,
                    onPause,
                  ),
                  const SizedBox(width: 20),
                  _buildControlButton(
                    context,
                    Icons.stop,
                    onStop,
                  ),
                ],
              ],
            ),
          ],
        ),
        progressColor: Colors.blue,
        backgroundColor: Colors.blue.withValues(alpha: 0.2),
        circularStrokeCap: CircularStrokeCap.round,
      ),
    );
  }

  Widget _buildControlButton(
      BuildContext context, IconData icon, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(16),
      ),
      child: Icon(icon, size: 32),
    );
  }
}
