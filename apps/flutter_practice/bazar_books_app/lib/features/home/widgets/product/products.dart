import 'package:bazar_books_app/features/home/bloc/product_bloc.dart';
import 'package:bazar_books_design/core/models/product_model.dart';
import 'package:bazar_books_design/widgets/cards/book_card.dart';
import 'package:bazar_books_design/widgets/empty/empty.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Products extends StatelessWidget {
  const Products({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: BlocBuilder<ProductBloc, GetProductsState>(
        builder: (context, state) {
          if (state is GetProductsStateError) {
            return Text(
              textAlign: TextAlign.center,
              'Error: ${state.message}',
            );
          }
          // Status loading
          final bool loading = state is GetProductsStateLoading;
          // Get product list after Products loaded
          final List<Product> products =
              state is GetProductsStateLoaded ? state.products : [];
          final int itemCount = products.length;
          final isEmpty = itemCount == 0 && !loading;
          return Skeletonizer(
            enabled: loading,
            child: isEmpty
                ? BazUiEmpty(
                    onPressed: () {
                      context.read<ProductBloc>().add(GetProductsEvent());
                    },
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: loading ? 3 : itemCount,
                    itemBuilder: (_, index) {
                      final Product product = loading
                          ? Product(
                              id: index.toString(),
                            )
                          : products[index];
                      return BookCard(
                        title: product.title,
                        price: product.price,
                        imageUrl: product.imageUrl,
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}
