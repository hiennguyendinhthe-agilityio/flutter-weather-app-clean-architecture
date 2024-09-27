import 'package:flutter/material.dart';

class DetailDescription extends StatelessWidget {
  final String description;

  const DetailDescription({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      style: Theme.of(context).textTheme.labelMedium,
    );
  }
}
