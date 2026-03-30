import 'package:flutter/material.dart';

class Category {
  final String name;
  final IconData icon;
  final Color color;

  Category({required this.name, required this.icon, required this.color});
}

class Product {
  final String name;
  final String category;
  final String price;
  final double rating;
  final Color color;
  final IconData icon;

  Product({
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.color,
    required this.icon,
  });
}

// Categories
List<Category> categories = [
  Category(name: 'All', icon: Icons.grid_view, color: Color(0xFF6C63FF)),
  Category(name: 'Food', icon: Icons.restaurant, color: Color(0xFFFF6B6B)),
  Category(name: 'Drinks', icon: Icons.local_cafe, color: Color(0xFF00BFA5)),
  Category(name: 'Dessert', icon: Icons.cake, color: Color(0xFFFFB300)),
  Category(name: 'Healthy', icon: Icons.eco, color: Color(0xFF66BB6A)),
];

// Products grouped by category
Map<String, List<Product>> productsByCategory = {
  'Popular': [
    Product(
      name: 'Signature Burger',
      category: 'Food',
      price: '\$18.99',
      rating: 4.9,
      color: Color(0xFFFF6B6B),
      icon: Icons.lunch_dining,
    ),
    Product(
      name: 'Truffle Pasta',
      category: 'Food',
      price: '\$22.99',
      rating: 4.8,
      color: Color(0xFF6C63FF),
      icon: Icons.ramen_dining,
    ),
    Product(
      name: 'Green Smoothie',
      category: 'Drinks',
      price: '\$8.99',
      rating: 4.7,
      color: Color(0xFF66BB6A),
      icon: Icons.local_cafe,
    ),
  ],
  'New Arrivals': [
    Product(
      name: 'Dragon Roll',
      category: 'Food',
      price: '\$24.99',
      rating: 4.6,
      color: Color(0xFF26C6DA),
      icon: Icons.set_meal,
    ),
    Product(
      name: 'Matcha Latte',
      category: 'Drinks',
      price: '\$6.99',
      rating: 4.8,
      color: Color(0xFF00BFA5),
      icon: Icons.emoji_food_beverage,
    ),
    Product(
      name: 'Lava Cake',
      category: 'Dessert',
      price: '\$9.99',
      rating: 4.9,
      color: Color(0xFF8D6E63),
      icon: Icons.cake,
    ),
  ],
  'Recommended': [
    Product(
      name: 'Grilled Salmon',
      category: 'Food',
      price: '\$26.99',
      rating: 4.7,
      color: Color(0xFFFF8A65),
      icon: Icons.outdoor_grill,
    ),
    Product(
      name: 'Acai Bowl',
      category: 'Healthy',
      price: '\$14.99',
      rating: 4.8,
      color: Color(0xFF7E57C2),
      icon: Icons.spa,
    ),
    Product(
      name: 'Mango Tango',
      category: 'Drinks',
      price: '\$7.99',
      rating: 4.6,
      color: Color(0xFFFFB300),
      icon: Icons.blender,
    ),
  ],
};
