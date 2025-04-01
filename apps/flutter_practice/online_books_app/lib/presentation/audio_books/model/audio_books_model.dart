class AudioBooks {
  final String id;
  final String? fullName;
  final String? occupation;
  final String? biography;
  final String? avatarUrl;
  final int? starRating;
  final String? duration;

  AudioBooks({
    required this.id,
    this.fullName,
    this.occupation,
    this.biography,
    this.avatarUrl,
    this.starRating,
    this.duration,
  });

  factory AudioBooks.fromJson(Map<String, dynamic> json) => AudioBooks(
        id: json['id'] as String,
        fullName: json['fullName'] as String?,
        occupation: json['occupation'] as String?,
        biography: json['biography'] as String?,
        avatarUrl: json['avatarUrl'] as String?,
        starRating: json['starRating'] as int?,
        duration: json['duration'] as String?,
      );
}
