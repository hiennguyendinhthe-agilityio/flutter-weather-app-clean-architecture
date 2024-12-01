import 'package:bazar_books_app/features/home/bloc/data_state.dart';
import 'package:bazar_books_design/core/core.dart';
import 'package:bazar_books_design/db/db.dart';
import 'package:flutter/material.dart';

abstract class ProductRepository {
  Future<List<Product>> fetchProducts();

  Future<Product> fetchProductDetails(String? productId);

  Future<List<Product>> fetchProductsByCategory(String category);
}

class ProductRepositoryImpl implements ProductRepository {
  final ApiService apiService;
  final ProductService productRepository;

  ProductRepositoryImpl(
    this.apiService,
    this.productRepository,
  );

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

  @override
  Future<List<Product>> fetchProductsByCategory(String category) async {
    if (category == 'All') {
      return await fetchProducts();
    }
    // Get data from Isar first and filter by category
    final productsFromIsar = await productRepository.fetchProductsFromIsar();
    final filteredProductsFromIsar = productsFromIsar
        .where((product) => product.category == category)
        .toList();

    if (filteredProductsFromIsar.isNotEmpty) {
      debugPrint(
          'Loaded filtered data from Isar: ${filteredProductsFromIsar.length} products');
      return filteredProductsFromIsar;
    }

    // If no data in Isar, fetch from API
    try {
      final productsFromApi = await productRepository.fetchProductsFromApi();

      // Save fetched data to Isar for offline access
      await productRepository.clearProductsFromIsar();
      await productRepository.saveProductsToIsar(productsFromApi);

      // Filter by category
      final filteredProductsFromApi = productsFromApi
          .where((product) => product.category == category)
          .toList();

      debugPrint(
          'Loaded filtered data from API: ${filteredProductsFromApi.length} products');
      return filteredProductsFromApi;
    } catch (e) {
      debugPrint('API failed, attempting to return filtered data from Isar');
      if (filteredProductsFromIsar.isNotEmpty) {
        return filteredProductsFromIsar;
      } else {
        throw FetchDataState<List<Product>>.error(
            ErrorHandler.handle(e).failure.message);
      }
    }
  }
}
