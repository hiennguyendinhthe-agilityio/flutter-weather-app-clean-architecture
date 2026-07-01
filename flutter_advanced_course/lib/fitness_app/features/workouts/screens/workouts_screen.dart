import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/theme_context_ext.dart';
import 'package:flutter_advanced_course/fitness_app/features/shared/providers/fitness_provider.dart';
import 'package:flutter_advanced_course/fitness_app/features/shared/providers/selected_date_provider.dart';
import 'package:flutter_advanced_course/fitness_app/features/workouts/models/workout_log.dart';
import 'package:flutter_advanced_course/fitness_app/features/workouts/providers/active_workout_provider.dart';
import 'package:flutter_advanced_course/fitness_app/features/workouts/providers/workout_provider.dart';
import 'package:flutter_advanced_course/fitness_app/features/workouts/widgets/active_workout_panel.dart';
import 'package:flutter_advanced_course/fitness_app/features/workouts/widgets/workout_card.dart';
import 'package:flutter_advanced_course/fitness_app/features/workouts/widgets/workout_summary_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkoutsScreen extends ConsumerWidget {
  const WorkoutsScreen({super.key});

  static const List<String> _levels = ['Easy', 'Medium', 'Hard'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = context.cs;
    final selectedDate = ref.watch(selectedDateProvider);
    final dailyFitnessAsync = ref.watch(dailyFitnessProvider(selectedDate));
    final workoutsAsync = ref.watch(workoutsProvider);
    final filteredWorkouts = ref.watch(filteredWorkoutsProvider);
    final filter = ref.watch(workoutFilterProvider);
    final summary = ref.watch(workoutSummaryProvider);
    final activeWorkout = ref.watch(activeWorkoutProvider);
    final activeWorkoutNotifier = ref.read(activeWorkoutProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workouts'),
        actions: [
          IconButton(
            tooltip: 'Workout history',
            icon: const Icon(Icons.history_rounded),
            onPressed: () => _showHistorySheet(context, ref),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(workoutsProvider);
            ref.invalidate(dailyFitnessProvider(selectedDate));
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 12.0,
            ),
            children: [
              dailyFitnessAsync.when(
                loading: () => WorkoutSummaryCard(
                  totalKcal: summary.totalKcal.toDouble(),
                  stepProgress: 0,
                  currentSteps: 0,
                  goalSteps: 10000,
                  motivationText: summary.motivationText,
                ),
                error: (_, _) => WorkoutSummaryCard(
                  totalKcal: summary.totalKcal.toDouble(),
                  stepProgress: 0,
                  currentSteps: 0,
                  goalSteps: 10000,
                  motivationText: summary.motivationText,
                ),
                data: (dayData) => WorkoutSummaryCard(
                  totalKcal: summary.totalKcal.toDouble(),
                  stepProgress: (dayData.currentSteps / dayData.goalSteps)
                      .clamp(0.0, 1.0),
                  currentSteps: dayData.currentSteps,
                  goalSteps: dayData.goalSteps,
                  motivationText:
                      '${summary.motivationText} ${summary.weeklyCompleted}/${summary.weeklyGoal} this week.',
                ),
              ),
              const SizedBox(height: 18),
              ActiveWorkoutPanel(
                state: activeWorkout,
                onPause: activeWorkoutNotifier.pause,
                onResume: activeWorkoutNotifier.resume,
                onComplete: activeWorkoutNotifier.complete,
                onCancel: activeWorkoutNotifier.cancel,
              ),
              if (activeWorkout.hasWorkout) const SizedBox(height: 24),
              _SearchField(
                onChanged: (value) =>
                    ref.read(workoutFilterProvider.notifier).setQuery(value),
              ),
              const SizedBox(height: 14),
              _LevelFilters(
                levels: _levels,
                selectedLevel: filter.level,
                onSelected: (level) =>
                    ref.read(workoutFilterProvider.notifier).setLevel(level),
                onClear: filter.hasActiveFilters
                    ? ref.read(workoutFilterProvider.notifier).clear
                    : null,
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Suggested workouts',
                      style: TextStyle(
                        color: cs.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    '${filteredWorkouts.length}',
                    style: TextStyle(
                      color: cs.onSurfaceVariant,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              workoutsAsync.when(
                loading: () => const _WorkoutListLoading(),
                error: (error, _) => _WorkoutListError(
                  message: error.toString(),
                  onRetry: () => ref.invalidate(workoutsProvider),
                ),
                data: (_) {
                  if (filteredWorkouts.isEmpty) {
                    return _EmptyWorkouts(
                      onClear: () {
                        ref.read(workoutFilterProvider.notifier).clear();
                      },
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredWorkouts.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final item = filteredWorkouts[index];
                      return WorkoutCard(
                        item: item,
                        onTap: () {
                          activeWorkoutNotifier.start(item);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${item.title} started.'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _showHistorySheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final history = ref.watch(workoutHistoryProvider);

            if (history.isEmpty) {
              return const SizedBox(
                height: 180,
                child: Center(child: Text('No completed workouts yet.')),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              itemCount: history.length,
              separatorBuilder: (context, index) => const Divider(height: 24),
              itemBuilder: (context, index) {
                return _HistoryTile(log: history[index]);
              },
            );
          },
        );
      },
    );
  }
}

class _SearchField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const _SearchField({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;

    return TextField(
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Search workouts',
        prefixIcon: const Icon(Icons.search_rounded),
        filled: true,
        fillColor: cs.surfaceContainerHigh,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}

class _LevelFilters extends StatelessWidget {
  final List<String> levels;
  final String? selectedLevel;
  final ValueChanged<String?> onSelected;
  final VoidCallback? onClear;

  const _LevelFilters({
    required this.levels,
    required this.selectedLevel,
    required this.onSelected,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final level in levels)
          FilterChip(
            label: Text(level),
            selected: selectedLevel == level,
            onSelected: (isSelected) => onSelected(isSelected ? level : null),
          ),
        if (onClear != null)
          ActionChip(
            avatar: const Icon(Icons.close_rounded, size: 18),
            label: const Text('Clear'),
            onPressed: onClear,
          ),
      ],
    );
  }
}

class _WorkoutListLoading extends StatelessWidget {
  const _WorkoutListLoading();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 32),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _WorkoutListError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _WorkoutListError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cs.errorContainer,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: cs.onErrorContainer),
          ),
          const SizedBox(height: 12),
          FilledButton.tonal(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

class _EmptyWorkouts extends StatelessWidget {
  final VoidCallback onClear;

  const _EmptyWorkouts({required this.onClear});

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(Icons.search_off_rounded, color: cs.onSurfaceVariant),
          const SizedBox(height: 8),
          Text(
            'No workouts match your filters.',
            style: TextStyle(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 12),
          TextButton(onPressed: onClear, child: const Text('Clear filters')),
        ],
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final WorkoutLog log;

  const _HistoryTile({required this.log});

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: cs.primary.withValues(alpha: 0.16),
        child: Icon(Icons.check_rounded, color: cs.primary),
      ),
      title: Text(log.workoutTitle),
      subtitle: Text('${log.durationMinutes} min • ${log.caloriesBurned} kcal'),
      trailing: Text(
        _formatTime(log.completedAt),
        style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12),
      ),
    );
  }

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
