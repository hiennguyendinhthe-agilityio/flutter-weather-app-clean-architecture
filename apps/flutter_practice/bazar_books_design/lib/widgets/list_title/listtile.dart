import 'package:bazar_books_design/constants.dart';
import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class BazUiListTile extends StatelessWidget {
  const BazUiListTile(
      {super.key,
      this.leading,
      required this.title,
      required this.subtitle,
      this.onTap});

  final String? leading;
  final String? title;
  final String? subtitle;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(
            leading ?? Constants.imgUrlDefault,
          ),
        ),
        title: Text(
          title ?? Constants.titleDefault,
          style: context.textTheme.titleMedium,
        ),
        subtitle: Text(
          maxLines: 2,
          subtitle ?? Constants.titleDefault,
          style: context.textTheme.titleSmall,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
