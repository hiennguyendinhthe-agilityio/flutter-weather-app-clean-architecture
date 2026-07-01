import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/theme_context_ext.dart';
import 'package:flutter_advanced_course/fitness_app/features/workouts/models/active_workout_state.dart';

class ActiveWorkoutPanel extends StatelessWidget {
  final ActiveWorkoutState state;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onComplete;
  final VoidCallback onCancel;

  const ActiveWorkoutPanel({
    super.key,
    required this.state,
    required this.onPause,
    required this.onResume,
    required this.onComplete,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final workout = state.workout;
    if (workout == null) {
      return const SizedBox.shrink();
    }

    final cs = context.cs;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: workout.color.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: workout.color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(workout.icon, color: workout.color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.isRunning ? 'Active workout' : 'Workout paused',
                      style: TextStyle(
                        color: cs.onSurfaceVariant,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      workout.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: cs.onSurface,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Cancel workout',
                onPressed: onCancel,
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: state.progress,
              minHeight: 8,
              backgroundColor: workout.color.withValues(alpha: 0.12),
              valueColor: AlwaysStoppedAnimation<Color>(workout.color),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _Metric(
                  icon: Icons.timer_rounded,
                  label: _formatElapsed(state.elapsed),
                ),
              ),
              Expanded(
                child: _Metric(
                  icon: Icons.local_fire_department_rounded,
                  label: '${state.estimatedCalories} kcal',
                ),
              ),
              IconButton.filledTonal(
                tooltip: state.isRunning ? 'Pause' : 'Resume',
                onPressed: state.isRunning ? onPause : onResume,
                icon: Icon(
                  state.isRunning
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                tooltip: 'Complete',
                onPressed: onComplete,
                icon: const Icon(Icons.check_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatElapsed(Duration elapsed) {
    final minutes = elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

class _Metric extends StatelessWidget {
  final IconData icon;
  final String label;

  const _Metric({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;

    return Row(
      children: [
        Icon(icon, size: 16, color: cs.onSurfaceVariant),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: cs.onSurface,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
