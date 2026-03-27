import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final String subtitle;
  final String price;
  final Color color;
  final IconData icon;
  final bool isPopular;

  const MenuItem({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.color,
    required this.icon,
    this.isPopular = false,
  });
}

const List<MenuItem> menuItems = [
  MenuItem(
    title: 'Signature Burger',
    subtitle: 'Beef patty, cheddar, caramelized onions',
    price: '\$18.99',
    color: Color(0xFFFF6B6B),
    icon: Icons.lunch_dining,
    isPopular: true,
  ),
  MenuItem(
    title: 'Caesar Salad',
    subtitle: 'Romaine, croutons, parmesan, Caesar dressing',
    price: '\$12.99',
    color: Color(0xFF00BFA5),
    icon: Icons.eco,
  ),
  MenuItem(
    title: 'Grilled Salmon',
    subtitle: 'Atlantic salmon, lemon butter, asparagus',
    price: '\$26.99',
    color: Color(0xFF26C6DA),
    icon: Icons.set_meal,
    isPopular: true,
  ),
  MenuItem(
    title: 'Truffle Pasta',
    subtitle: 'Fettuccine, black truffle, cream sauce',
    price: '\$22.99',
    color: Color(0xFF6C63FF),
    icon: Icons.ramen_dining,
  ),
  MenuItem(
    title: 'BBQ Ribs',
    subtitle: 'Slow-cooked pork ribs, smoky BBQ sauce',
    price: '\$32.99',
    color: Color(0xFFFFB300),
    icon: Icons.outdoor_grill,
    isPopular: true,
  ),
  MenuItem(
    title: 'Chocolate Lava Cake',
    subtitle: 'Warm chocolate cake, vanilla ice cream',
    price: '\$9.99',
    color: Color(0xFF8D6E63),
    icon: Icons.cake,
  ),
];
