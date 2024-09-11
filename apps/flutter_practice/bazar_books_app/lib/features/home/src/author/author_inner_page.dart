import 'package:bazar_books_app/features/home/src/author/models/author_inner_model.dart';
import 'package:bazar_books_design/widgets/author_profile/author_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AuthorInnerPage extends StatelessWidget {
  const AuthorInnerPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AuthorProfile(
      title: 'Authors',
      authorName: 'Tess Gunty',
      authorRole: 'Novelist',
      authorImage:
          'https://www.hubspot.com/hs-fs/hubfs/parts-url_1.webp?width=1190&height=800&name=parts-url_1.webp',
      rating: RatingBar.builder(
        initialRating: 4,
        minRating: 1,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
        itemBuilder: (context, _) => const Icon(
          Icons.star,
          color: Colors.amber,
        ),
        onRatingUpdate: (rating) {},
      ),
      description:
          'Gunty was born and raised in South Bend, Indiana. She graduated from the University of Notre Dame with a Bachelor of Arts in English and from New York University.',
      products: products,
    );
  }
}
