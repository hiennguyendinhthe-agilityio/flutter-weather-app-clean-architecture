import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_books_app/presentation/e_books/ebook_detail_screen.dart';
import 'package:online_books_app/presentation/e_books/models/books_model.dart';
import 'package:share_plus/share_plus.dart';

class DeepLinkController extends GetxController {
  static DeepLinkController get to => Get.find();
  final String firebaseHostingUrl = "https://online-books-app.web.app";
  late AppLinks _appLinks;
  final _isInitialized = false.obs;

  @override
  void onInit() {
    super.onInit();
    initDeepLinks();
  }

  Future<void> initDeepLinks() async {
    if (_isInitialized.value) return;

    try {
      _appLinks = AppLinks();
      await _getInitialLink();
      _listenToLinks();
      _isInitialized.value = true;
    } catch (e) {
      debugPrint('Deep link error: $e');
    }
  }

  Future<void> _getInitialLink() async {
    try {
      final uri = await _appLinks.getInitialLink();
      if (uri != null) {
        _handleDeepLink(uri);
      }
    } catch (e) {
      debugPrint('Initial link error: $e');
    }
  }

  void _listenToLinks() {
    _appLinks.uriLinkStream.listen(
      _handleDeepLink,
      onError: (err) {
        debugPrint('Link stream error: $err');
        Get.snackbar('Connection Error', 'Failed to process link');
      },
      cancelOnError: false,
    );
  }

  void _handleDeepLink(Uri uri) {
    try {
      debugPrint('Received deep link: ${uri.toString()}');
      debugPrint('Query parameters: ${uri.queryParameters}');

      if (uri.scheme == 'yourapp' && uri.host == 'book') {
        final bookId = uri.queryParameters['id'];

        if (bookId == null || bookId.isEmpty) {
          throw 'Invalid book ID';
        }

        debugPrint('Navigating to /bookDetail with bookId: $bookId');
        Get.to(() => EBookDetailScreen(), arguments: {'id': bookId});
      }
    } catch (e) {
      debugPrint('Deep link handling error: $e');
      Get.snackbar('Invalid Link', 'Could not open the content');
    }
  }

  Future<void> shareBook(Books book) async {
    try {
      final firebaseLink = '$firebaseHostingUrl/share/${book.id}';
      final customSchemeLink = 'yourapp://book?id=${book.id}';

      final shareText = '''
        Check out this book: ${book.fullName}
        
       Web Link: $firebaseLink
       App Direct: $customSchemeLink
      ''';

      await Share.share(shareText);
    } catch (e) {
      debugPrint('Share error: $e');
      Get.snackbar('Sharing Failed', 'Could not share the book');
    }
  }
}
