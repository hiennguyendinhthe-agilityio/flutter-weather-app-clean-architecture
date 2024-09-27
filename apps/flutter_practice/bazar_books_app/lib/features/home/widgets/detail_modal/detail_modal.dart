import 'package:bazar_books_app/di.dart';
import 'package:bazar_books_app/features/home/bloc/data_state.dart';
import 'package:bazar_books_app/features/home/bloc/detail_bloc/bloc/detail_bloc.dart';
import 'package:bazar_books_app/features/home/data/repository.dart';
import 'package:bazar_books_design/constants.dart';
import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:bazar_books_design/core/models/product_model.dart';
import 'package:bazar_books_design/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DetailModal extends StatelessWidget {
  const DetailModal({
    required this.productId,
    super.key,
  });

  final String productId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DetailBloc(productRepository: getIt<Repository>())
        ..add(FetchProductDetailsEvent(productId)),
      child: BlocBuilder<DetailBloc, DetailState>(
        builder: (context, state) {
          final fetchDataState = state.fetchDataState;

          switch (fetchDataState.status) {
            case FetchDataStatus.initial:
              return const Center(
                  child: Text('Ready to load product details...'));
            case FetchDataStatus.loading:
              final product = fetchDataState.data?.first;
              return Skeletonizer(
                child: _buildProductDetails(context, product, state),
              );
            case FetchDataStatus.loaded:
              final product = fetchDataState.data?.first;
              return _buildProductDetails(context, product, state);
            case FetchDataStatus.error:
              return Center(
                  child: Text('Error: ${fetchDataState.errorMessage}'));
          }
        },
      ),
    );
  }

  Widget _buildProductDetails(
      BuildContext context, Product? product, DetailState state) {
    final bloc = context.read<DetailBloc>();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageUrl(
              imageUrl: product?.imageUrl ?? Constants.imgUrlDefault,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DetailTitle(
                    title: product?.title ?? '',
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
              product?.logoVendor ?? Constants.imgUrlDefault,
              height: 80,
            ),
            const SizedBox(height: 12),
            DetailDescription(
              description: product?.description ?? '',
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
            StarRating(rating: product?.starRating ?? 0),
            const SizedBox(height: 16),
            Amount(
              price: product?.price ?? '',
              amount: state.quantity,
              onIncrement: () =>
                  bloc.add(UpdateAmountEvent(state.quantity + 1)),
              onDecrement: () {
                if (state.quantity > 1) {
                  bloc.add(UpdateAmountEvent(state.quantity - 1));
                }
              },
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
