import 'package:isar/isar.dart';

part 'product_model.g.dart';

@collection
class Product {
  Id id = Isar.autoIncrement; // Auto-increment ID managed by Isar

// Field to save id from API
  late String apiId;

  String? title;
  String? price;
  String? discount;
  String? imageUrl;
  List<String>? imageUrlOffer;
  String? description;
  int? starRating;
  String? logoVendor;

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
