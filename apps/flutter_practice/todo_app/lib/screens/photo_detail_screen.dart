import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/photo_detail_controller.dart';
import '../services/photo_animation_service.dart';
import '../widgets/photo_page_widget.dart';

/// Pure UI screen for displaying photos with swipe navigation
/// Business logic is handled by PhotoDetailController
class PhotoDetailScreen extends StatelessWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const PhotoDetailScreen({
    super.key,
    required this.imageUrls,
    required this.initialIndex,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<PhotoAnimationService>(
          create: (_) => PhotoAnimationService(),
        ),
        ChangeNotifierProvider<PhotoDetailController>(
          create: (context) {
            final controller = PhotoDetailController(
              context.read<PhotoAnimationService>(),
            );
            controller.initialize(initialIndex);
            return controller;
          },
        ),
      ],
      child: Consumer<PhotoDetailController>(
        builder: (context, controller, child) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: PageView.builder(
              controller: controller.pageController,
              itemCount: imageUrls.length,
              onPageChanged: controller.onPageChanged,
              itemBuilder: (context, index) {
                final heroTag = imageUrls[index];
                return PhotoPageWidget(
                  key: ValueKey(heroTag),
                  imageUrl: imageUrls[index],
                  heroTag: heroTag,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
