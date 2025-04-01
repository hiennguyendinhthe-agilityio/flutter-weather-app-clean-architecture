import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AudioBookController extends GetxController {
  var bookTitle = ''.obs;
  var bookDescription = ''.obs;
  var bookAuthor = ''.obs;
  var bookImagePath = ''.obs;
  var start = 0.obs;

  var textSize = 16.0.obs;
  var lineHeight = 1.5.obs;
  var backgroundColor = Colors.white.obs;

  var duration = ''.obs;

  void setAudioBookData({
    required String title,
    required String description,
    required String author,
    required String imagePath,
    required int starRating,
    required String duration,
  }) {
    bookTitle.value = title;
    bookDescription.value = description;
    bookAuthor.value = author;
    bookImagePath.value = imagePath;
    start.value = starRating;
    this.duration.value = duration;
  }
}
