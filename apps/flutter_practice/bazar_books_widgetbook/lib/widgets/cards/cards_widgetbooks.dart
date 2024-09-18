// ignore_for_file: depend_on_referenced_packages

import 'package:bazar_books_design/widgets/cards/cards.dart';
import 'package:bazar_books_design/widgets/texts/texts.dart';
import 'package:bazar_books_widgetbook/widgetbook.container.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

WidgetbookComponent cardWidgetBooks() {
  return WidgetbookComponent(
    name: 'BazUiCard',
    useCases: [
      WidgetbookUseCase(
        name: 'BazUiCard',
        builder: (context) => BazUiWidgetbook(
          copyCode: 'cardWidgetBooks()',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BazUiRegularBodyText3(
                text: 'card books WidgetBooks',
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(
                height: 20,
              ),
              const Row(
                children: [
                  // BookCard(
                  //   imageUrl:
                  //       'https://www.hubspot.com/hs-fs/hubfs/parts-url_1.webp?width=1190&height=800&name=parts-url_1.webp',
                  //   title: 'dqd',
                  //   price: '123123asd',
                  //   onTap: () {},
                  // ),
                  // BookCard(
                  //   imageUrl:
                  //       'https://www.hubspot.com/hs-fs/hubfs/parts-url_1.webp?width=1190&height=800&name=parts-url_1.webp',
                  //   title: '123213',
                  //   price: '123123',
                  //   onTap: () {},
                  // ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              BazUiRegularBodyText3(
                text: 'card books WidgetBooks',
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(
                height: 20,
              ),
              const Row(
                children: [
                  Author(
                    imageUrl:
                        'https://www.hubspot.com/hs-fs/hubfs/parts-url_1.webp?width=1190&height=800&name=parts-url_1.webp',
                    name: 'dqd',
                    role: '123123asd',
                  ),
                  Author(
                    imageUrl:
                        'https://www.hubspot.com/hs-fs/hubfs/parts-url_1.webp?width=1190&height=800&name=parts-url_1.webp',
                    name: 'dqd',
                    role: '123123asd',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
