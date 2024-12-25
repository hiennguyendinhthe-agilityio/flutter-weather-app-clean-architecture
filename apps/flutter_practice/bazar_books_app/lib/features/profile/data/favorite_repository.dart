import 'package:bazar_books_design/core/core.dart';
import 'package:bazar_books_design/db/db.dart';
import 'package:cached_query_flutter/cached_query_flutter.dart';

abstract class FavoriteRepository {
  Query<List<Product?>> getFavorites(String userId);
}

class FavoriteRepositoryImpl implements FavoriteRepository {
  final ApiService apiService;
  final ProductService productService;

  FavoriteRepositoryImpl(
    this.apiService,
    this.productService,
  );

  @override
  @override
  Query<List<Product>> getFavorites(String userId) {
    return Query<List<Product>>(
      key: 'getFavorites',
      config: QueryConfig(
        cacheDuration: const Duration(minutes: 10), // Cache duration
        refetchDuration: const Duration(seconds: 2), // Refetch duration
      ),
      queryFn: () async {
        final products = await apiService.getFavorites(userId);

        return products;
      },
    );
  }
}
