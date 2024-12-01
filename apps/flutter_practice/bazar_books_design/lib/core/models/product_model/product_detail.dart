// Product model
import 'package:json/json.dart';

@JsonCodable()
class ProductDetailModel {
  late String id;

  String? title;
  String? price;
  String? discount;
  String? imageUrl;
  List<String>? imageUrlOffer;
  String? description;
  int? starRating;
  String? logoVendor;

  ProductDetailModel({
    required this.id, // id from API
    this.title,
    this.price,
    this.discount,
    this.imageUrl,
    this.description,
    this.starRating,
    this.logoVendor,
    this.imageUrlOffer,
  });
}
