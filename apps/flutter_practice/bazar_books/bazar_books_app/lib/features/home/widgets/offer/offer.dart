import 'package:bazar_books_design/core/core.dart';
import 'package:bazar_books_design/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../bloc/data_state.dart';
import '../../bloc/product_bloc/product_bloc.dart';
import '../product/product_detail/product_detail.dart';

class Offer extends StatelessWidget {
  const Offer({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();

    return Column(
      children: [
        SizedBox(
          height: 200,
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
                    : PageView.builder(
                        controller: pageController,
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          final Product product =
                              state.status == FetchDataStatus.loading ||
                                      state.data == null
                                  ? Product(id: index.toString())
                                  : state.data?[index] ??
                                      Product(id: index.toString());

                          return BazUiOfferCard(
                            discount: product.discount,
                            imageUrls: product.imageUrlOffer,
                            onTap: () {
                              BazUiBottomSheet.showModal(
                                context,
                                child: ProductDetail(
                                  productId: product.id,
                                ),
                              );
                            },
                          );
                        },
                      ),
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
