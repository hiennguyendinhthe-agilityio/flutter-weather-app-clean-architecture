class ProductModel {
  final String id;
  final String title;
  final double price;
  final int discount;
  final String imageUrl;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.discount,
    required this.imageUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      price: json['price'],
      discount: json['discount'],
      imageUrl: json['imageUrl'],
    );
  }
}
