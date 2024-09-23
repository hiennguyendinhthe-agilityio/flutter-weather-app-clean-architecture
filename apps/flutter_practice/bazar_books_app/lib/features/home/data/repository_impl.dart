import 'package:bazar_books_design/core/core.dart';
import 'package:bazar_books_design/core/models/product_model.dart';
import 'package:bazar_books_design/core/models/vendor_model.dart';

import '../bloc/data_state.dart';
import 'repository.dart';

class RepositoryImpl implements Repository {
  final ApiService apiService;

  // Constructor to inject DataService
  RepositoryImpl(this.apiService);

  // Fetch products using the DataService
  @override
  Future<List<Product>> fetchProducts() async {
    try {
      // Call the appropriate method from DataService to fetch products
      final products = await apiService.fetchProducts();
      return products;
    } catch (e) {
      throw (FetchDataState<Product>.error(
          ErrorHandler.handle(e).failure.message));
    }
  }

  // Fetch vendors using the DataService
  @override
  Future<List<Vendor>> fetchVendors() async {
    try {
      // Call the appropriate method from DataService to fetch vendors
      final vendors = await apiService.fetchVendors();
      return vendors;
    } catch (e) {
      // Handle errors appropriately, maybe log them or rethrow with a custom exception
      throw ErrorHandler.handle(e).failure;
    }
  }
}
