// ignore_for_file: depend_on_referenced_packages

import 'package:bazar_books_design/widgets/cards/cards.dart';
import 'package:bazar_books_design/widgets/cards/offer_card.dart';
import 'package:bazar_books_design/widgets/page_indicator/page_indicator.dart';
import 'package:bazar_books_design/widgets/texts/texts.dart';
import 'package:bazar_books_widgetbook/widgetbook.container.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

WidgetbookComponent carouselWidgetbooks() {
  return WidgetbookComponent(
    name: 'BazUiCarousel',
    useCases: [
      WidgetbookUseCase(
        name: 'Carousel',
        builder: (context) {
          return BazUiWidgetbook(
              copyCode: '''
          BazUiElevatedButton.showModal<void>(
            context,
            child: Container(),
          )''',
              child: Column(
                children: [
                  BazUiRegularBodyText3(
                    text: 'Carousel',
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const ExampleCarousel(),
                ],
              ));
        },
      ),
    ],
  );
}

class ExampleCarousel extends StatelessWidget {
  const ExampleCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: pageController,
            itemCount: 3,
            itemBuilder: (context, index) {
              return BazUiOfferCard(
                discount: '3',
                imageUrls: const [
                  'https://www.hubspot.com/hs-fs/hubfs/parts-url_1.webp?width=1190&height=800&name=parts-url_1.webp',
                ],
                onTap: () {},
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        BazUiPageIndicator(
          pageController: pageController,
        ),
      ],
    );
  }
}
