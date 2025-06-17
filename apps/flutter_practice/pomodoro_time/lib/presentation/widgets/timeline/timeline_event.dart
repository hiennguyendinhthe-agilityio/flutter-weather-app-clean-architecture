class TimelineEvent<T> {
  final T data;
  final DateTime start;
  final DateTime end;

  TimelineEvent({
    required this.data,
    required this.start,
    required this.end,
  });
}
