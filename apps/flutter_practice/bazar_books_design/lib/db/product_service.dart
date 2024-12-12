import 'package:bazar_books_design/core/core.dart';
import 'package:cached_query_flutter/cached_query_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import 'isar_service.dart';

class ProductService {
  final IsarService isarService;
  final Dio _dio;
  ProductService(this._dio, {required this.isarService});
  void addToFavorites(Product product) {
    CachedQuery.instance.updateQuery(
      key: "favorites",
      updateFn: (oldData) {
        if (oldData != null) {
          return [product, ...oldData];
        }
        return [product];
      },
    );
  }

  void removeFromFavorites(Product product) {
    CachedQuery.instance.updateQuery(
      key: "favorites",
      updateFn: (oldData) {
        if (oldData != null) {
          return oldData.where((item) => item.apiId != product.apiId).toList();
        }
        return [];
      },
    );
  }

  // Call API and return product list from server
  Future<List<Product>> fetchProductsFromApi() async {
    try {
      // Send a GET request to the API endpoint
      final response = await _dio.get(
        '${Constants.apiUrlProduct}product',
      );
      if (response.statusCode != 200) {
        throw ErrorHandler.handle(response).failure;
      }

      // Decode the JSON response body into a list of dynamic objects
      final List<dynamic> result = response.data;
      debugPrint('$result');
      // Convert each dynamic object to a ProductModel instance
      return result.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw ErrorHandler.handle(e).failure;
    }
  }

  // Save product list to Isar
  Future<void> saveProductsToIsar(List<Product> products) async {
    final isar = await isarService.db;
    await isar.writeTxn(() async {
      await isar.products.putAll(products);
    });

    debugPrint('Product list saved to Isar: ${products.length}');
  }

  // Get product list from Isar
  Future<List<Product>> fetchProductsFromIsar() async {
    final isar = await isarService.db;
    return await isar.products.where().findAll();
  }

  // Delete all products in Isar
  Future<void> clearProductsFromIsar() async {
    final isar = await isarService.db;
    await isar.writeTxn(() async {
      await isar.products.clear();
    });
  }

  // Function combines API calls and stores data into Isar
  Future<List<Product>> fetchProducts() async {
    try {
      final productsFromApi =
          await fetchProductsFromApi(); // Call API to get product

      // Delete old data in Isar and save new data
      await clearProductsFromIsar();
      await saveProductsToIsar(productsFromApi);

      return productsFromApi;
    } catch (e) {
      // If an error occurs when calling the API, return data from Isar (if any)
      final productsFromIsar = await fetchProductsFromIsar();
      if (productsFromIsar.isNotEmpty) {
        return productsFromIsar;
      } else {
        rethrow;
      }
    }
  }
}
