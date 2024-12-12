import 'package:bazar_books_app/di.dart';
import 'package:bazar_books_app/features/home/data/product_repository/product_repository.dart';
import 'package:bazar_books_app/features/profile/bloc/favorite/favorite_bloc.dart';
import 'package:bazar_books_app/features/profile/bloc/favorite/favorite_event.dart';
import 'package:bazar_books_app/features/profile/bloc/favorite/favorite_state.dart';
import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:bazar_books_design/core/utils/size_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyFavorite extends StatelessWidget {
  const MyFavorite({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FavoriteBloc(
        getIt<ProductService>(),
        getIt<ProductRepository>(),
      )..add(LoadFavoritesEvent()),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            context.bazS.yourFavoritesTtile,
            style: context.textTheme.titleLarge?.copyWith(
              fontSize: context.fontSize(SizeType.m),
            ),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<FavoriteBloc, FavoriteState>(
          builder: (context, state) {
            if (state is FavoriteInitial) {
              return const Center(child: BazUiCircularProgressIndicator());
            } else if (state is FavoriteError) {
              return Center(child: Text(state.errorMessage));
            } else if (state is FavoriteSuccess && state.favorites.isNotEmpty) {
              return ListView.separated(
                itemCount: state.favorites.length,
                separatorBuilder: (context, index) => const Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
                itemBuilder: (context, index) {
                  final product = state.favorites[index];
                  return ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6.0),
                        child: Image.network(
                          product.imageUrl ?? Constants.imgUrlDefault,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(
                      product.title ?? Constants.titleDefault,
                    ),
                    subtitle: Text('\$${product.price}'),
                    trailing: BazUiBuiltInImage.icLoveFill(
                      color: context.colorScheme.primary,
                    ),
                  );
                },
              );
            } else {
              return const Center(
                  child: Text(
                Constants.noFavorites,
              ));
            }
          },
        ),
      ),
    );
  }
}
