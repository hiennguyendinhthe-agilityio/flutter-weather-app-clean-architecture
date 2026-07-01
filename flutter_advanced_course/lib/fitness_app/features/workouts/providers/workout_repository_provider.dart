import 'package:flutter_advanced_course/fitness_app/features/workouts/data/workout_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workout_repository_provider.g.dart';

@riverpod
WorkoutRepository workoutRepository(Ref ref) {
  return const WorkoutRepository();
}
