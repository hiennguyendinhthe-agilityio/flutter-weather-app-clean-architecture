class Product {
  final String id;
  final String? title;
  final String? price;
  final String? discount;
  final String? imageUrl;

  Product({
    required this.id,
    this.title,
    this.price,
    this.discount,
    this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: json['price'],
      discount: json['discount'],
      imageUrl: json['imageUrl'],
    );
  }
}
