import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_books_app/presentation/e_books/models/books_model.dart';
import 'package:online_books_app/presentation/e_books/service/ebook_service.dart';

class AuthorBooksController extends GetxController {
  var authors = <Books>[].obs;
  var isLoading = true.obs;

  Future<void> fetchBooks() async {
    try {
      isLoading(true);
      var authorList = await EbookService().getBooks();
      authors.assignAll(authorList);
    } catch (e) {
      debugPrint("Error fetching authors: $e");
    } finally {
      isLoading(false);
    }
  }
}
