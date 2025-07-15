import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhotoProvider extends ChangeNotifier {
  final List<String> _imageUrls = [];

  // State

  bool _isLoading = false;
  bool _hasMore = true;
  String? _error;
  Offset _dragOffset = Offset.zero;
  double _scale = 1.0;
  bool _isDetailViewVisible = false;

  // Getters

  List<String> get imageUrls => _imageUrls;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String? get error => _error;
  Offset get dragOffset => _dragOffset;
  double get scale => _scale;
  bool get isDetailViewVisible => _isDetailViewVisible;

  set isDetailViewVisible(bool value) {
    _isDetailViewVisible = value;
    notifyListeners();
  }

  Future<void> loadMoreImages() async {
    // Prevent multiple simultaneous fetches.
    if (_isLoading) return;

    _isLoading = true;
    _error = null; // Reset error on new load attempt
    notifyListeners();

    // Simulate network latency.
    await Future.delayed(const Duration(seconds: 2));

    final newImages = List.generate(
      9,
      (index) =>
          "https://picsum.photos/seed/${_imageUrls.length + index}/600/600",
    );

    // In a real app, you would check the API response.
    // If the response is empty, it means there are no more images.
    if (newImages.isEmpty) {
      _hasMore = false;
    }

    _imageUrls.addAll(newImages);
    _isLoading = false;
    notifyListeners();
  }

  void updateDragOffset(Offset newOffset) {
    _dragOffset = newOffset;
    notifyListeners();
  }

  void updateScale(double newScale) {
    _scale = newScale;
    notifyListeners();
  }

  void resetDetailView() {
    _dragOffset = Offset.zero;
    _scale = 1.0;
    notifyListeners();
  }
}
