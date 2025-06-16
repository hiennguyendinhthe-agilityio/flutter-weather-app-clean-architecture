/// Mô tả một event bất kỳ trên timeline
class TimelineEvent<T> {
  final DateTime start;
  final DateTime end;
  final T data;

  const TimelineEvent({
    required this.start,
    required this.end,
    required this.data,
  });
}
