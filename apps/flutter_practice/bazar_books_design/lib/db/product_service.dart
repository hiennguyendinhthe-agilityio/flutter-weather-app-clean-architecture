import 'package:bazar_books_design/core/core.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import 'isar_service.dart';

class ProductService {
  final IsarService isarService;
  final Dio _dio;
  ProductService(this._dio, {required this.isarService});

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

  Future<void> saveFavoriteProductsToIsar(List<Product> products) async {
    final isar = await isarService.db;

    final favoriteProducts =
        products.where((product) => product.favorite == true).toList();

    await isar.writeTxn(() async {
      await isar.products.putAll(favoriteProducts);
    });

    debugPrint('Saved ${favoriteProducts.length} favorite products to Isar.');
  }

  Future<List<Product>> fetchFavoriteProductsFromIsar() async {
    final isar = await isarService.db;

    return await isar.products.filter().favoriteEqualTo(true).findAll();
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
}
