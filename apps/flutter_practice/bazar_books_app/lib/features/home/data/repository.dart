import 'package:bazar_books_design/core/models/product_model.dart';
import 'package:bazar_books_design/core/models/vendor_model.dart';

abstract class Repository {
  Future<List<Product>> fetchProducts();

  Future<List<Vendor>> fetchVendors();
}
