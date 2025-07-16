import 'package:flutter/material.dart';

/// Service responsible for photo animation calculations and management
class PhotoAnimationService {
  static const Duration _animationDuration = Duration(milliseconds: 200);
  static const double _minScale = 0.8;
  static const double _scaleFactor = 0.2;
  static const double _opacityFactor = 1.5;
  static const double _dismissThreshold = 0.25;
  static const double _fastSwipeVelocity = 500.0;

  AnimationController? _animationController;
  Animation<Offset>? _animation;

  void initialize(TickerProvider vsync) {
    _animationController = AnimationController(
      vsync: vsync,
      duration: _animationDuration,
    );
  }

  double calculateScale(double dragRatio) {
    return (1 - dragRatio * _scaleFactor).clamp(_minScale, 1.0);
  }

  double calculateOpacity(double dragRatio) {
    return (1 - dragRatio * _opacityFactor).clamp(0.0, 1.0);
  }

  bool shouldDismiss(Offset dragOffset, DragEndDetails details, Size screenSize) {
    return dragOffset.dy > screenSize.height * _dismissThreshold ||
           (details.primaryVelocity != null && details.primaryVelocity! > _fastSwipeVelocity);
  }

  void animateToOriginalPosition(
    Offset currentOffset,
    ValueChanged<Offset> onUpdate,
  ) {
    if (_animationController == null) return;
    
    _animation = Tween<Offset>(
      begin: currentOffset,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeOut),
    );

    void listener() {
      onUpdate(_animation!.value);
    }

    _animationController!.addListener(listener);
    _animationController!.forward(from: 0).then((_) {
      _animationController!.removeListener(listener);
    });
  }

  void dispose() {
    _animationController?.dispose();
  }
}