import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_books_app/presentation/e_books/controller/author_controller.dart';
import 'package:online_books_app/presentation/home/models/home_initial_model.dart';
import 'package:online_books_app/presentation/home/models/home_model.dart';

class HomeController extends GetxController {
  TextEditingController searchController = TextEditingController();
  AuthorBooksController authorController = Get.find<AuthorBooksController>();

  Rx<HomeModel> homeModelObj = HomeModel().obs;

  Rx<HomeInitialModel> homeInitialModelObj = HomeInitialModel().obs;

  RxInt selectedIndex = 0.obs;

  HomeController(
      {required this.searchController, required this.authorController});

  @override
  void onInit() {
    super.onInit();
    authorController.fetchBooks();
  }

  @override
  void onClose() {
    super.onClose();
    searchController.dispose();
  }
}
