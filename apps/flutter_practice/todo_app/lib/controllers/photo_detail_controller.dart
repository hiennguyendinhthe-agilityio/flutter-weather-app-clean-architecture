import 'package:flutter/material.dart';
import '../services/photo_animation_service.dart';
import '../models/photo_gesture_state.dart';

/// Controller for managing photo detail screen state and business logic
class PhotoDetailController extends ChangeNotifier {
  final PhotoAnimationService _animationService;

  PhotoDetailController(this._animationService);

  PhotoGestureState _gestureState = PhotoGestureState.initial();
  PhotoGestureState get gestureState => _gestureState;

  late PageController _pageController;
  PageController get pageController => _pageController;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void initialize(int initialIndex) {
    _pageController = PageController(initialPage: initialIndex);
    _currentIndex = initialIndex;
  }

  void onPageChanged(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void onVerticalDragUpdate(DragUpdateDetails details, Size screenSize) {
    _gestureState = _gestureState.copyWith(
      dragOffset: _gestureState.dragOffset + details.delta,
    );

    final dragRatio = _gestureState.dragOffset.dy.abs() / screenSize.height;
    _gestureState = _gestureState.copyWith(
      scale: _animationService.calculateScale(dragRatio),
      backgroundOpacity: _animationService.calculateOpacity(dragRatio),
    );

    notifyListeners();
  }

  void onVerticalDragEnd(
    DragEndDetails details,
    Size screenSize,
    VoidCallback onDismiss,
  ) {
    if (_animationService.shouldDismiss(
      _gestureState.dragOffset,
      details,
      screenSize,
    )) {
      onDismiss();
    } else {
      _animationService.animateToOriginalPosition(_gestureState.dragOffset, (
        offset,
      ) {
        _gestureState = _gestureState.copyWith(
          dragOffset: offset,
          scale: 1.0,
          backgroundOpacity: 1.0,
        );
        notifyListeners();
      });
    }
  }

  void resetGestureState() {
    _gestureState = PhotoGestureState.initial();
    notifyListeners();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationService.dispose();
    super.dispose();
  }
}
