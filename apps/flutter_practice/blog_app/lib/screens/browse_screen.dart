import 'package:flutter/material.dart';
import '../core/constants/mock_data.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../models/product.dart';
import '../widgets/cocoloco_header.dart';
import '../widgets/product_card.dart';
import '../widgets/promo_banner_card.dart';
import 'product_detail_screen.dart';

class BrowseScreen extends StatefulWidget {
  final Function(String title, double price)? onAddToCart;

  const BrowseScreen({
    super.key,
    this.onAddToCart,
  });

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  bool _isSearchOpen = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openProductDetail(Product product) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => ProductDetailScreen(
          product: product,
          onAddToCart: (p, qty) {
            widget.onAddToCart?.call(p.name, p.price * qty);
          },
        ),
      ),
    );
  }

  void _showAddedSnackbar(String item) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Added $item to order',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Alignment _getProductAlignment(String id) {
    switch (id) {
      case 'prod_cappuccino':
        return const Alignment(0, 0.4);
      case 'prod_crossaint':
        return const Alignment(0, 0.05);
      default:
        return Alignment.center;
    }
  }

  Alignment _getBannerAlignment(String id) {
    switch (id) {
      case 'offer_breakfast_bundle':
        return const Alignment(0, 0.45);
      case 'offer_fruit_market':
        return const Alignment(0, 0.2);
      default:
        return Alignment.center;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = MockData.dailyProducts.where((p) {
      if (_searchQuery.isEmpty) return true;
      return p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.category.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top App Bar with authentic COCO LOCO Logo & Search
            CocolocoHeader(
              onSearchTap: () {
                setState(() {
                  _isSearchOpen = !_isSearchOpen;
                  if (!_isSearchOpen) {
                    _searchQuery = '';
                    _searchController.clear();
                  }
                });
              },
            ),

            // Expandable Search Bar
            AnimatedCrossFade(
              firstChild: const SizedBox(height: 0),
              secondChild: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Search coffee, bakery & specials...',
                    hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                    prefixIcon: const Icon(Icons.search, color: AppColors.primary, size: 20),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              crossFadeState:
                  _isSearchOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 250),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section 1: "Let's get this day going"
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                      child: Text(
                        "Let’s get this day going",
                        style: AppTypography.sectionHeading,
                      ),
                    ),

                    // Horizontal Product Carousel
                    SizedBox(
                      height: 248,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return ProductCard(
                            product: product,
                            imageAlignment: _getProductAlignment(product.id),
                            onTap: () => _openProductDetail(product),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Section 2: "April special"
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 4, 24, 16),
                      child: Text(
                        "April special",
                        style: AppTypography.sectionHeading,
                      ),
                    ),

                    // Vertical Banner List
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: MockData.specialOffers.map((offer) {
                          return PromoBannerCard(
                            offer: offer,
                            imageAlignment: _getBannerAlignment(offer.id),
                            onTap: () {
                              widget.onAddToCart?.call(offer.subtitle, offer.price);
                              _showAddedSnackbar(offer.subtitle);
                            },
                            onAddToCart: () {
                              widget.onAddToCart?.call(offer.subtitle, offer.price);
                              _showAddedSnackbar(offer.subtitle);
                            },
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
