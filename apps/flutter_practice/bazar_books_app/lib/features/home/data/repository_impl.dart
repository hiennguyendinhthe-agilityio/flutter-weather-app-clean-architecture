import 'package:bazar_books_design/core/core.dart';

import '../bloc/data_state.dart';
import 'repository.dart';

class RepositoryImpl implements Repository {
  final ApiService apiService;

  // Constructor to inject ApiService
  RepositoryImpl(this.apiService);

  // Fetch products using the ApiService
  @override
  Future<List<Product>> fetchProducts() async {
    try {
      // Call the appropriate method from ApiService to fetch products
      final products = await apiService.getProducts();
      return products;
    } catch (e) {
      throw (FetchDataState<Product>.error(
          ErrorHandler.handle(e).failure.message));
    }
  }

  // Fetch vendors using the ApiService
  @override
  Future<List<Vendor>> fetchVendors() async {
    try {
      // Call the appropriate method from ApiService to fetch vendors
      final vendors = await apiService.getVendors();
      return vendors;
    } catch (e) {
      // Handle errors appropriately, maybe log them or rethrow with a custom exception
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
      // Handle errors appropriately, maybe log them or rethrow with a custom exception
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
      // Handle errors appropriately, maybe log them or rethrow with a custom exception
      throw ErrorHandler.handle(e).failure;
    }
  }
}
