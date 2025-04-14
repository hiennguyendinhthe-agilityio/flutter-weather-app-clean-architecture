import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:online_books_app/core/app_export.dart';
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
      debugPrint('[DeepLinkController] Received deep link: ${uri.toString()}');
      String? bookId;
      Map<String, String> parameters = uri.queryParameters;

      if (uri.scheme == 'https' &&
          uri.host == 'online-books-app.web.app' &&
          uri.pathSegments.isNotEmpty &&
          uri.pathSegments.first == 'share') {
        debugPrint(
            '[DeepLinkController] Detected App Link. Path segments: ${uri.pathSegments}');
        if (uri.pathSegments.length > 1 && uri.pathSegments[1].isNotEmpty) {
          bookId = uri.pathSegments[1];
          debugPrint(
              '[DeepLinkController] Extracted bookId from path: "$bookId"');
        } else {
          debugPrint(
              '[DeepLinkController] App Link path missing or invalid bookId segment.');
        }
      } else if (uri.scheme == 'yourapp' && uri.host == 'book') {
        debugPrint(
            '[DeepLinkController] Detected Custom Scheme. Query params: $parameters');
        bookId = parameters['id'];
        if (bookId != null && bookId.isNotEmpty) {
          debugPrint(
              '[DeepLinkController] Extracted bookId from query: "$bookId"');
        } else {
          debugPrint(
              '[DeepLinkController] Custom Scheme query missing, empty, or invalid "id" parameter.');
          bookId = null;
        }
      } else {
        debugPrint(
            '[DeepLinkController] Unknown or unhandled link type: ${uri.toString()}');
        return;
      }

      if (bookId == null || bookId.isEmpty) {
        debugPrint(
            '[DeepLinkController] Error: Invalid or missing book ID after parsing URI. Cannot navigate.');

        Get.snackbar(
            'Invalid Link', 'Could not extract book information from the link.',
            snackPosition: SnackPosition.BOTTOM);
        return;
      }

      final argumentsToPass = {'id': bookId};
      debugPrint(
          '[DeepLinkController] Attempting to navigate to EBookDetailScreen with arguments: $argumentsToPass');

      Get.to(() => EBookDetailScreen(), arguments: argumentsToPass);
    } catch (e) {
      debugPrint('[DeepLinkController] Deep link handling error: $e');
      Get.snackbar('Error', 'Could not open the link due to an error.',
          snackPosition: SnackPosition.BOTTOM);
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
