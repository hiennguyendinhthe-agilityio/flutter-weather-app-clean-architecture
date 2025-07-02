class ProjectModel {
  final String projectName;
  final String clientName;
  final String clientRole;
  final String avatarUrl;

  ProjectModel({
    required this.projectName,
    required this.clientName,
    required this.clientRole,
    required this.avatarUrl,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectModel &&
          runtimeType == other.runtimeType &&
          projectName == other.projectName;

  @override
  int get hashCode => projectName.hashCode;

  String get fullClientInfo => '$clientName ($clientRole)';
}
