import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerListItem extends StatelessWidget {
  final double width;
  final double height;
  final int itemCount;
  final Axis scrollDirection;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerListItem({
    super.key,
    this.width = 120,
    this.height = 120,
    this.itemCount = 15,
    this.scrollDirection = Axis.horizontal,
    this.baseColor = Colors.grey,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      scrollDirection: scrollDirection,
      itemBuilder: (BuildContext context, int index) {
        return Shimmer.fromColors(
          baseColor: context.colorScheme.tertiary,
          highlightColor: context.colorScheme.onPrimary,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: width,
                  height: height,
                  color: context.colorScheme.onPrimary,
                ),
                const SizedBox(height: 8),
                Container(
                  width: width - 20,
                  height: 15,
                  color: context.colorScheme.onPrimary,
                ),
                const SizedBox(height: 5),
                Container(
                  width: 50,
                  height: 15,
                  color: context.colorScheme.onPrimary,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
