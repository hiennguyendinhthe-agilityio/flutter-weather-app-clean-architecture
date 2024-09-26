class Author {
  final String id;
  final String? flullName;
  final String? occupation;
  final String? biography;
  final String? avatarUrl;

  Author({
    required this.id,
    this.flullName,
    this.occupation,
    this.biography,
    this.avatarUrl,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'],
      flullName: json['flullName'],
      occupation: json['occupation'],
      biography: json['biography'],
      avatarUrl: json['avatarUrl'],
    );
  }
}
