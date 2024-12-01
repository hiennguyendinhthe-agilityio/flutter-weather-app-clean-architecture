import 'package:bazar_books_app/features/category/search/data/search_repository.dart';
import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:flutter/material.dart';

class SearchRepositoryImpl implements SearchRepository {
  final ApiService apiService;
  final ProductService productRepository;

  SearchRepositoryImpl(this.apiService, this.productRepository);

  @override
  Future<List<Product>> fetchProducts() async {
    // Get data from Isar first and return immediately
    final productsFromIsar = await productRepository.fetchProductsFromIsar();

    // If there is data from Isar, return it for quick display
    if (productsFromIsar.isNotEmpty) {
      // Display data from Isar immediately
      debugPrint('Loaded from Isar: ${productsFromIsar.length} products');
      return productsFromIsar;
    }

    // If there is no data in Isar, continue calling API to get data
    try {
      final productsFromApi = await productRepository.fetchProductsFromApi();

      await productRepository.clearProductsFromIsar();
      await productRepository.saveProductsToIsar(productsFromApi);

      debugPrint(
          'Loaded from API and updated Isar: ${productsFromApi.length} products');

      return productsFromApi;
    } catch (e) {
      debugPrint('API failed, returning data from Isar if available');
      if (productsFromIsar.isNotEmpty) {
        return productsFromIsar;
      } else {
        throw (ErrorHandler.handle(e).failure.message);
      }
    }
  }
}
