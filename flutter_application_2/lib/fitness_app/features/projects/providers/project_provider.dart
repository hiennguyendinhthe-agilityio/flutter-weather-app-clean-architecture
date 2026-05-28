import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/project_repository.dart';
import '../models/project_data.dart';

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
