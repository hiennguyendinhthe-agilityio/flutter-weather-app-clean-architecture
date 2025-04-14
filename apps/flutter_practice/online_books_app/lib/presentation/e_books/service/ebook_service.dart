import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_books_app/data/constants/constants.dart';
import 'package:online_books_app/data/network/error_handler.dart';
import 'package:online_books_app/presentation/e_books/controller/author_controller.dart';
import 'package:online_books_app/presentation/e_books/models/books_model.dart';

/// Initialize any authentication services here.
///
/// This method should be called before running the app.
///
/// Returns the same instance of [EbookService] that called this method.
class EbookService extends GetxService {
  final Dio _dio = Dio();
  Future<List<Books>> getBooks() async {
    try {
      final response = await _dio.get('${Constants.apiUrlAuthor}authors');
      if (response.statusCode != 200) {
        throw ErrorHandler.handle(response).failure;
      }

      final List<dynamic> result = response.data;
      debugPrint('$result');

      return result.map((json) => Books.fromJson(json)).toList();
    } catch (e) {
      throw ErrorHandler.handle(e).failure;
    }
  }

  Future<Books?> getBookById(String authors) async {
    try {
      final response = await _dio.get('${Constants.apiUrlAuthor}$authors');
      if (response.statusCode != 200) {
        throw ErrorHandler.handle(response).failure;
      }
      final dynamic result = response.data;
      debugPrint('Book details for ID $authors: $result');
      return Books.fromJson(result);
    } catch (e) {
      debugPrint('Error fetching book details for ID $authors: $e');
      return null;
    }
  }

  Future<EbookService> init() async {
    // Initialize any authentication services here
    return this;
  }

  @override
  void onReady() {
    Get.put(AuthorBooksController());
    super.onReady();
  }
}
