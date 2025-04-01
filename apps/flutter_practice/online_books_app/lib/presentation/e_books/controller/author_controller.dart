import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_books_app/data/constants/constants.dart';
import 'package:online_books_app/data/network/error_handler.dart';
import 'package:online_books_app/presentation/e_books/models/books_model.dart';

class AuthorBooksController extends GetxController {
  final Dio _dio = Dio();
  var authors = <Books>[].obs;
  var isLoading = true.obs;

  Future<void> fetchBooks() async {
    try {
      isLoading(true);
      var authorList = await getBooks();
      authors.assignAll(authorList);
    } catch (e) {
      debugPrint("Error fetching authors: $e");
    } finally {
      isLoading(false);
    }
  }

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
}
