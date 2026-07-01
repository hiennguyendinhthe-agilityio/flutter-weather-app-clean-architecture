import 'package:flutter_advanced_course/fitness_app/features/sandbox/projects/data/project_repository.dart';
import 'package:flutter_advanced_course/fitness_app/features/sandbox/projects/models/project_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'project_provider.g.dart';

@riverpod
class SelectedProjectPeriod extends _$SelectedProjectPeriod {
  @override
  String build() => 'Week';

  void setPeriod(String period) {
    state = period;
  }
}

@riverpod
ProjectSummary projectSummary(Ref ref) {
  final period = ref.watch(selectedProjectPeriodProvider);
  return ProjectRepository.getSummary(period);
}
