class Vendor {
  final String id;
  final String? headlines;
  final String? numberStar;
  final String? imageUrl;

  Vendor({
    required this.id,
    this.headlines,
    this.numberStar,
    this.imageUrl,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      id: json['id'],
      headlines: json['headlines'],
      numberStar: json['numberStar'],
      imageUrl: json['imageUrl'],
    );
  }
}
