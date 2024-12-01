// @JsonCodable()
class Vendor {
  const Vendor({
    required this.id,
    this.headlines,
    this.numberStar,
    this.imageUrl,
    this.starRating,
    this.publications,
  });
  final String id;
  final String? headlines;
  final int? numberStar;
  final String? imageUrl;
  final int? starRating;
  final String? publications;

  factory Vendor.fromJson(Map<String, dynamic> json) => Vendor(
        id: json['id'],
        headlines: json['headlines'],
        numberStar: json['numberStar'],
        imageUrl: json['imageUrl'],
        starRating: json['starRating'],
        publications: json['publications'],
      );
}
