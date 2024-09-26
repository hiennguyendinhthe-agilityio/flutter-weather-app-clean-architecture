import 'package:bazar_books_app/features/home/widgets/detail_menu/amount.dart';
import 'package:bazar_books_app/features/home/widgets/detail_menu/detail_description.dart';
import 'package:bazar_books_app/features/home/widgets/detail_menu/detail_image.dart';
import 'package:bazar_books_app/features/home/widgets/detail_menu/detail_title.dart';
import 'package:bazar_books_app/features/home/widgets/detail_menu/favorite_button.dart';
import 'package:bazar_books_app/features/home/widgets/detail_menu/star_rating.dart';
import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/detail_bloc/bloc/detail_bloc.dart';

class DetailMenu extends StatelessWidget {
  const DetailMenu({
    required this.product,
    super.key,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DetailBloc(product),
      child: BlocBuilder<DetailBloc, DetailState>(
        builder: (context, state) {
          final bloc = context.read<DetailBloc>();
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DetailImage(imageUrl: state.imageUrl),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: DetailTitle(
                          title: state.title,
                        ),
                      ),
                      FavoriteButton(
                        isFavorite: state.isFavorite,
                        onPressed: () => bloc.add(
                          ToggleFavoriteEvent(),
                        ),
                      ),
                    ],
                  ),
                  Image.network(
                    state.vendorLogoUrl,
                    height: 80,
                  ),
                  DetailDescription(
                    description: state.description,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    context.bazS.reviewTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  StarRating(rating: state.starRating),
                  const SizedBox(height: 16),
                  Amount(
                    price: product.price ?? '',
                    amount: state.amount,
                    onIncrement: () =>
                        bloc.add(UpdateAmountEvent(state.amount + 1)),
                    onDecrement: () {
                      if (state.amount > 1) {
                        bloc.add(UpdateAmountEvent(state.amount - 1));
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: BazUiElevatedButton(
                          onPressed: () {},
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
        },
      ),
    );
  }
}
