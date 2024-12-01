import 'package:isar/isar.dart';

part 'product_model.g.dart';

// Product model
// @JsonCodable()
@collection
class Product {
  Id idIsa = Isar.autoIncrement; // Auto-increment ID managed by Isar

  late String apiId;

  String? title;
  String? price;
  String? discount;
  String? imageUrl;
  List<String>? imageUrlOffer;
  String? description;
  int? starRating;
  String? logoVendor;
  String? category;

  Product({
    required this.apiId, // id from API
    this.title,
    this.price,
    this.discount,
    this.imageUrl,
    this.description,
    this.starRating,
    this.logoVendor,
    this.imageUrlOffer,
    this.category,
  });

  // Convert from API JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      apiId: json['id'], // id from API
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
