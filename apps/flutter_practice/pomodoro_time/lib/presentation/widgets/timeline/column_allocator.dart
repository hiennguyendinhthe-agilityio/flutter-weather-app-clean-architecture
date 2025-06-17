import 'timeline_event.dart';

bool _overlaps<T>(TimelineEvent<T> a, TimelineEvent<T> b) {
  return a.start.isBefore(b.end) && b.start.isBefore(a.end);
}

List<List<TimelineEvent<T>>> allocateColumns<T>(
  List<TimelineEvent<T>> events,
) {
  final columns = <List<TimelineEvent<T>>>[];
  for (var event in events) {
    var placed = false;
    for (var col in columns) {
      if (!col.any((e) => _overlaps(e, event))) {
        col.add(event);
        placed = true;
        break;
      }
    }
    if (!placed) {
      columns.add([event]);
    }
  }
  return columns;
}
