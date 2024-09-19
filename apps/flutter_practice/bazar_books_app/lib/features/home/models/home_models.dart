import 'package:bazar_books_app/features/home/widgets/detail_menu/detail_menu_page.dart';
import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:flutter/material.dart';

class AuthorsSection extends StatelessWidget {
  const AuthorsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          Author(
            name: 'John Freeman',
            role: 'Writer',
            imageUrl:
                'https://www.hubspot.com/hs-fs/hubfs/parts-url_1.webp?width=1190&height=800&name=parts-url_1.webp',
          ),
          Author(
            name: 'John Freeman',
            role: 'Writer',
            imageUrl:
                'https://www.hubspot.com/hs-fs/hubfs/parts-url_1.webp?width=1190&height=800&name=parts-url_1.webp',
          ),
          Author(
            name: 'John Freeman',
            role: 'Writer',
            imageUrl:
                'https://www.hubspot.com/hs-fs/hubfs/parts-url_1.webp?width=1190&height=800&name=parts-url_1.webp',
          ),
        ],
      ),
    );
  }
}

class TopOfWeekBooks extends StatelessWidget {
  const TopOfWeekBooks({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          BookCard(
            onTap: () {
              BazUiBottomSheet.showModal(
                context,
                child: const DetailMenuPage(),
              );
            },
            title: 'The Kite Runner',
            price: '\$14.99',
            imageUrl:
                'https://www.hubspot.com/hs-fs/hubfs/parts-url_1.webp?width=1190&height=800&name=parts-url_1.webp',
          ),
        ],
      ),
    );
  }
}

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
        return VendorCard(
          headlines: vendors[index]['name']!,
          imageUrl: vendors[index]['image']!,
        );
      },
    );
  }
}
