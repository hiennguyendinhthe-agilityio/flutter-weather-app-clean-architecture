import 'package:bazar_books_app/features/profile/bloc/favorite/favorite_bloc.dart';
import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:bazar_books_design/core/utils/size_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyFavorite extends StatelessWidget {
  const MyFavorite({super.key, required this.userId});

  final String userId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FavoriteBloc()
        ..add(
          GetFavoriteProducts(userId),
        ),
      child: Scaffold(
        appBar: AppBar(
          actions: const [],
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
            switch (state.status) {
              case FavoriteStatus.loading:
                return const Center(child: BazUiCircularProgressIndicator());
              case FavoriteStatus.failure:
                return Center(child: Text(state.errorMessage));
              case FavoriteStatus.success:
                if (state.favorites.isNotEmpty) {
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
                        trailing: GestureDetector(
                          onTap: () {},
                          child: BazUiBuiltInImage.icLoveFill(
                            color: context.colorScheme.primary,
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text(Constants.noFavorites),
                  );
                }
              default:
                return const Center(
                    child: Text(
                  'Constants.unexpectedError',
                ));
            }
          },
        ),
      ),
    );
  }
}
