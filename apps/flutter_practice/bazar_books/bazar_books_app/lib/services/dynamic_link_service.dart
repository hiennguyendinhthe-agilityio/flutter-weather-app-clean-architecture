import 'package:bazar_books_app/routes/routes.dart';
import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

class DynamicLinkService {
  Future<String> createAuthorShareLink({required String authorId}) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://bazarbooks.page.link',
      link:
          Uri.parse('https://bazarbooks.com/authorProfile?authorId=$authorId'),
      androidParameters: const AndroidParameters(
        packageName: 'com.example.bazar_books_app',
        minimumVersion: 1,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.example.bazarBooksApp',
        minimumVersion: '1.0.1',
      ),
      socialMetaTagParameters: const SocialMetaTagParameters(
        title: 'Check out this author!',
        description: 'Click the link to view author details.',
      ),
    );

    final ShortDynamicLink shortLink =
        await FirebaseDynamicLinks.instance.buildShortLink(parameters);

    return shortLink.shortUrl.toString();
  }
}

class DeepLinkHandler {
  static void init(BuildContext context) {
    FirebaseDynamicLinks.instance.getInitialLink().then(_handleDeepLink);

    FirebaseDynamicLinks.instance.onLink.listen((PendingDynamicLinkData data) {
      _handleDeepLink(data);
    }).onError((error) {
      debugPrint("❌ Deep Link Error: $error");
    });
  }

  static void _handleDeepLink(PendingDynamicLinkData? data) {
    if (data != null) {
      final Uri deepLink = data.link;
      debugPrint("✅ Deep Link Received: ${deepLink.toString()}");

      final String path = deepLink.path;
      final Map<String, String> params = deepLink.queryParameters;

      if (path == "/author") {
        final authorId = params["authorId"] ?? "N/A";
        router.go('${RoutePaths.authorProfile}?authorId=$authorId');
      }
    }
  }
}
