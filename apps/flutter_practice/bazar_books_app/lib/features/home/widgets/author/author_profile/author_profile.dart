import 'package:bazar_books_app/di.dart';
import 'package:bazar_books_app/features/home/bloc/author_bloc/author_bloc.dart';
import 'package:bazar_books_app/features/home/bloc/data_state.dart';
import 'package:bazar_books_app/features/home/bloc/product_bloc/product_bloc.dart';
import 'package:bazar_books_app/features/home/data/repository.dart';
import 'package:bazar_books_app/features/home/widgets/detail_modal/detail_modal.dart';
import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:bazar_books_design/constants.dart';
import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:bazar_books_design/core/extensions/responsive_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AuthorProfile extends StatelessWidget {
  const AuthorProfile({
    required this.authorId,
    super.key,
  });
  final String authorId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          context.bazS.authorsTtile,
          style: context.textTheme.titleLarge
              ?.copyWith(fontSize: context.getFontSize(tablet: 30)),
        ),
        centerTitle: true,
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthorBloc(repository: getIt<Repository>())
              ..add(FetchAuthorProfileEvent(authorId)),
          ),
          BlocProvider(
            create: (context) =>
                ProductBloc(productRepository: getIt<Repository>())
                  ..add(
                    GetProductsEvent(),
                  ),
          ),
        ],
        child: BlocBuilder<AuthorBloc, FetchDataState<Author>>(
          builder: (context, state) {
            switch (state.status) {
              case FetchDataStatus.initial:
                return const Center(child: BazUiCircularProgressIndicator());
              case FetchDataStatus.loading:
                return Skeletonizer(
                  child: _buildAuthorProfile(context, null, state),
                );
              case FetchDataStatus.loaded:
                final author = state.data?.first;
                return _buildAuthorProfile(context, author, state);
              case FetchDataStatus.error:
                return Center(child: Text('Error: //${state.errorMessage}'));
              case FetchDataStatus.loadMore:
                return const Center(child: BazUiCircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _buildAuthorProfile(
      BuildContext context, Author? author, FetchDataState<Author> state) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: CircleAvatar(
                radius: 70,
                backgroundImage: NetworkImage(
                  author?.avatarUrl ?? Constants.imgUrlDefault,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                author?.occupation ?? Constants.titleDefault,
                style: context.textTheme.titleSmall
                    ?.copyWith(fontSize: context.getFontSize(tablet: 24)),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              author?.fullName ?? Constants.titleDefault,
              style: context.textTheme.titleLarge
                  ?.copyWith(fontSize: context.getFontSize(tablet: 30)),
            ),
            const SizedBox(height: 23),
            StarRating(
              rating: author?.starRating ?? 0,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                context.bazS.aboutTitle,
                style: context.textTheme.titleMedium
                    ?.copyWith(fontSize: context.getFontSize(tablet: 30)),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                author?.biography ?? Constants.titleDefault,
                style: context.textTheme.titleSmall
                    ?.copyWith(fontSize: context.getFontSize(tablet: 24)),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                context.bazS.productTitle,
                style: context.textTheme.titleMedium
                    ?.copyWith(fontSize: context.getFontSize(tablet: 30)),
              ),
            ),
            const SizedBox(height: 8),
            _buildProductList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProductList(BuildContext context) {
    return BlocBuilder<ProductBloc, FetchDataState<Product>>(
      builder: (context, state) {
        switch (state.status) {
          case FetchDataStatus.initial:
            return const Center(child: CircularProgressIndicator());
          case FetchDataStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case FetchDataStatus.loaded:
            final products = state.data;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    context.getGridCrossAxisCount(mobile: 3, tablet: 4),
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.65,
              ),
              itemCount: products?.length ?? 0,
              itemBuilder: (context, index) {
                final product = products![index];
                return BazUiBookCard(
                  onTap: () {
                    BazUiBottomSheet.showModal(
                      context,
                      child: DetailModal(
                        productId: product.id,
                      ),
                    );
                  },
                  title: product.title,
                  price: product.price,
                  imageUrl: product.imageUrl,
                );
              },
            );
          case FetchDataStatus.error:
            return Center(child: Text('Error: ${state.errorMessage}'));
          case FetchDataStatus.loadMore:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
