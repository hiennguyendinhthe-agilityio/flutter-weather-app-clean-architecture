import 'package:flutter/material.dart';
import '../models/scroll_state.dart';
import '../services/scroll_service.dart';

/// Unified controller handling both photo data and scroll logic
/// Trade-off: Violates SRP but reduces file complexity
class PhotoScrollController extends ChangeNotifier {
  final ScrollService _scrollService;
  
  PhotoScrollController(this._scrollService);

  // === DATA LAYER (from PhotoProvider) ===
  final List<String> _imageUrls = [];
  List<String> get imageUrls => List.unmodifiable(_imageUrls);

  /// Loads more images and returns the result
  Future<PhotoLoadResult> _loadMoreImagesData() async {
    // Simulate network latency
    await Future.delayed(const Duration(seconds: 2));

    final newImages = List.generate(
      9,
      (index) => "https://picsum.photos/seed/${_imageUrls.length + index}/600/600",
    );

    final hasMore = newImages.isNotEmpty;
    
    if (hasMore) {
      _imageUrls.addAll(newImages);
    }

    return PhotoLoadResult(
      newImages: newImages,
      hasMore: hasMore,
      totalCount: _imageUrls.length,
    );
  }

  void clearImages() {
    _imageUrls.clear();
    notifyListeners();
  }

  // === UI STATE LAYER (from AdvancedScrollController) ===
  ScrollState _scrollState = ScrollState.initial();
  ScrollState get scrollState => _scrollState;

  ScrollController? _scrollController;
  ScrollController get scrollController => _scrollController ??= ScrollController();

  double _lastScrollPosition = 0.0;
  bool _initialized = false;

  // === BUSINESS LOGIC LAYER ===
  void initialize() {
    if (_initialized) return;

    _scrollController ??= ScrollController();
    _scrollService.addScrollListener(_scrollController!, _onScroll);
    _loadInitialData();
    _initialized = true;
  }

  void _loadInitialData() async {
    try {
      _updateScrollState(isLoading: true);
      final result = await _loadMoreImagesData();
      _updateScrollState(
        isLoading: false,
        hasMore: result.hasMore,
      );
    } catch (e) {
      _updateScrollState(
        isLoading: false,
        error: 'Failed to load images: ${e.toString()}',
      );
    }
  }

  void _onScroll() {
    if (_scrollController == null || !_scrollController!.hasClients) return;

    final currentPosition = _scrollController!.position.pixels;
    final isNearEnd = _scrollService.isNearEnd(_scrollController!);

    if (_scrollService.hasSignificantScrollChange(_lastScrollPosition, currentPosition)) {
      _updateScrollState(scrollPosition: currentPosition, isNearEnd: isNearEnd);
      _lastScrollPosition = currentPosition;
    }

    if (_shouldLoadMore(isNearEnd)) {
      _loadMoreImages();
    }
  }

  bool _shouldLoadMore(bool isNearEnd) {
    return isNearEnd &&
        !_scrollState.isLoading &&
        _scrollState.hasMore &&
        _scrollState.error == null;
  }

  void _loadMoreImages() async {
    if (_scrollState.isLoading) return;

    try {
      _updateScrollState(isLoading: true, error: null);
      final result = await _loadMoreImagesData();
      _updateScrollState(
        isLoading: false,
        hasMore: result.hasMore,
      );
    } catch (e) {
      _updateScrollState(
        isLoading: false,
        error: 'Failed to load more images: ${e.toString()}',
      );
    }
  }

  void _updateScrollState({
    bool? isLoading,
    bool? hasMore,
    bool? isNearEnd,
    double? scrollPosition,
    String? error,
  }) {
    _scrollState = _scrollState.copyWith(
      isLoading: isLoading,
      hasMore: hasMore,
      isNearEnd: isNearEnd,
      scrollPosition: scrollPosition,
      error: error,
    );
    notifyListeners();
  }

  // === PUBLIC API ===
  void retryLoading() {
    if (_scrollState.error != null) {
      _loadMoreImages();
    }
  }

  void scrollToTop() {
    if (_scrollController != null) {
      _scrollService.scrollToTop(_scrollController!);
    }
  }

  bool get isInitialLoading => imageUrls.isEmpty && _scrollState.isLoading;
  bool get isLoadingMore => imageUrls.isNotEmpty && _scrollState.isLoading;

  @override
  void dispose() {
    if (_scrollController != null) {
      _scrollService.removeScrollListener(_scrollController!, _onScroll);
      _scrollController!.dispose();
    }
    super.dispose();
  }
}

/// Result model for photo loading operations
class PhotoLoadResult {
  final List<String> newImages;
  final bool hasMore;
  final int totalCount;

  const PhotoLoadResult({
    required this.newImages,
    required this.hasMore,
    required this.totalCount,
  });
}