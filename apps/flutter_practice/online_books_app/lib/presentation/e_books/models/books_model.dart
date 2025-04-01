class Books {
  final String id;
  final String? fullName;
  final String? occupation;
  final String? biography;
  final String? avatarUrl;
  final int? starRating;
  final String? pdfUrl;

  Books({
    required this.id,
    this.fullName,
    this.occupation,
    this.biography,
    this.avatarUrl,
    this.starRating,
    this.pdfUrl,
  });

  factory Books.fromJson(Map<String, dynamic> json) => Books(
        id: json['id'] as String,
        fullName: json['fullName'] as String?,
        occupation: json['occupation'] as String?,
        biography: json['biography'] as String?,
        avatarUrl: json['avatarUrl'] as String?,
        starRating: json['starRating'] as int?,
        pdfUrl: json['pdfUrl'] as String?,
      );
}
