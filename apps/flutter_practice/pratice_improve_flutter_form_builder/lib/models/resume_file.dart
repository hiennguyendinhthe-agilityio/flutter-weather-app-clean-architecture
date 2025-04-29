class ResumeFile {
  final String id;
  final String name;
  final int size;

  ResumeFile({required this.id, required this.name, required this.size});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResumeFile &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          size == other.size;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ size.hashCode;
}
