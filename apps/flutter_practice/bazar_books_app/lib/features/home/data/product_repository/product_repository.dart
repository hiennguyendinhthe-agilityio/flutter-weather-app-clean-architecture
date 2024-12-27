import 'package:bazar_books_app/features/home/bloc/data_state.dart';
import 'package:bazar_books_design/core/core.dart';
import 'package:bazar_books_design/db/db.dart';
import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:flutter/material.dart';

abstract class ProductRepository {
  // Query<List<Product?>> getYourFavorites();

  Future<List<Product>> fetchProducts();

  Future<Product> fetchProductDetails(String? productId);

  Mutation<Product, Product> createFavorite(Product product);
}

class ProductRepositoryImpl implements ProductRepository {
  final ApiService apiService;
  final ProductService productService;

  ProductRepositoryImpl(
    this.apiService,
    this.productService,
  );

  @override
  Mutation<Product, Product> createFavorite(Product product) {
    return Mutation<Product, Product>(
      key: "createFavorite",
      invalidateQueries: ['favorites'],
      queryFn: (favorite) async {
        final products = await apiService.addProductToFavorites(product);

        return products;
      },
      onStartMutation: (newFavorite) {
        final query = CachedQuery.instance.getQuery("getFavorites")
            as Query<List<Product>>;

        final fallback = query.state.data;
        query.update(
          (old) => [
            Product(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              title: newFavorite.title,
              price: newFavorite.price,
              imageUrl: newFavorite.imageUrl,
            ),
            ...?old,
          ],
        );

        return fallback;
      },
      onSuccess: (args, newFavorite) {},
      onError: (arg, error, fallback) {
        CachedQuery.instance.updateQuery(
          key: "getFavorites",
          updateFn: (dynamic old) =>
              old as List<Product>?, // Ensure type consistency
        );
      },
    );
  }

  @override
  Future<List<Product>> fetchProducts() async {
    // Get data from Isar first and return immediately
    final productsFromIsar = await productService.fetchProductsFromIsar();

    // If there is data from Isar, return it for quick display
    if (productsFromIsar.isNotEmpty) {
      // Display data from Isar immediately
      debugPrint('Loaded from Isar: ${productsFromIsar.length} products');
      return productsFromIsar;
    }

    // If there is no data in Isar, continue calling API to get data
    try {
      final productsFromApi = await productService.fetchProductsFromApi();

      await productService.clearProductsFromIsar();
      await productService.saveProductsToIsar(productsFromApi);

      debugPrint(
          'Loaded from API and updated Isar: ${productsFromApi.length} products');

      return productsFromApi;
    } catch (e) {
      debugPrint('API failed, returning data from Isar if available');
      if (productsFromIsar.isNotEmpty) {
        return productsFromIsar;
      } else {
        throw FetchDataState<List<Product>>.error(
            ErrorHandler.handle(e).failure.message);
      }
    }
  }

  @override
  Future<Product> fetchProductDetails(String? productId) async {
    try {
      // Call the appropriate method from ApiService to fetch products
      final products = await apiService.fetchProductDetails(productId);
      return products;
    } catch (e) {
      throw ErrorHandler.handle(e).failure;
    }
  }
}
