import 'package:bazar_books_design/core/core.dart';

abstract class Repository {
  Future<List<Product>> fetchProducts();

  Future<List<Vendor>> fetchVendors();

  Future<List<Author>> fetchAuthors();
}
