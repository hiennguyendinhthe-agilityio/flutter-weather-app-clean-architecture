import 'package:get/get.dart';
import 'package:online_books_app/presentation/audio_books/controller/audio_book_controller.dart';
import 'package:online_books_app/presentation/audio_books/controller/author_audio_controller.dart';
import 'package:online_books_app/presentation/auth/login/controller/login_controller.dart';
import 'package:online_books_app/presentation/auth/signup/controller/signup_controller.dart';
import 'package:online_books_app/presentation/e_books/controller/book_controller.dart';
import 'package:online_books_app/presentation/e_books/controller/deep_link_controller.dart';
import 'package:online_books_app/presentation/e_books/controller/ebook_detail_controller.dart';
import 'package:online_books_app/presentation/e_books/service/ebook_service.dart';
import 'package:online_books_app/presentation/home/controller/home_controller.dart';
import 'package:online_books_app/presentation/notification/controller/notification_controller.dart';
import 'package:online_books_app/presentation/saved/controller/saved_controller.dart';

class ControllerBinder {
  static void bindControllers() {
    Get.lazyPut(() => BookController(), fenix: true);
    Get.lazyPut(() => AudioBookController(), fenix: true);
    Get.lazyPut(() => SavedBooksController(), fenix: true);
    Get.lazyPut(() => SavedAudioBooksController(), fenix: true);
    Get.lazyPut(() => HomeController(), fenix: true);
    Get.lazyPut(() => LoginController(), fenix: true);
    Get.lazyPut(() => SignupController(), fenix: true);
    Get.lazyPut(() => NotificationController(), fenix: true);
    Get.lazyPut(() => DeepLinkController(), fenix: true);
    Get.lazyPut(() => AuthorAudioController(), fenix: true);
    Get.put<DeepLinkController>(DeepLinkController(), permanent: true);
    Get.put<SavedBooksController>(SavedBooksController(), permanent: true);
    Get.put<EbookService>(EbookService(), permanent: true);
    Get.put<EBookDetailController>(EBookDetailController(), permanent: true);
  }
}
