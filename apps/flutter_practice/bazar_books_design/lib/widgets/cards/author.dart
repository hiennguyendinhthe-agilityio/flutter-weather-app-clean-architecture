import 'package:bazar_books_design/constants.dart';
import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class BazUiAuthor extends StatelessWidget {
  const BazUiAuthor({
    super.key,
    this.fullName,
    this.occupation = '',
    this.imageUrl,
    this.width = 127,
    this.style,
  });
  final String? fullName;
  final String? occupation;
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
            backgroundImage: NetworkImage(
              imageUrl ?? Constants.imgUrlDefault,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            fullName ?? Constants.titleDefault,
            style: style ?? context.textTheme.labelLarge,
          ),
          Text(
            occupation ?? Constants.titleDefault,
            style: style ?? context.textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}
