/// Gom các item không chồng lấn vào từng “cột”
class ColumnAllocator<T> {
  List<List<T>> allocate(
    List<T> items,
    bool Function(T a, T b) overlaps,
  ) {
    final cols = <List<T>>[];
    for (final item in items) {
      var placed = false;
      for (final col in cols) {
        if (!col.any((other) => overlaps(other, item))) {
          col.add(item);
          placed = true;
          break;
        }
      }
      if (!placed) {
        cols.add([item]);
      }
    }
    return cols;
  }
}
