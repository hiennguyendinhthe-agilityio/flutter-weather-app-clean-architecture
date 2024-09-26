import 'package:bazar_books_design/widgets/cards/author.dart';
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
          BazUiAuthor(
            name: 'John Freeman',
            role: 'Writer',
            imageUrl:
                'https://www.hubspot.com/hs-fs/hubfs/parts-url_1.webp?width=1190&height=800&name=parts-url_1.webp',
          ),
          BazUiAuthor(
            name: 'John Freeman',
            role: 'Writer',
            imageUrl:
                'https://www.hubspot.com/hs-fs/hubfs/parts-url_1.webp?width=1190&height=800&name=parts-url_1.webp',
          ),
          BazUiAuthor(
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
