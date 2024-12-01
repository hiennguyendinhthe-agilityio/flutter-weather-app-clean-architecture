import 'package:bazar_books_design/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

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
      debugPrint('$result');
      // Convert each dynamic object to a ProductModel instance
      return result.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw ErrorHandler.handle(e).failure;
    }
  }

  Future<Product> fetchProductDetails(String? productId) async {
    try {
      // Send a GET request to the API endpoint
      final response =
          await _dio.get('${Constants.apiUrlProduct}product/$productId');
      if (response.statusCode != 200) {
        throw ErrorHandler.handle(response).failure;
      }
      final result = response.data;
      debugPrint('$result');
      // Decode the JSON response body into a list of dynamic objects
      return Product.fromJson(response.data);
    } catch (e) {
      throw ErrorHandler.handle(e).failure;
    }
  }

  Future<List<Vendor>> getVendors({int page = 1, int limit = 10}) async {
    try {
      // Send request to API with pagination parameter
      final response = await _dio.get(
        '${Constants.apiUrlVendor}vendor',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      if (response.statusCode != 200) {
        throw ErrorHandler.handle(response).failure;
      }

      // Parse the response JSON into a list of Providers
      final List<dynamic> result = response.data;
      debugPrint('$result');
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
      debugPrint('$result');
      // Convert each dynamic object to a VendorModel instance
      return result.map((json) => Author.fromJson(json)).toList();
    } catch (e) {
      throw ErrorHandler.handle(e).failure;
    }
  }

  Future<Author> fetchAuthorProfile(String id) async {
    try {
      // Send a GET request to the API endpoint
      final response = await _dio.get('${Constants.apiUrlAuthor}authors/$id');
      if (response.statusCode != 200) {
        throw ErrorHandler.handle(response).failure;
      }
      final result = response.data;
      debugPrint('$result');
      // Decode the JSON response body into a list of dynamic objects
      return Author.fromJson(response.data);
    } catch (e) {
      throw ErrorHandler.handle(e).failure;
    }
  }

  Future<bool> isEmailExist(String email) async {
    try {
      final response = await _dio.get(
        '${Constants.apiUrlUser}user?email=$email',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.isNotEmpty;
      }

      return false;
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 404) {
        return false;
      }
      throw ErrorHandler.handle(e).failure;
    }
  }

  Future<bool> signUp(String name, String email, String password) async {
    try {
      final emailExists = await isEmailExist(email);
      if (emailExists) {
        throw ErrorHandler.handle(emailExists).failure;
      }

      final response = await _dio.post(
        '${Constants.apiUrlUser}user',
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        throw DioException(
          response: response,
          requestOptions: response.requestOptions,
        );
      }
    } catch (e) {
      throw ErrorHandler.handle(e).failure;
    }
  }

  Future<User?> logIn(String email, String password) async {
    try {
      final response = await _dio.get('${Constants.apiUrlUser}user');
      if (response.statusCode == 200) {
        final List users = response.data;
        for (var user in users) {
          if (user['email'] == email && user['password'] == password) {
            return User.fromJson(user);
          }
        }
      }
      return null;
    } catch (e) {
      throw ErrorHandler.handle(e).failure;
    }
  }
}
