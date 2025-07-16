import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// Service responsible for scroll-related calculations and management
class ScrollService {
  /// Calculates if the scroll position is near the end
  bool isNearEnd(ScrollController controller) {
    if (!controller.hasClients) return false;
    
    final position = controller.position;
    return position.pixels >= position.maxScrollExtent * AppConstants.scrollThreshold;
  }

  /// Gets the current scroll percentage (0.0 to 1.0)
  double getScrollPercentage(ScrollController controller) {
    if (!controller.hasClients) return 0.0;
    
    final position = controller.position;
    if (position.maxScrollExtent == 0) return 0.0;
    
    return (position.pixels / position.maxScrollExtent).clamp(0.0, 1.0);
  }

  /// Checks if scroll position has changed significantly
  bool hasSignificantScrollChange(double oldPosition, double newPosition) {
    const threshold = 50.0; // pixels
    return (newPosition - oldPosition).abs() > threshold;
  }

  /// Safely adds listener to scroll controller
  void addScrollListener(ScrollController controller, VoidCallback listener) {
    try {
      controller.addListener(listener);
    } catch (e) {
      debugPrint('Error adding scroll listener: $e');
    }
  }

  /// Safely removes listener from scroll controller
  void removeScrollListener(ScrollController controller, VoidCallback listener) {
    try {
      controller.removeListener(listener);
    } catch (e) {
      debugPrint('Error removing scroll listener: $e');
    }
  }

  /// Animates scroll to top
  Future<void> scrollToTop(ScrollController controller) async {
    if (!controller.hasClients) return;
    
    try {
      await controller.animateTo(
        0.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } catch (e) {
      debugPrint('Error scrolling to top: $e');
    }
  }
}