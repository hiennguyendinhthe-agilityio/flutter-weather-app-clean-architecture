import 'package:bazar_books_design/core/core.dart';

abstract class HomeRepository {
  Future<List<Product>> fetchProducts();

  Future<Product> fetchProductDetails(String productId);

  Future<List<Vendor>> fetchVendors({
    int page = 1,
    int limit = 10,
  });

  Future<List<Author>> fetchAuthors();

  Future<Author> fetchAuthorProfile(String productId);
}
