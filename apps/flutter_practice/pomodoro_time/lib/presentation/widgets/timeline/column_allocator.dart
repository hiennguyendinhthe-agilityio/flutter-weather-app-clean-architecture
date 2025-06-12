class ColumnAllocator<T> {
  List<List<T>> allocate(
    List<T> items,
    bool Function(T a, T b) overlaps,
  ) {
    final cols = <List<T>>[];
    for (var item in items) {
      var placed = false;
      for (var col in cols) {
        if (!col.any((other) => overlaps(other, item))) {
          col.add(item);
          placed = true;
          break;
        }
      }
      if (!placed) cols.add([item]);
    }
    return cols;
  }
}
