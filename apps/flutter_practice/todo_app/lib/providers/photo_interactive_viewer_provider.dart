import 'package:flutter/cupertino.dart';

class PhotoDetailProvider extends ChangeNotifier {
  static const _minScale = 0.8;
  static const _scaleFactor = 0.2;

  Offset _dragOffset = Offset.zero;
  double _scale = 1.0;

  Offset get dragOffset => _dragOffset;
  double get scale => _scale;
  double get minScale => _minScale;
  double get scaleFactor => _scaleFactor;
  double get dismissThreshold => _dismissThreshold;
  double get fastSwipeVelocity => _fastSwipeVelocity;
  Duration get animationDuration => _animationDuration;
  static const _animationDuration = Duration(milliseconds: 200);
  static const _dismissThreshold = 0.25;
  static const _fastSwipeVelocity = 500.0;
  void updateDragOffset(Offset newOffset) {
    _dragOffset = newOffset;
    notifyListeners();
  }

  void updateScale(double newScale) {
    _scale = newScale;
    notifyListeners();
  }
}
