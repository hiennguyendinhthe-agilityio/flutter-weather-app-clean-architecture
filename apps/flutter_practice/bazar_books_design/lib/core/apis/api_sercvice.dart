import 'dart:convert';
import 'dart:developer';

import 'package:bazar_books_design/constants.dart';
import 'package:bazar_books_design/core/models/product_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  /// Fetches all products from the api
  ///
  /// Throws an [Exception] if the response status code is not 200
  Future<List<Product>> fetchProducts() async {
    try {
      // Send a GET request to the API endpoint
      final response = await http.get(Uri.parse("${apiUrl}product"));
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to load products with status code: ${response.statusCode}');
      }

      // Decode the JSON response body into a list of dynamic objects
      final List<dynamic> result = jsonDecode(response.body);
      log('$result');

      // Convert each dynamic object to a ProductModel instance
      return result.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      // Catch and rethrow any errors that occur during the process
      throw Exception('Failed to load products: $e');
    }
  }
}
