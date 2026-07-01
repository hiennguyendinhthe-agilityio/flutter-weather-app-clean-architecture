import 'package:flutter_advanced_course/fitness_app/features/workouts/data/dummy_workouts.dart';
import 'package:flutter_advanced_course/fitness_app/features/workouts/models/workout_item.dart';

class WorkoutRepository {
  const WorkoutRepository();

  Future<List<WorkoutItem>> getWorkouts() async {
    await Future.delayed(const Duration(milliseconds: 350));
    return dummyWorkouts;
  }
}
