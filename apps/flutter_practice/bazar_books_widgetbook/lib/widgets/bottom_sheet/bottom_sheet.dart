// ignore_for_file: depend_on_referenced_packages

import 'package:bazar_books_design/constants.dart';
import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:bazar_books_design/widgets/bottom_sheet/bottom_sheet.dart';
import 'package:bazar_books_design/widgets/buttons/buttons.dart';
import 'package:bazar_books_design/widgets/detail_modal/amount.dart';
import 'package:bazar_books_design/widgets/detail_modal/description.dart';
import 'package:bazar_books_design/widgets/detail_modal/favorite_button.dart';
import 'package:bazar_books_design/widgets/detail_modal/image_url.dart';
import 'package:bazar_books_design/widgets/detail_modal/star_rating.dart';
import 'package:bazar_books_design/widgets/detail_modal/title.dart';
import 'package:bazar_books_widgetbook/widgetbook.container.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

WidgetbookComponent bottomSheetWidgetbooks() {
  return WidgetbookComponent(
    name: 'BazUiBottomSheet',
    useCases: [
      WidgetbookUseCase(
        name: 'BottomSheet',
        builder: (context) {
          return BazUiWidgetbook(
            copyCode: '''
          BazUiElevatedButton.showModal<void>(
            context,
            child: Container(),
          )''',
            child: Column(
              children: [
                BazUiElevatedButton(
                  text: context.bazS.orderNow,
                  onPressed: () {
                    BazUiBottomSheet.showModal(
                      context,
                      child: const Example(),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    ],
  );
}

class Example extends StatelessWidget {
  const Example({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ImageUrl(
              imageUrl: Constants.imgUrlDefault,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Expanded(
                  child: DetailTitle(
                    title: Constants.titleDefault,
                  ),
                ),
                FavoriteButton(
                  isFavorite: true,
                  onPressed: () {},
                ),
              ],
            ),
            Image.network(
              Constants.imgUrlDefault,
              height: 80,
            ),
            const SizedBox(height: 12),
            const DetailDescription(
              description: Constants.titleDefault,
            ),
            const SizedBox(height: 24),
            Text(
              context.bazS.reviewTitle,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            const StarRating(
              rating: 3,
            ),
            const SizedBox(height: 16),
            Amount(
              price: Constants.titleDefault,
              amount: 3,
              onIncrement: () {},
              onDecrement: () {},
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: BazUiElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    text: context.bazS.continueButton,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: BazUiElevatedButton(
                    style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.resolveWith(
                        (Set<WidgetState> states) =>
                            context.colorScheme.primary,
                      ),
                      backgroundColor: WidgetStateProperty.resolveWith(
                          (Set<WidgetState> states) {
                        if (states.contains(WidgetState.disabled)) {
                          return context.colorScheme.secondaryContainer;
                        }

                        return context.colorScheme.onPrimary;
                      }),
                    ),
                    onPressed: () {},
                    text: context.bazS.viewButton,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
