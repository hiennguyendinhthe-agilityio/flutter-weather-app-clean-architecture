import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String priceDisplay;
  final double price;
  final Color titleColor;
  final String imageAsset;
  final String description;
  final String category;
  final int calories;
  final double rating;
  final bool isFavorite;

  const Product({
    required this.id,
    required this.name,
    required this.priceDisplay,
    required this.price,
    required this.titleColor,
    required this.imageAsset,
    required this.description,
    required this.category,
    this.calories = 140,
    this.rating = 4.9,
    this.isFavorite = false,
  });

  Product copyWith({
    String? id,
    String? name,
    String? priceDisplay,
    double? price,
    Color? titleColor,
    String? imageAsset,
    String? description,
    String? category,
    int? calories,
    double? rating,
    bool? isFavorite,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      priceDisplay: priceDisplay ?? this.priceDisplay,
      price: price ?? this.price,
      titleColor: titleColor ?? this.titleColor,
      imageAsset: imageAsset ?? this.imageAsset,
      description: description ?? this.description,
      category: category ?? this.category,
      calories: calories ?? this.calories,
      rating: rating ?? this.rating,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
