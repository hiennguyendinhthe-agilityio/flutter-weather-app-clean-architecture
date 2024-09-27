import 'package:flutter/material.dart';

class DetailTitle extends StatelessWidget {
  final String title;

  const DetailTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge,
      maxLines: 1,
    );
  }
}
