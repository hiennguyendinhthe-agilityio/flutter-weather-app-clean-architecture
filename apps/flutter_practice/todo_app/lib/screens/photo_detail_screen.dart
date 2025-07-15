// A screen for displaying a photo in detail, with a swipe-to-dismiss gesture.
import 'package:flutter/material.dart';

// The main screen that hosts the PageView for swiping between photos.
class PhotoDetailScreen extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const PhotoDetailScreen({
    super.key,
    required this.imageUrls,
    required this.initialIndex,
  });

  @override
  State<PhotoDetailScreen> createState() => _PhotoDetailScreenState();
}

class _PhotoDetailScreenState extends State<PhotoDetailScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // A constant black background
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.imageUrls.length,
        itemBuilder: (context, index) {
          // Use the URL as a unique hero tag
          final heroTag = widget.imageUrls[index];
          return _PhotoPage(
            key: ValueKey(heroTag), // Use a key for state preservation
            imageUrl: widget.imageUrls[index],
            heroTag: heroTag,
          );
        },
      ),
    );
  }
}

// A single page that displays one photo with the swipe-to-dismiss gesture.
// This widget contains the logic from the original PhotoDetailScreen.
class _PhotoPage extends StatefulWidget {
  final String imageUrl;
  final Object heroTag;

  const _PhotoPage({super.key, required this.imageUrl, required this.heroTag});

  @override
  State<_PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<_PhotoPage>
    with SingleTickerProviderStateMixin {
  // --- All the state and logic from the original screen ---
  static const _animationDuration = Duration(milliseconds: 200);
  static const _minScale = 0.8;
  static const _scaleFactor = 0.2;
  static const _opacityFactor = 1.5;
  static const _dismissThreshold = 0.25;
  static const _fastSwipeVelocity = 500.0;

  Offset _dragOffset = Offset.zero;
  double _scale = 1.0;
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );
    _animationController.addListener(() {
      setState(() {
        _dragOffset = _animation.value;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta;
      final dragRatio =
          _dragOffset.dy.abs() / MediaQuery.of(context).size.height;
      _scale = (1 - dragRatio * _scaleFactor).clamp(_minScale, 1.0);
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (_dragOffset.dy >
            MediaQuery.of(context).size.height * _dismissThreshold ||
        details.primaryVelocity! > _fastSwipeVelocity) {
      // Check if the widget is still mounted before popping.
      if (mounted) {
        Navigator.of(context).pop();
      }
    } else {
      _animation = Tween<Offset>(begin: _dragOffset, end: Offset.zero).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
      );
      _animationController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dragRatio = _dragOffset.dy.abs() / MediaQuery.of(context).size.height;
    final backgroundOpacity = (1 - dragRatio * _opacityFactor).clamp(0.0, 1.0);

    // This GestureDetector now wraps the content of a single page.
    return GestureDetector(
      onVerticalDragUpdate: _onVerticalDragUpdate,
      onVerticalDragEnd: _onVerticalDragEnd,
      // The Scaffold is now inside each page to control its own background opacity.
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(backgroundOpacity),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Transform.translate(
              offset: _dragOffset,
              child: Transform.scale(
                scale: _scale,
                child: Hero(
                  tag: widget.heroTag,
                  child: InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 4.0,
                    panEnabled: _dragOffset == Offset.zero,
                    child: Image.network(widget.imageUrl, fit: BoxFit.contain),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
