import 'package:flutter_advanced_course/shop_app/core/data/mock_data.dart';
import 'package:flutter_advanced_course/shop_app/core/models/product.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_provider.g.dart';

@riverpod
class ProductSearch extends _$ProductSearch {
  @override
  String build() => '';

  void updateQuery(String query) => state = query;
}

@riverpod
Future<List<Product>> allProducts(Ref ref) async {
  await Future.delayed(const Duration(milliseconds: 800));
  return mockProducts;
}

@riverpod
Future<List<Product>> filteredProducts(Ref ref) async {
  final products = await ref.watch(allProductsProvider.future);
  final query = ref.watch(productSearchProvider).toLowerCase().trim();

  if (query.isEmpty) return products;
  return products
      .where(
        (p) =>
            p.name.toLowerCase().contains(query) ||
            p.category.toLowerCase().contains(query),
      )
      .toList();
}

@riverpod
Future<Product?> productById(Ref ref, String id) async {
  final products = await ref.watch(allProductsProvider.future);
  try {
    return products.firstWhere((p) => p.id == id);
  } catch (_) {
    return null;
  }
}
