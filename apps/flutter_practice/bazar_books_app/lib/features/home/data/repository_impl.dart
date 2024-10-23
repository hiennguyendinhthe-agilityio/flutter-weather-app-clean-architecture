import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:flutter/material.dart';

import '../bloc/data_state.dart';
import 'repository.dart';

class RepositoryImpl implements Repository {
  final ApiService apiService;
  final ProductService productRepository;

  RepositoryImpl(this.apiService, this.productRepository);

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
  Future<Product> fetchProductDetails(String productId) async {
    try {
      // Call the appropriate method from ApiService to fetch products
      final products = await apiService.fetchProductDetails(productId);
      return products;
    } catch (e) {
      throw (FetchDataState<Product>.error(
          ErrorHandler.handle(e).failure.message));
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
}
