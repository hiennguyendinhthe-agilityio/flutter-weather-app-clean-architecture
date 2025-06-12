class TimelineEvent<T> {
  final DateTime start;
  final DateTime end;
  final T data;

  TimelineEvent({
    required this.start,
    required this.end,
    required this.data,
  });
}
