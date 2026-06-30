import 'package:flutter_application_2/fitness_app/features/shared/data/fitness_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fitness_repository_provider.g.dart';

@riverpod
FitnessRepository fitnessRepository(Ref ref) {
  return FitnessRepository();
}
