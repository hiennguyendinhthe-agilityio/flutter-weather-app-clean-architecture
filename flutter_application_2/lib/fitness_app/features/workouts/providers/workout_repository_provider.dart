import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/workout_repository.dart';

part 'workout_repository_provider.g.dart';

@riverpod
WorkoutRepository workoutRepository(Ref ref) {
  return const WorkoutRepository();
}
