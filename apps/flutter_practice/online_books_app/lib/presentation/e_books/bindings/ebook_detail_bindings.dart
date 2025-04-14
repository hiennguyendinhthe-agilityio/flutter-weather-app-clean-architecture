// Ví dụ: ebook_detail_binding.dart
import 'package:get/get.dart';
import 'package:online_books_app/presentation/e_books/controller/ebook_detail_controller.dart';

class EBookDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EBookDetailController>(() => EBookDetailController());
  }
}
