import 'package:flutter/material.dart';

class CardData {
  final String name;
  final String role;
  final Color color;
  final IconData icon;
  final List<String> tags;

  const CardData({
    required this.name,
    required this.role,
    required this.color,
    required this.icon,
    required this.tags,
  });
}

final List<CardData> cardsDataList = [
  const CardData(
    name: 'John Doe',
    role: 'Flutter Developer',
    color: Colors.blue,
    icon: Icons.person,
    tags: ['Flutter', 'Dart', 'Mobile', 'Web'],
  ),
  const CardData(
    name: 'Jane Doe',
    role: 'UI/UX Designer',
    color: Colors.pink,
    icon: Icons.person,
    tags: ['Flutter', 'Dart', 'Mobile', 'Web'],
  ),
  const CardData(
    name: 'Flutter',
    role: 'UI Framework',
    color: Color(0xFF6C63FF),
    icon: Icons.flutter_dash,
    tags: ['Cross-platform', 'Fast', 'Beautiful'],
  ),
  const CardData(
    name: 'Dart',
    role: 'Programming Language',
    color: Color(0xFF00BFA5),
    icon: Icons.code,
    tags: ['Type-safe', 'AOT', 'Async'],
  ),
  const CardData(
    name: 'Animation',
    role: 'Module 5',
    color: Color(0xFFFF6B6B),
    icon: Icons.animation,
    tags: ['Implicit', 'Explicit', 'Physics'],
  ),
  const CardData(
    name: 'CustomPainter',
    role: 'Canvas Drawing',
    color: Color(0xFFFFB300),
    icon: Icons.brush,
    tags: ['Path', 'Canvas', 'Paint'],
  ),
  const CardData(
    name: 'Isolates',
    role: 'Concurrency',
    color: Color(0xFF26C6DA),
    icon: Icons.sync_alt,
    tags: ['Background', 'Thread', 'Async'],
  ),
];

final List<CardData> cardDataList = [
  const CardData(
    name: 'Flutter',
    role: 'UI Framework',
    color: Color(0xFF6C63FF),
    icon: Icons.flutter_dash,
    tags: ['Cross-platform', 'Fast', 'Beautiful'],
  ),
  const CardData(
    name: 'Dart',
    role: 'Programming Language',
    color: Color(0xFF00BFA5),
    icon: Icons.code,
    tags: ['Type-safe', 'AOT', 'Async'],
  ),
  const CardData(
    name: 'Animation',
    role: 'Module 5',
    color: Color(0xFFFF6B6B),
    icon: Icons.animation,
    tags: ['Implicit', 'Explicit', 'Physics'],
  ),
  const CardData(
    name: 'CustomPainter',
    role: 'Canvas Drawing',
    color: Color(0xFFFFB300),
    icon: Icons.brush,
    tags: ['Path', 'Canvas', 'Paint'],
  ),
  const CardData(
    name: 'Isolates',
    role: 'Concurrency',
    color: Color(0xFF26C6DA),
    icon: Icons.sync_alt,
    tags: ['Background', 'Thread', 'Async'],
  ),
];
