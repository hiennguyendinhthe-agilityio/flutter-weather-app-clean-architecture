import 'dummy_workouts.dart';
import '../models/workout_item.dart';

class WorkoutRepository {
  const WorkoutRepository();

  Future<List<WorkoutItem>> getWorkouts() async {
    await Future.delayed(const Duration(milliseconds: 350));
    return dummyWorkouts;
  }
}
