// A screen for displaying a photo in detail, with a swipe-to-dismiss gesture.
import 'package:flutter/material.dart';

class PhotoDetailScreen extends StatefulWidget {
  final String imageUrl;
  final Object heroTag;

  const PhotoDetailScreen({
    super.key,
    required this.imageUrl,
    required this.heroTag,
  });

  @override
  State<PhotoDetailScreen> createState() => _PhotoDetailScreenState();
}

class _PhotoDetailScreenState extends State<PhotoDetailScreen>
    with SingleTickerProviderStateMixin {
  // --- Constants for animations and gestures ---
  static const _animationDuration = Duration(milliseconds: 200);
  static const _minScale = 0.8;
  static const _scaleFactor = 0.2;
  static const _opacityFactor = 1.5;
  static const _dismissThreshold = 0.25; // 1/4 of screen height
  static const _fastSwipeVelocity = 500.0;

  // The current vertical drag offset of the image.
  Offset _dragOffset = Offset.zero;
  // The current scale of the image during the drag gesture.
  double _scale = 1.0;
  // Controls the animation to snap the image back to its original position.
  late AnimationController _animationController;
  // The animation that drives the snap-back effect.
  late Animation<Offset> _animation;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );
    // Rebuilds the UI on each animation tick to update the drag offset.
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

  // Handles the vertical drag gesture to move and scale the image.
  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta;
      // Calculate the new scale based on the drag distance.
      final dragRatio =
          _dragOffset.dy.abs() / MediaQuery.of(context).size.height;
      _scale = (1 - dragRatio * _scaleFactor).clamp(_minScale, 1.0);
    });
  }

  // Handles the end of the drag gesture.
  void _onVerticalDragEnd(DragEndDetails details) {
    // Dismiss the screen if the user has dragged far enough or swiped quickly.
    if (_dragOffset.dy >
            MediaQuery.of(context).size.height * _dismissThreshold ||
        details.primaryVelocity! > _fastSwipeVelocity) {
      Navigator.of(context).pop();
    } else {
      // Otherwise, animate the image back to the center.
      _animation = Tween<Offset>(begin: _dragOffset, end: Offset.zero).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
      );
      _animationController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the background opacity based on the drag distance.
    final dragRatio = _dragOffset.dy.abs() / MediaQuery.of(context).size.height;
    final backgroundOpacity = (1 - dragRatio * _opacityFactor).clamp(0.0, 1.0);

    // The main gesture detector for the swipe-to-dismiss interaction.
    return GestureDetector(
      onVerticalDragUpdate: _onVerticalDragUpdate,
      onVerticalDragEnd: _onVerticalDragEnd,
      child: Scaffold(
        // A background that fades out as the user drags.
        backgroundColor: Colors.black.withOpacity(backgroundOpacity),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            // Apply the drag offset and scale transformations to the image.
            child: Transform.translate(
              offset: _dragOffset,
              child: Transform.scale(
                scale: _scale,
                // The Hero widget is essential for the shared element transition.
                child: Hero(
                  tag: widget.heroTag,
                  child: InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 4.0,
                    // Disable panning on the image while the dismiss gesture is active
                    // to prevent gesture conflicts.
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
