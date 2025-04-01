import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookController extends GetxController {
  var bookTitle = ''.obs;
  var bookDescription = ''.obs;
  var bookAuthor = ''.obs;
  var bookImagePath = ''.obs;
  var start = 0.obs;
  var bookContent = ''.obs;

  var textSize = 16.0.obs;
  var lineHeight = 1.5.obs;
  var backgroundColor = Colors.white.obs;

  void setBookData({
    required String title,
    required String description,
    required String author,
    required String imagePath,
    required int starRating,
    required String pdfUrl,
  }) {
    bookTitle.value = title;
    bookDescription.value = description;
    bookAuthor.value = author;
    bookImagePath.value = imagePath;
    start.value = starRating;
    bookContent.value = pdfUrl;
  }
}
