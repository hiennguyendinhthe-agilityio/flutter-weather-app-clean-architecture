/// User model representing a user in the system
class User {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final List<String> teamIds;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.teamIds = const [],
  });

  /// Create a copy of the user with updated fields
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    List<String>? teamIds,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      teamIds: teamIds ?? this.teamIds,
    );
  }

  /// Convert user to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'teamIds': teamIds,
    };
  }

  /// Create user from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      teamIds: List<String>.from(json['teamIds'] ?? []),
    );
  }
}

/// Team model representing a team workspace
class Team {
  final String id;
  final String name;
  final String description;
  final List<String> memberIds;
  final String ownerId;
  final DateTime createdAt;

  const Team({
    required this.id,
    required this.name,
    required this.description,
    required this.memberIds,
    required this.ownerId,
    required this.createdAt,
  });

  /// Create a copy of the team with updated fields
  Team copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? memberIds,
    String? ownerId,
    DateTime? createdAt,
  }) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      memberIds: memberIds ?? this.memberIds,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Convert team to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'memberIds': memberIds,
      'ownerId': ownerId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create team from JSON
  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      memberIds: List<String>.from(json['memberIds'] ?? []),
      ownerId: json['ownerId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
