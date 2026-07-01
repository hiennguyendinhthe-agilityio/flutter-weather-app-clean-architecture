class WorkoutFilterState {
  final String query;
  final String? level;

  const WorkoutFilterState({this.query = '', this.level});

  WorkoutFilterState copyWith({String? query, Object? level = _sentinel}) {
    return WorkoutFilterState(
      query: query ?? this.query,
      level: level == _sentinel ? this.level : level as String?,
    );
  }

  bool get hasActiveFilters => query.trim().isNotEmpty || level != null;
}

const Object _sentinel = Object();
