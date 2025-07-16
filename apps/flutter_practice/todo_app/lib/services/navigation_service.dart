import 'package:flutter/material.dart';
import '../screens/photo_detail_screen.dart';
import '../constants/app_constants.dart';

/// Service responsible for navigation logic
class NavigationService {
  /// Navigates to photo detail screen with custom transition
  void navigateToPhotoDetail(
    BuildContext context, {
    required List<String> imageUrls,
    required int initialIndex,
  }) {
    try {
      Navigator.of(context, rootNavigator: true).push(
        _createPhotoDetailRoute(
          imageUrls: imageUrls,
          initialIndex: initialIndex,
        ),
      );
    } catch (e) {
      debugPrint('Navigation error: $e');
      _showNavigationError(context);
    }
  }

  PageRouteBuilder<void> _createPhotoDetailRoute({
    required List<String> imageUrls,
    required int initialIndex,
  }) {
    return PageRouteBuilder<void>(
      opaque: false,
      barrierColor: Colors.transparent,
      pageBuilder: (context, animation, secondaryAnimation) {
        return PhotoDetailScreen(
          imageUrls: imageUrls,
          initialIndex: initialIndex,
        );
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: const Duration(
        milliseconds: AppConstants.fadeTransitionDuration,
      ),
    );
  }

  void _showNavigationError(BuildContext context) {
    // Could show a snackbar or dialog here
    debugPrint('Failed to navigate to photo detail screen');
  }

  /// Pops the current route safely
  void pop(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  /// Checks if navigation can pop
  bool canPop(BuildContext context) {
    return Navigator.canPop(context);
  }
}