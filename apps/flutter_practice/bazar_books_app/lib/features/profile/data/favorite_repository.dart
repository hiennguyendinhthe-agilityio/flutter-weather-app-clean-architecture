import 'package:bazar_books_design/core/core.dart';
import 'package:cached_query_flutter/cached_query_flutter.dart';

class FavoriteRepository {
  Mutation<Product, Product> toggleFavorite() {
    return Mutation<Product, Product>(
      key: 'toggleFavorite',
      invalidateQueries: ['favorites'],
      queryFn: (product) async {
        await Future.delayed(const Duration(milliseconds: 300));

        return product;
      },
      onStartMutation: (product) {
        final query = CachedQuery.instance.getQuery('favorites');
        final fallback = query?.state.data;

        query?.update((favorites) {
          if (favorites?.contains(product) == true) {
            return favorites
                ?.where((item) => item.apiId != product.apiId)
                .toList();
          } else {
            return [product, ...?favorites];
          }
        });

        return fallback;
      },
      onError: (product, error, fallback) {
        CachedQuery.instance.updateQuery(
          key: 'favorites',
          updateFn: (_) => fallback as List<Product>?,
        );
      },
    );
  }
}
