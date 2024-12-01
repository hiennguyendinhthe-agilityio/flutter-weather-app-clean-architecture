import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:flutter/material.dart';

import '../bloc/data_state.dart';
import 'home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final ApiService apiService;
  final ProductService productRepository;

  HomeRepositoryImpl(this.apiService, this.productRepository);

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

  // Fetch vendors using the ApiService
  @override
  Future<List<Vendor>> fetchVendors({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      // Call the appropriate method from ApiService to fetch vendors
      final vendors = await apiService.getVendors(
        page: page,
        limit: limit,
      );
      return vendors;
    } catch (e) {
      // Handle errors appropriately, maybe print them or rethrow with a custom exception
      throw ErrorHandler.handle(e).failure;
    }
  }

  @override
  Future<List<Author>> fetchAuthors() async {
    try {
      // Call the appropriate method from ApiService to fetch vendors
      final authors = await apiService.getAuthors();
      return authors;
    } catch (e) {
      // Handle errors appropriately, maybe print them or rethrow with a custom exception
      throw ErrorHandler.handle(e).failure;
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
  Future<Author> fetchAuthorProfile(String productId) async {
    try {
      // Call the appropriate method from ApiService to fetch authors
      final authors = await apiService.fetchAuthorProfile(productId);
      return authors;
    } catch (e) {
      // Handle errors appropriately, maybe print them or rethrow with a custom exception
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
