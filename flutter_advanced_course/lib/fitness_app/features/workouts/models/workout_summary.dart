class WorkoutSummary {
  final int totalKcal;
  final int completedToday;
  final int weeklyCompleted;
  final int weeklyGoal;

  const WorkoutSummary({
    required this.totalKcal,
    required this.completedToday,
    required this.weeklyCompleted,
    required this.weeklyGoal,
  });

  String get motivationText {
    if (completedToday == 0) {
      return 'Choose a workout to start your daily goal.';
    }

    if (weeklyCompleted >= weeklyGoal) {
      return 'Weekly workout goal completed.';
    }

    return '$completedToday workout completed today.';
  }
}
