import 'package:bazar_books_design/core/core.dart';
import 'package:bazar_books_design/core/models/auth_model/isar_user.dart';
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

  /// Add a product to the user's favorite list
  Future<void> addProductToFavorites(
      String userId, FavoriteProduct product) async {
    final isar = await isarService.db;

    await isar.writeTxn(() async {
      final user =
          await isar.isarUsers.filter().userIdEqualTo(userId).findFirst();

      if (user != null) {
        user.favoriteProducts ??= [];
        final exists =
            user.favoriteProducts!.any((p) => p.productId == product.productId);

        if (!exists) {
          user.favoriteProducts!.add(product);
          await isar.isarUsers.put(user);
          debugPrint('Product added to favorites: ${product.productId}');
        } else {
          debugPrint('Product already in favorites: ${product.productId}');
        }
      } else {
        throw Exception('User not found for userId: $userId');
      }
    });
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
