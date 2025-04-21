import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_books_app/presentation/e_books/models/books_model.dart';
import 'package:online_books_app/presentation/e_books/service/ebook_service.dart';

class AuthorBooksController extends GetxController {
  var authors = <Books>[].obs;
  var isLoading = true.obs;
  late EbookService _ebookService;

  AuthorBooksController({EbookService? ebookService}) {
    _ebookService = ebookService ?? EbookService();
  }

  Future<void> fetchBooks() async {
    try {
      isLoading(true);
      var authorList = await _ebookService.getBooks();
      authors.assignAll(authorList);
    } catch (e) {
      debugPrint("Error fetching authors: $e");
    } finally {
      isLoading(false);
    }
  }

  Books? getBookById(String id) {
    try {
      return authors.firstWhere((book) => book.id == id);
    } catch (e) {
      return null;
    }
  }
}
