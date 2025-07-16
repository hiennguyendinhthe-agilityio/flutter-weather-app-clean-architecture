import 'package:flutter/cupertino.dart';
import '../constants/app_constants.dart';
import '../config/theme_extensions.dart';

/// Reusable sliver header delegate for persistent headers with theme support
class SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final double? height;

  const SliverHeaderDelegate({
    required this.title,
    this.height,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: context.backgroundColor,
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: 8,
      ),
      alignment: Alignment.centerLeft,
      child: ThemedText(
        title,
        style: const TextStyle(
          fontSize: AppConstants.headerTitleFontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  double get maxExtent => height ?? AppConstants.headerHeight;

  @override
  double get minExtent => height ?? AppConstants.headerHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return oldDelegate is SliverHeaderDelegate && oldDelegate.title != title;
  }
}