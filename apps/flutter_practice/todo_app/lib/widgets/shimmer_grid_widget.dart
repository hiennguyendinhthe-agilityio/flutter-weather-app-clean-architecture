import 'package:flutter/cupertino.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import '../constants/app_constants.dart';

/// Reusable shimmer loading grid widget
class ShimmerGridWidget extends StatelessWidget {
  const ShimmerGridWidget({super.key});

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
        (context, index) => const _ShimmerGridItem(),
        childCount: AppConstants.shimmerItemCount,
      ),
    );
  }
}

class _ShimmerGridItem extends StatelessWidget {
  const _ShimmerGridItem();

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Container(
        decoration: BoxDecoration(
          color: CupertinoColors.systemGrey4,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
      ),
    );
  }
}