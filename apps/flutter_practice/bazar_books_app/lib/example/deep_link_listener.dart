import 'dart:async';
import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:bazar_books_app/example/book_details_page.dart';
import 'package:bazar_books_app/example/book_list_page.dart';
import 'package:flutter/material.dart';

class DeepLinkListener extends StatefulWidget {
  const DeepLinkListener({super.key, required this.child});
  final Widget child;

  @override
  State<DeepLinkListener> createState() => _DeepLinkListenerState();
}

class _DeepLinkListenerState extends State<DeepLinkListener> {
  late final StreamSubscription<Uri> _sub;

  @override
  void initState() {
    super.initState();

    final appLinks = AppLinks(); // AppLinks is singleton

    // Subscribe to all events (initial link and further)
    _sub = appLinks.uriLinkStream.listen((uri) {
      log('URI: ${uri.toString()}');
      if (uri.pathSegments.isNotEmpty &&
          uri.pathSegments.first == 'book' &&
          mounted) {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const BookListPage()));
        final id = uri.pathSegments.length > 1 ? uri.pathSegments[1] : null;
        if (id != null && int.tryParse(id) != null) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BookDetailsPage(bookId: id)));
        }

        // Extract query parameters
        final queryParams = uri.queryParameters;
        if (queryParams.isNotEmpty) {
          queryParams.forEach((key, value) {
            log('Query Parameter: $key = $value');
            // Handle query parameters as needed
          });
        }
      } else {
        log('Invalid URI or path segments');
      }
    }, onError: (error) {
      log('Error in URI stream: $error');
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
