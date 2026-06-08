import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/fitness_repository.dart';

part 'fitness_repository_provider.g.dart';

@riverpod
FitnessRepository fitnessRepository(Ref ref) {
  return FitnessRepository();
}
