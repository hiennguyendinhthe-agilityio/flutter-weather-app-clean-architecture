import 'dart:developer';

import 'package:bazar_books_design/constants.dart';
import 'package:dio/dio.dart';

import '../core.dart';

class ApiService {
  ApiService(this._dio);

  final Dio _dio;

  /// Fetches all products from the api
  ///
  /// Throws an [Exception] if the response status code is not 200

  Future<List<Product>> getProducts() async {
    try {
      // Send a GET request to the API endpoint
      final response = await _dio.get('${Constants.apiUrlProduct}product');
      if (response.statusCode != 200) {
        throw ErrorHandler.handle(response).failure;
      }

      // Decode the JSON response body into a list of dynamic objects
      final List<dynamic> result = response.data;
      log('$result');
      // Convert each dynamic object to a ProductModel instance
      return result.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw ErrorHandler.handle(e).failure;
    }
  }

  Future<List<Vendor>> getVendors() async {
    try {
      // Send a GET request to the API endpoint
      final response = await _dio.get('${Constants.apiUrlVendor}vendor');
      if (response.statusCode != 200) {
        throw ErrorHandler.handle(response).failure;
      }

      // Decode the JSON response body into a list of dynamic objects
      final List<dynamic> result = response.data;
      log('$result');
      // Convert each dynamic object to a VendorModel instance
      return result.map((json) => Vendor.fromJson(json)).toList();
    } catch (e) {
      throw ErrorHandler.handle(e).failure;
    }
  }

  Future<List<Author>> getAuthors() async {
    try {
      // Send a GET request to the API endpoint
      final response = await _dio.get('${Constants.apiUrlAuthor}authors');
      if (response.statusCode != 200) {
        throw ErrorHandler.handle(response).failure;
      }

      // Decode the JSON response body into a list of dynamic objects
      final List<dynamic> result = response.data;
      log('$result');
      // Convert each dynamic object to a VendorModel instance
      return result.map((json) => Author.fromJson(json)).toList();
    } catch (e) {
      throw ErrorHandler.handle(e).failure;
    }
  }
}
