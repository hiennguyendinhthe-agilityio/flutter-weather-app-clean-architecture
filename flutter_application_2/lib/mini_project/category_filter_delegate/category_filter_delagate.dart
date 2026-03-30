import 'package:flutter/material.dart';
import 'package:flutter_application_2/mini_project/category_filter_delegate/category_data.dart';

class CategoryFilterDelegate extends SliverPersistentHeaderDelegate {
  final int selectedIndex;
  final ValueChanged<int> onCategorySelected;

  CategoryFilterDelegate({
    required this.selectedIndex,
    required this.onCategorySelected,
  });

  @override
  double get maxExtent => 64.0;

  @override
  double get minExtent => 64.0;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      height: maxExtent,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: overlapsContent
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () => onCategorySelected(index),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? cat.color : cat.color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? cat.color : cat.color.withOpacity(0.2),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    cat.icon,
                    color: isSelected ? Colors.white : cat.color,
                    size: 14,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    cat.name,
                    style: TextStyle(
                      color: isSelected ? Colors.white : cat.color,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  bool shouldRebuild(CategoryFilterDelegate oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex;
  }
}

class SectionHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final String itemCount;
  final Color color;

  SectionHeaderDelegate({
    required this.title,
    required this.itemCount,
    required this.color,
  });

  @override
  double get minExtent => 44;

  @override
  double get maxExtent => 44;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        border: Border(
          left: BorderSide(color: color, width: 4),
          bottom: BorderSide(
            color: overlapsContent
                ? color.withOpacity(0.2)
                : Colors.transparent,
          ),
        ),
        boxShadow: overlapsContent
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 15,
                letterSpacing: 0.3,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$itemCount items',
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(SectionHeaderDelegate old) {
    return old.title != title ||
        old.itemCount != itemCount ||
        old.color != color;
  }
}

class DynamicStickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final String description;
  final Color color;

  final double topPadding;

  DynamicStickyHeaderDelegate({
    required this.title,
    required this.description,
    required this.color,
    required this.topPadding,
  });

  @override
  double get minExtent => 48;

  @override
  double get maxExtent => 100;

  double get _shrinkRange => maxExtent - minExtent;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final t = (shrinkOffset / _shrinkRange).clamp(0.0, 1.0);

    final titleFontSize = 18 - (t * 4);

    final descriptionOpacity = (1 - t * 2).clamp(0.0, 1.0);

    final verticalPadding = 16 - (t * 8);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: overlapsContent
            ? [
                BoxShadow(
                  color: color.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
        border: Border(bottom: BorderSide(color: color.withOpacity(0.2))),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: verticalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(Icons.tune, color: color, size: 14 + (1 - t) * 4),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: titleFontSize,
                ),
              ),
              const Spacer(),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  't=${t.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ],
          ),

          if (descriptionOpacity > 0) ...[
            const SizedBox(height: 4),
            Opacity(
              opacity: descriptionOpacity,
              child: Text(
                description,
                style: TextStyle(color: color.withOpacity(0.6), fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(DynamicStickyHeaderDelegate old) {
    return old.title != title ||
        old.description != description ||
        old.color != color;
  }
}
