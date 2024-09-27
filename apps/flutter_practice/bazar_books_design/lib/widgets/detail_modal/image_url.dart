import 'package:flutter/material.dart';

class ImageUrl extends StatelessWidget {
  final String imageUrl;

  const ImageUrl({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 69),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          imageUrl,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
