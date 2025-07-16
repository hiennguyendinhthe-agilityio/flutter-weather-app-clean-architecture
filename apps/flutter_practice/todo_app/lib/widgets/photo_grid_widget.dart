import 'package:flutter/cupertino.dart';
import '../constants/app_constants.dart';
import '../services/navigation_service.dart';

/// Reusable photo grid widget
class PhotoGridWidget extends StatelessWidget {
  final List<String> imageUrls;
  final NavigationService navigationService;

  const PhotoGridWidget({
    super.key,
    required this.imageUrls,
    required this.navigationService,
  });

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: AppConstants.gridCrossAxisCount,
        mainAxisSpacing: AppConstants.gridMainAxisSpacing,
        crossAxisSpacing: AppConstants.gridCrossAxisSpacing,
        childAspectRatio: AppConstants.gridChildAspectRatio,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return _PhotoGridItem(
            imageUrl: imageUrls[index],
            index: index,
            imageUrls: imageUrls,
            navigationService: navigationService,
          );
        },
        childCount: imageUrls.length,
      ),
    );
  }
}

class _PhotoGridItem extends StatelessWidget {
  final String imageUrl;
  final int index;
  final List<String> imageUrls;
  final NavigationService navigationService;

  const _PhotoGridItem({
    required this.imageUrl,
    required this.index,
    required this.imageUrls,
    required this.navigationService,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleTap(context),
      child: Hero(
        tag: imageUrl,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          child: _NetworkImageWithLoading(imageUrl: imageUrl),
        ),
      ),
    );
  }

  void _handleTap(BuildContext context) {
    navigationService.navigateToPhotoDetail(
      context,
      imageUrls: imageUrls,
      initialIndex: index,
    );
  }
}

class _NetworkImageWithLoading extends StatelessWidget {
  final String imageUrl;

  const _NetworkImageWithLoading({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const _ImageLoadingIndicator();
      },
      errorBuilder: (context, error, stackTrace) {
        return const _ImageErrorWidget();
      },
    );
  }
}

class _ImageLoadingIndicator extends StatelessWidget {
  const _ImageLoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CupertinoActivityIndicator(),
    );
  }
}

class _ImageErrorWidget extends StatelessWidget {
  const _ImageErrorWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoColors.systemGrey5,
      child: const Center(
        child: Icon(
          CupertinoIcons.photo,
          color: CupertinoColors.systemGrey,
          size: 32,
        ),
      ),
    );
  }
}