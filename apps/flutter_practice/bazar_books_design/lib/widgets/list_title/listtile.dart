import 'package:flutter/material.dart';

class BazUiListTile extends StatelessWidget {
  const BazUiListTile(
      {super.key,
      required this.leading,
      required this.title,
      required this.subtitle,
      this.onTap});

  final String leading;
  final String title;
  final String subtitle;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(leading),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          maxLines: 2,
          subtitle,
          style: const TextStyle(fontSize: 14),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
