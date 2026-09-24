import 'package:flutter/material.dart';
import '../core/constants/mock_data.dart';
import '../core/theme/app_colors.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  final Function(String title, double price)? onAddToCart;

  const FavoritesScreen({super.key, this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Saved Favorites',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
            fontSize: 22,
          ),
        ),
      ),
      body: SafeArea(
        child: GridView.builder(
          padding: const EdgeInsets.all(24),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.72,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: MockData.dailyProducts.length,
          itemBuilder: (context, index) {
            final product = MockData.dailyProducts[index];
            return ProductCard(
              product: product,
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (_) => ProductDetailScreen(
                      product: product,
                      onAddToCart: (p, qty) {
                        onAddToCart?.call(p.name, p.price * qty);
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
