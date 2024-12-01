import 'package:bazar_books_design/core/core.dart';

abstract class SearchRepository {
  Future<List<Product>> fetchProducts();
}
