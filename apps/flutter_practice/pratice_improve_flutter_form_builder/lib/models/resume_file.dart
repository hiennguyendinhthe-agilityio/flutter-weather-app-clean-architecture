class ResumeFile {
  final String path;
  final String name;
  final int size;

  ResumeFile({required this.path, required this.name, required this.size});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResumeFile &&
          runtimeType == other.runtimeType &&
          path == other.path &&
          name == other.name &&
          size == other.size;

  @override
  int get hashCode => path.hashCode ^ name.hashCode ^ size.hashCode;
}
