// ignore_for_file: lines_longer_than_80_chars

import 'package:bazar_books_widgetbook/widgetbook.container.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

WidgetbookComponent typographyWidgetBooks() {
  return WidgetbookComponent(
    name: 'Typography',
    useCases: [
      WidgetbookUseCase(
        name: 'All',
        builder: (context) => BazUiWidgetbook(
          copyCode: '''
  Text(
        'DisplayLarge (size: {textTheme.displayLarge!.fontSize!.toInt()})',
                      style:
                      textTheme.displayLarge!.copyWith(color: textThemeColor),
                ),''',
          child: _TextThemeWidgetBook(
            textTheme: Theme.of(context).textTheme,
            textThemeColor: Colors.black,
          ),
        ),
      ),
    ],
  );
}

class _TextThemeWidgetBook extends StatelessWidget {
  const _TextThemeWidgetBook({
    Key? key,
    required this.textTheme,
    required this.textThemeColor,
  }) : super(key: key);

  final TextTheme textTheme;

  final Color textThemeColor;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // const Divider(),
            const Text(
              'Typography typescale',
              style: TextStyle(
                fontSize: 30,
                color: Colors.black,
              ),
            ),
            const Divider(),
            const SizedBox(height: 10),
            Text(
              'DisplayLarge (size: ${textTheme.displayLarge!.fontSize!.toInt()})',
              style: textTheme.displayLarge!.copyWith(color: textThemeColor),
            ),
            const SizedBox(height: 10),
            Text(
              'HeadlineLarge (size: ${textTheme.headlineLarge!.fontSize!.toInt()})',
              style: textTheme.headlineLarge!.copyWith(color: textThemeColor),
            ),
            const SizedBox(height: 10),
            Text(
              'HeadlineMedium (size: ${textTheme.headlineMedium!.fontSize!.toInt()})',
              style: textTheme.headlineMedium!.copyWith(color: textThemeColor),
            ),
            const SizedBox(height: 10),
            Text(
              'HeadlineSmall (size: ${textTheme.headlineSmall!.fontSize!.toInt()})',
              style: textTheme.headlineSmall!.copyWith(color: textThemeColor),
            ),
            const SizedBox(height: 10),
            Text(
              'TitleLarge (size: ${textTheme.titleLarge!.fontSize!.toInt()})',
              style: textTheme.titleLarge!.copyWith(color: textThemeColor),
            ),
            const SizedBox(height: 10),
            Text(
              'TitleSmall (size: ${textTheme.titleSmall!.fontSize!.toInt()})',
              style: textTheme.titleSmall!.copyWith(color: textThemeColor),
            ),
            const SizedBox(height: 10),
            Text(
              'LabelLarge (size: ${textTheme.labelLarge!.fontSize!.toInt()})',
              style: textTheme.labelLarge!.copyWith(color: textThemeColor),
            ),
            const SizedBox(height: 10),
            Text(
              'BodyMedium (size: ${textTheme.bodyMedium!.fontSize!.toInt()})',
              style: textTheme.bodyMedium!.copyWith(color: textThemeColor),
            ),
            const SizedBox(height: 10),
            Text(
              'BodySmall (size: ${textTheme.bodySmall!.fontSize!.toInt()})',
              style: textTheme.bodySmall!.copyWith(color: textThemeColor),
            ),
            const SizedBox(height: 10),
            Text(
              'LabelSmall (size: ${textTheme.labelSmall!.fontSize!.toInt()})',
              style: textTheme.labelSmall!.copyWith(color: textThemeColor),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
