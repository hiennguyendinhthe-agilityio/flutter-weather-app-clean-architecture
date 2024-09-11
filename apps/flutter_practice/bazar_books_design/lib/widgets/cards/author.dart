import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class Author extends StatelessWidget {
  const Author({
    super.key,
    this.name = '',
    this.role = '',
    this.imageUrl,
    this.width = 127,
    this.style,
  });
  final String name;
  final String role;
  final String? imageUrl;
  final double width;
  final TextStyle? style;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      shadowColor: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(imageUrl ?? ''),
          ),
          const SizedBox(height: 10),
          Text(
            name,
            style: style ?? context.textTheme.labelLarge,
          ),
          Text(
            role,
            style: style ?? context.textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}
