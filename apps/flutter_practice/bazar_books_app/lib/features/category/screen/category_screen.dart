import 'package:bazar_books_app/di/di.dart';
import 'package:bazar_books_app/features/category/bloc/category_bloc.dart';
import 'package:bazar_books_app/features/category/bloc/data_state.dart';
import 'package:bazar_books_app/features/category/data/category_repository.dart';
import 'package:bazar_books_app/features/home/widgets/product/product_detail/product_detail.dart';
import 'package:bazar_books_design/core/core.dart';
import 'package:bazar_books_design/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: BazUiBuiltInImage.icSearch(),
          onPressed: () {
            context.go(
              '${RoutePaths.categories}/${RoutePaths.search}',
            );
          },
        ),
        title: Text(
          context.bazS.generalTitleCategory,
          style: context.textTheme.titleLarge?.copyWith(
            fontSize: context.fontSize(SizeType.m),
          ),
        ),
        centerTitle: true,
      ),
      body: BazUiTabbarView(
        tabs: [
          Tab(text: context.bazS.allTabBar),
          Tab(text: context.bazS.novelsTabBar),
          Tab(text: context.bazS.selfLoveTabBar),
          Tab(text: context.bazS.scienceTabBar),
          Tab(text: context.bazS.romanticTabBar),
        ],
        child: [
          GetListCategory(category: context.bazS.allTabBar),
          GetListCategory(category: context.bazS.novelsTabBar),
          GetListCategory(category: context.bazS.selfLoveTabBar),
          GetListCategory(category: context.bazS.scienceTabBar),
          GetListCategory(category: context.bazS.romanticTabBar),
        ],
      ),
    );
  }
}

class GetListCategory extends StatefulWidget {
  final String category;
  const GetListCategory({super.key, required this.category});

  @override
  State<GetListCategory> createState() => _GetListCategoryState();
}

class _GetListCategoryState extends State<GetListCategory> {
  late final CategoryBloc _categoryBloc;

  @override
  void initState() {
    super.initState();
    _categoryBloc =
        CategoryBloc(categoryRepository: getIt<CategoryRepository>());
    _categoryBloc.add(GetCategoryEvent(widget.category));
  }

  @override
  void dispose() {
    _categoryBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _categoryBloc,
      child: BlocBuilder<CategoryBloc, FetchDataState<Product>>(
        builder: (context, state) {
          if (state.status == FetchDataStatus.error) {
            return Center(
              child: Text('Error: ${state.errorMessage}'),
            );
          }

          final filteredProducts = state.data;
          return Stack(
            children: [
              GridView.builder(
                controller: ScrollController(),
                padding: const EdgeInsets.symmetric(horizontal: 23),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  childAspectRatio:
                      context.getAspectRatio(mobile: 0.8, tablet: 0.9),
                ),
                itemCount: filteredProducts?.length ?? 0,
                itemBuilder: (context, index) {
                  final product = filteredProducts![index];
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
              if (state.status == FetchDataStatus.loading)
                const Center(
                  child: Skeletonizer(
                    child: BazUiCircularProgressIndicator(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
