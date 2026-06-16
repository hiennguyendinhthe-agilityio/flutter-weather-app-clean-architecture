enum Priority {
  low(label: 'Low', order: 1),
  medium(label: 'Medium', order: 2),
  high(label: 'High', order: 3);

  final String label;
  final int order;

  const Priority({required this.label, required this.order});

  static Priority fromString(String value) {
    return Priority.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => Priority.medium,
    );
  }
}
