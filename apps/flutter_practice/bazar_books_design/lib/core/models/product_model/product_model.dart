// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

part 'product_model.g.dart';

// Product model
// @JsonCodable()
@collection
class Product {
  Id idIsa = Isar.autoIncrement; // Auto-increment ID managed by Isar

  late String id;
  late String? userId;

  String? title;
  String? price;
  String? discount;
  String? imageUrl;
  List<String>? imageUrlOffer;
  String? description;
  int? starRating;
  String? logoVendor;
  String? category;
  bool? favorite;

  Product({
    required this.id,
    this.userId, // id from API
    this.title,
    this.price,
    this.discount,
    this.imageUrl,
    this.description,
    this.starRating,
    this.logoVendor,
    this.imageUrlOffer,
    this.category,
    this.favorite,
  });

  // Convert from API JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'], // id from API
      title: json['title'],
      price: json['price'],
      imageUrl: json['imageUrl'],
      imageUrlOffer: json['imageUrlOffer']?.cast<String>(),
      discount: json['discount'],
      logoVendor: json['logoVendor'],
      description: json['description'],
      starRating: json['starRating'],
      category: json['category'],
      favorite: json['favorite'],
    );
  }

  // Convert to API JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id, // id from API
      'title': title,
      'price': price,
      'imageUrl': imageUrl,
      'imageUrlOffer': imageUrlOffer,
      'discount': discount,
      'logoVendor': logoVendor,
      'description': description,
      'starRating': starRating,
      'category': category,
      'favorite': favorite,
    };
  }
}

class ProductApi extends Equatable {
  final String id;
  late String? userId;

  String? title;
  String? price;
  String? discount;
  String? imageUrl;
  List<String>? imageUrlOffer;
  String? description;
  int? starRating;
  String? logoVendor;
  String? category;
  bool? favorite;

  ProductApi({
    required this.id,
    this.userId, // id from API
    this.title,
    this.price,
    this.discount,
    this.imageUrl,
    this.description,
    this.starRating,
    this.logoVendor,
    this.imageUrlOffer,
    this.category,
    this.favorite,
  });

  // Convert from API JSON
  factory ProductApi.fromJson(Map<String, dynamic> json) {
    return ProductApi(
      id: json['id'], // id from API
      title: json['title'],
      price: json['price'],
      imageUrl: json['imageUrl'],
      imageUrlOffer: json['imageUrlOffer']?.cast<String>(),
      discount: json['discount'],
      logoVendor: json['logoVendor'],
      description: json['description'],
      starRating: json['starRating'],
      category: json['category'],
      favorite: json['favorite'],
      userId: json['userId'],
    );
  }

  // Convert to API JSON
  @override
  List<Object?> get props => [
        id,
        title,
        price,
        imageUrl,
        imageUrlOffer,
        discount,
        logoVendor,
        description,
        starRating,
        category,
        favorite,
        userId
      ];
}
