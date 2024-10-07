class Product {
  Product({
    required this.id,
    this.title,
    this.price,
    this.discount,
    this.imageUrl,
    this.description,
    this.starRating,
    this.logoVendor,
    this.imageUrlOffer,
  });

  final String id;
  final String? title;
  final String? price;
  final String? logoVendor;
  final String? discount;
  final String? imageUrl;
  final List<String>? imageUrlOffer;
  final String? description;
  final int? starRating;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: json['price'],
      imageUrl: json['imageUrl'],
      imageUrlOffer: json['imageUrlOffer']?.cast<String>(),
      discount: json['discount'],
      logoVendor: json['logoVendor'],
      description: json['description'],
      starRating: json['starRating'],
    );
  }
}
