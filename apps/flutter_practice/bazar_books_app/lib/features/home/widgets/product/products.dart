import 'package:bazar_books_app/features/home/bloc/product_bloc.dart';
import 'package:bazar_books_app/features/home/widgets/book_card.dart';
import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../detail_menu/detail_menu_page.dart';

class Products extends StatelessWidget {
  const Products({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 23),
      child: SizedBox(
        height: 180,
        child: BlocBuilder<ProductBloc, GetProductsState>(
          builder: (context, state) {
            if (state is GetProductsStateError) {
              return Text(
                textAlign: TextAlign.center,
                'Error: ${state.message}',
              );
            } else if (state is GetProductsStateLoaded) {
              return Skeletonizer(
                enabled: state is GetProductsStateLoading,
                child: ListView.builder(
                  itemCount: state.products.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    final product = state.products[index];
                    return BookCard(
                      onTap: () {
                        BazUiBottomSheet.showModal(
                          context,
                          child: const DetailMenuPage(),
                        );
                      },
                      title: product.title,
                      price: product.price,
                      imageUrl: product.imageUrl,
                    );
                  },
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
