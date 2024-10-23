class Author {
  final String id;
  final String? fullName;
  final String? occupation;
  final String? biography;
  final String? avatarUrl;
  final int? starRating;

  Author({
    required this.id,
    this.fullName,
    this.occupation,
    this.biography,
    this.avatarUrl,
    this.starRating,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'],
      fullName: json['fullName'],
      occupation: json['occupation'],
      biography: json['biography'],
      avatarUrl: json['avatarUrl'],
      starRating: json['starRating'],
    );
  }
}
