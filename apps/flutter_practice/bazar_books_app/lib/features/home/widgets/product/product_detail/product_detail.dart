import 'package:bazar_books_app/di.dart';
import 'package:bazar_books_app/features/home/bloc/data_state.dart';
import 'package:bazar_books_app/features/home/bloc/product_detail_bloc/bloc/product_detail_bloc.dart';
import 'package:bazar_books_app/features/home/data/product_repository/product_repository.dart';
import 'package:bazar_books_app/features/profile/bloc/favorite/favorite_bloc.dart';
import 'package:bazar_books_app/features/profile/bloc/favorite/favorite_event.dart';
import 'package:bazar_books_design/core/core.dart';
import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:bazar_books_design/core/extensions/responsive_extension.dart';
import 'package:bazar_books_design/core/responsive/size_extension.dart';
import 'package:bazar_books_design/core/utils/size_type.dart';
import 'package:bazar_books_design/db/product_service.dart';
import 'package:bazar_books_design/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductDetail extends StatelessWidget {
  const ProductDetail({
    this.productId,
    super.key,
  });

  final String? productId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              ProductDetailBloc(productRepository: getIt<ProductRepository>())
                ..add(FetchProductDetailsEvent(productId)),
        ),
        BlocProvider(
          create: (context) => FavoriteBloc(
            getIt<ProductService>(),
            getIt<ProductRepository>(),
          )..add(LoadFavoritesEvent()),
        ),
      ],
      child: BlocBuilder<ProductDetailBloc, ProductDetailState>(
        builder: (context, state) {
          final fetchDataState = state.fetchDataState;

          switch (fetchDataState.status) {
            case FetchDataStatus.initial:
              return const Center(child: BazUiCircularProgressIndicator());
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
                  child: Text('Error: //${fetchDataState.errorMessage}'));
            case FetchDataStatus.loadMore:
              return const Center(child: BazUiCircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildProductDetails(
      BuildContext context, Product? product, ProductDetailState state) {
    final bloc = context.read<ProductDetailBloc>();

    return DraggableScrollableSheet(
      snap: true,
      initialChildSize: 1.0,
      minChildSize: 0.99,
      expand: false,
      builder: (context, scrollController) => SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: 24.0.paddingAll, // Responsive padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 69),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      product?.imageUrl ?? Constants.imgUrlDefault,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      product?.title ?? Constants.titleDefault,
                      style: Theme.of(context).textTheme.titleLarge,
                      maxLines: 1,
                    ),
                  ),
                  BazUiIconButton.favorite(
                    isFavorite: state.isFavorite,
                    onPressed: () {
                      bloc.add(ToggleFavoriteEvent());
                      if (state.isFavorite) {
                        context.read<FavoriteBloc>().add(
                            RemoveFromFavoritesEvent(
                                product ?? Product(apiId: '')));
                      } else {
                        context.read<FavoriteBloc>().add(
                            AddToFavoritesEvent(product ?? Product(apiId: '')));
                      }
                    },
                  ),
                ],
              ),
              Image.network(
                product?.logoVendor ?? Constants.imgUrlDefault,
                height: context.getImageHeight(),
              ),
              const SizedBox(height: 12),
              Text(
                product?.description ?? Constants.titleDefault,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 24),
              Text(
                context.bazS.reviewTitle,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize:
                      context.fontSize(SizeType.l), // Responsive font size
                ),
              ),
              const SizedBox(height: 8),
              StarRating(
                rating: product?.starRating ?? 0,
              ),
              const SizedBox(height: 16),
              BazUiAmount(
                price: product?.price ?? Constants.titleDefault,
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
                  SizedBox(width: context.getButtonSpacing()),
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
                          },
                        ),
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
      ),
    );
  }
}
