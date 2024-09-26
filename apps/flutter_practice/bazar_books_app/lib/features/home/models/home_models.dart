import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:flutter/material.dart';

class VendorsGrid extends StatelessWidget {
  VendorsGrid({super.key});
  final List<Map<String, String>> vendors = [
    {
      'name': 'Wattpad',
      'image':
          'https://www.hubspot.com/hs-fs/hubfs/parts-url_1.webp?width=1190&height=800&name=parts-url_1.webp',
    },
    {
      'name': 'Kuromi',
      'image':
          'https://www.hubspot.com/hs-fs/hubfs/parts-url_1.webp?width=1190&height=800&name=parts-url_1.webp',
    },
    {
      'name': 'Crane & Co',
      'image':
          'https://www.hubspot.com/hs-fs/hubfs/parts-url_1.webp?width=1190&height=800&name=parts-url_1.webp',
    },
    {
      'name': 'GooDay',
      'image':
          'https://www.hubspot.com/hs-fs/hubfs/parts-url_1.webp?width=1190&height=800&name=parts-url_1.webp',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
        childAspectRatio: 0.7,
      ),
      itemCount: vendors.length,
      itemBuilder: (context, index) {
        return BazUiVendorCard(
          headlines: vendors[index]['name']!,
          imageUrl: vendors[index]['image']!,
        );
      },
    );
  }
}
