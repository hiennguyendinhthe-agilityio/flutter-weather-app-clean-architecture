import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/photo_detail_controller.dart';
import '../services/photo_animation_service.dart';

/// Pure UI widget for displaying a single photo page
class PhotoPageWidget extends StatefulWidget {
  final String imageUrl;
  final Object heroTag;

  const PhotoPageWidget({
    super.key,
    required this.imageUrl,
    required this.heroTag,
  });

  @override
  State<PhotoPageWidget> createState() => _PhotoPageWidgetState();
}

class _PhotoPageWidgetState extends State<PhotoPageWidget>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    // Initialize animation service with ticker provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PhotoAnimationService>().initialize(this);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PhotoDetailController>(
      builder: (context, controller, child) {
        final gestureState = controller.gestureState;

        return GestureDetector(
          onVerticalDragUpdate: (details) => controller.onVerticalDragUpdate(
            details,
            MediaQuery.of(context).size,
          ),
          onVerticalDragEnd: (details) => controller.onVerticalDragEnd(
            details,
            MediaQuery.of(context).size,
            () => Navigator.of(context).pop(),
          ),
          child: Scaffold(
            backgroundColor: Colors.black.withValues(
              alpha: gestureState.backgroundOpacity,
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Transform.translate(
                  offset: gestureState.dragOffset,
                  child: Transform.scale(
                    scale: gestureState.scale,
                    child: Hero(
                      tag: widget.heroTag,
                      child: InteractiveViewer(
                        minScale: 0.5,
                        maxScale: 4.0,
                        panEnabled: gestureState.dragOffset == Offset.zero,
                        child: Image.network(
                          widget.imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.error,
                              color: Colors.white,
                              size: 64,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
