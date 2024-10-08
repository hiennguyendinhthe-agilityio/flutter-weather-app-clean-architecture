import 'package:bazar_books_app/features/home/bloc/product_bloc/product_bloc.dart';
import 'package:bazar_books_design/core/extensions/responsive_extension.dart';
import 'package:bazar_books_design/core/models/product_model.dart';
import 'package:bazar_books_design/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../bloc/data_state.dart';
import 'product_detail/product_detail.dart';

class Products extends StatelessWidget {
  const Products({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.responsiveHeight(),
      child: BlocBuilder<ProductBloc, FetchDataState<Product>>(
        builder: (context, state) {
          if (state.status == FetchDataStatus.error) {
            return Text(
              textAlign: TextAlign.center,
              'Error: ${state.errorMessage}',
            );
          }

          return Skeletonizer(
            enabled: state.status == FetchDataStatus.loading,
            child: ((state.status == FetchDataStatus.loaded) &&
                    (state.data?.isEmpty ?? false))
                ? BazUiEmpty(
                    onPressed: () {
                      context.read<ProductBloc>().add(GetProductsEvent());
                    },
                  )
                : context.isTablet
                    ? GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: context.getGridCrossAxisCount(),
                          mainAxisSpacing: context.getMainAxisSpacing(),
                          childAspectRatio: context.getAspectRatio(),
                        ),
                        itemCount: state.status == FetchDataStatus.loaded
                            ? state.data?.length ?? 0
                            : 3,
                        itemBuilder: (context, index) {
                          final bool isLoadingOrDataNull =
                              state.status == FetchDataStatus.loading ||
                                  state.data == null;

                          Product createDefaultProduct(int index) {
                            return Product(id: index.toString());
                          }

                          final Product product = isLoadingOrDataNull
                              ? createDefaultProduct(index)
                              : state.data?[index] ??
                                  createDefaultProduct(index);

                          return BazUiBookCard(
                            onTap: () {
                              BazUiBottomSheet.showModal(
                                context,
                                child: ProductDetail(
                                  productId: product.id,
                                ),
                              );
                            },
                            title: product.title,
                            price: product.price,
                            imageUrl: product.imageUrl,
                          );
                        },
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.status == FetchDataStatus.loaded
                            ? state.data?.length ?? 0
                            : 3,
                        itemBuilder: (_, index) {
                          final bool isLoadingOrDataNull =
                              state.status == FetchDataStatus.loading ||
                                  state.data == null;

                          Product createDefaultProduct(int index) {
                            return Product(id: index.toString());
                          }

                          final Product product = isLoadingOrDataNull
                              ? createDefaultProduct(index)
                              : state.data?[index] ??
                                  createDefaultProduct(index);

                          return BazUiBookCard(
                            onTap: () {
                              BazUiBottomSheet.showModal(
                                context,
                                child: ProductDetail(
                                  productId: product.id,
                                ),
                              );
                            },
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
