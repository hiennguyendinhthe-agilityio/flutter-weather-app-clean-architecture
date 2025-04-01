import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_books_app/data/constants/constants.dart';
import 'package:online_books_app/data/network/error_handler.dart';
import 'package:online_books_app/presentation/audio_books/model/audio_books_model.dart';

class AuthorAudioController extends GetxController {
  final Dio _dio = Dio();
  var authors = <AudioBooks>[].obs;
  var isLoading = true.obs;

  Future<void> fetchBooks() async {
    try {
      isLoading(true);
      var authorList = await getAudioBooks();
      authors.assignAll(authorList);
    } catch (e) {
      debugPrint("Error fetching authors: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<List<AudioBooks>> getAudioBooks() async {
    try {
      final response = await _dio.get('${Constants.apiUrlAuthor}authors');
      if (response.statusCode != 200) {
        throw ErrorHandler.handle(response).failure;
      }

      final List<dynamic> result = response.data;
      debugPrint('$result');

      return result.map((json) => AudioBooks.fromJson(json)).toList();
    } catch (e) {
      throw ErrorHandler.handle(e).failure;
    }
  }
}
