import 'package:bazar_books_app/features/category/search/bloc/search_bloc.dart';
import 'package:bazar_books_app/features/home/widgets/product/product_detail/product_detail.dart';
import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:bazar_books_design/core/extensions/responsive_extension.dart';
import 'package:bazar_books_design/core/utils/size_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController textController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          title: Text(
            context.bazS.generalTitleSearch,
            style: context.textTheme.titleLarge?.copyWith(
              fontSize: context.fontSize(SizeType.m),
            ),
          )),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: TextField(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: context.colorScheme.tertiary,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: context.colorScheme.tertiary,
                  ),
                ),
                hintText: context.bazS.generalTitleSearch,
                border: const OutlineInputBorder(),
                prefixIcon: GestureDetector(
                  onTap: () {
                    final query = textController.text.trim();
                    if (query.isNotEmpty) {
                      final bloc = context.read<SearchBloc>();
                      bloc.add(PerformSearchEvent(query));
                      bloc.add(AddToSearchHistoryEvent(query));
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BazUiBuiltInImage.icSearch(
                      color: context.colorScheme.tertiary,
                    ),
                  ),
                ),
              ),
              controller: textController,
              onSubmitted: (value) {
                final bloc = context.read<SearchBloc>();
                if (value.isNotEmpty) {
                  bloc.add(PerformSearchEvent(value));
                  bloc.add(AddToSearchHistoryEvent(value));
                }
              },
            ),
          ),
          BlocBuilder<SearchBloc, SearchState>(
            buildWhen: (previous, current) {
              return previous.status != current.status ||
                  previous.products != current.products;
            },
            builder: (context, state) {
              if (state.history.isNotEmpty && state.products.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.bazS.titleRecentSearches,
                        style: context.textTheme.titleLarge?.copyWith(
                          fontSize: context.fontSize(SizeType.s),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.history.length,
                        itemBuilder: (context, index) {
                          final keyword = state.history[index];
                          return Column(
                            children: [
                              ListTile(
                                title: Text(
                                  keyword,
                                  style:
                                      context.textTheme.labelMedium?.copyWith(
                                    fontSize: context.fontSize(SizeType.xs),
                                  ),
                                ),
                                onTap: () {
                                  final bloc = context.read<SearchBloc>();
                                  textController.text = keyword;
                                  bloc.add(PerformSearchEvent(keyword));
                                },
                              ),
                              const Divider(),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              buildWhen: (previous, current) {
                return previous.status != current.status ||
                    previous.products != current.products;
              },
              builder: (context, state) {
                if (state.status == SearchStatus.loading) {
                  return const Center(child: BazUiCircularProgressIndicator());
                } else if (state.status == SearchStatus.failure) {
                  return Center(child: Text('Error: ${state.errorMessage}'));
                } else if (state.status == SearchStatus.success) {
                  if (state.products.isEmpty) {
                    return Center(
                      child: Text(
                        context.bazS.foundNoResults,
                      ),
                    );
                  }
                  return GridView.builder(
                    controller: ScrollController(),
                    padding: const EdgeInsets.symmetric(horizontal: 23),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      childAspectRatio:
                          context.getAspectRatio(mobile: 0.8, tablet: 0.9),
                    ),
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      final product = state.products[index];
                      return BazUiBookCard(
                        onTap: () {
                          BazUiBottomSheet.showModal(
                            context,
                            child: ProductDetail(productId: product.apiId),
                          );
                        },
                        title: product.title,
                        price: product.price,
                        imageUrl: product.imageUrl,
                      );
                    },
                  );
                }
                return Center(child: Text(context.bazS.startSearching));
              },
            ),
          ),
        ],
      ),
    );
  }
}
