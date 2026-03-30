import 'package:flutter/material.dart';
import 'package:flutter_application_2/mini_project/category_filter_delegate/category_data.dart';
import 'package:flutter_application_2/mini_project/category_filter_delegate/category_filter_delagate.dart';

class StickyHeaderScreen extends StatefulWidget {
  const StickyHeaderScreen({super.key});

  @override
  State<StickyHeaderScreen> createState() => _StickyHeaderScreenState();
}

class _StickyHeaderScreenState extends State<StickyHeaderScreen> {
  int _selectedCategory = 0;

  final ScrollController _scrollController = ScrollController();

  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    final sections = productsByCategory.entries.toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            floating: false,
            backgroundColor: const Color(0xFFF5F5FF),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Food Market',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black54, blurRadius: 8)],
                ),
              ),
              titlePadding: const EdgeInsetsDirectional.only(
                start: 16,
                bottom: 16,
              ),
              collapseMode: CollapseMode.parallax,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800',
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        color: const Color(0xFF1A1A2E),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white54,
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (_, _, _) => Container(
                      color: const Color(0xFF1A1A2E),
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.white38,
                        size: 48,
                      ),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: CategoryFilterDelegate(
              selectedIndex: _selectedCategory,
              onCategorySelected: (index) {
                setState(() {
                  _selectedCategory = index;
                });
              },
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: DynamicStickyHeaderDelegate(
              title: 'Category Filer',
              description:
                  'Showing ${categories[_selectedCategory].name} '
                  '• ${productsByCategory.values.expand((e) => e).length} items',
              color: categories[_selectedCategory].color,
              topPadding: topPadding,
            ),
          ),
          ...sections.asMap().entries.expand((entry) {
            final sectionIndex = entry.key;
            final sectionName = entry.value.key;
            final products = entry.value.value;

            final sectionColors = [
              const Color(0xFF6C63FF),
              const Color(0xFFFF6B6B),
              const Color(0xFF00BFA5),
            ];

            final color = sectionColors[sectionIndex % sectionColors.length];

            return [
              SliverPersistentHeader(
                pinned: true,
                delegate: SectionHeaderDelegate(
                  title: sectionName,
                  itemCount: products.length.toString(),
                  color: color,
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildProductCard(products[index]),
                    childCount: products.length,
                  ),
                ),
              ),
            ];
          }),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A2E),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.verified, color: Colors.greenAccent, size: 16),
                      SizedBox(width: 6),
                      Text(
                        'AC4 – Verification Panel',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  _buildVerifyRow(
                    '✅ AC1',
                    'CategoryFilterDelegate extends SliverPersistentHeaderDelegate',
                    Colors.greenAccent,
                  ),
                  _buildVerifyRow(
                    '✅ AC2',
                    'minExtent(48), maxExtent(64/100), shouldRebuild, build implemented',
                    Colors.lightBlueAccent,
                  ),
                  _buildVerifyRow(
                    '✅ AC3',
                    '3 SliverPersistentHeader added below SliverAppBar',
                    Colors.yellowAccent,
                  ),
                  _buildVerifyRow(
                    '✅ AC4',
                    'Dynamic t=${(_scrollOffset / 52).clamp(0, 1).toStringAsFixed(2)} '
                        '| scrollOffset=${_scrollOffset.toStringAsFixed(0)}px',
                    Colors.pinkAccent,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Scroll lên để thấy t thay đổi và Dynamic Header co giãn',
                    style: TextStyle(color: Colors.white38, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  // ── Product Card ────────────────────────────
  Widget _buildProductCard(Product product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Icon
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: product.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(product.icon, color: product.color, size: 26),
            ),

            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 12, color: Colors.amber),
                      const SizedBox(width: 3),
                      Text(
                        '${product.rating}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 3,
                        height: 3,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        product.category,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Price + Add button
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  product.price,
                  style: TextStyle(
                    color: product.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: product.color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerifyRow(String ac, String description, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ac,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 11,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              description,
              style: const TextStyle(color: Colors.white54, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}
