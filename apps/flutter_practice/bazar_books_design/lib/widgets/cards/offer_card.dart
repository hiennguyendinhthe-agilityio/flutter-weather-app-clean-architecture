import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:bazar_books_design/core/apis/api_sercvice.dart';
import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:bazar_books_design/core/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SpecialOfferCard extends StatelessWidget {
  const SpecialOfferCard({
    super.key,
    this.discountText = '',
    this.imageUrl,
    this.width = double.infinity,
    this.borderRadius,
  });

  final String discountText;
  final String? imageUrl;
  final double width;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.colorScheme.onPrimary,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
      child: SizedBox(
        width: width,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Special Offer',
                      style: context.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Discount $discountText%',
                      style: context.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 16),
                    BazUiElevatedButton(
                      onPressed: () {},
                      text: 'Order Now',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  imageUrl ?? '',
                  height: 180,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CarouselWithDots extends StatelessWidget {
  CarouselWithDots({super.key});
  final ApiService apiService = ApiService();

  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: FutureBuilder<List<ProductModel>>(
            future: apiService.fetchProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: BazUiCircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Failed to load offers'));
              } else if (snapshot.hasData && snapshot.data != null) {
                final offers = snapshot.data!;

                return PageView.builder(
                  controller: _pageController,
                  itemCount: offers.length,
                  itemBuilder: (context, index) {
                    return SpecialOfferCard(
                      discountText: offers[index].discount.toString(),
                      imageUrl: offers[index].imageUrl,
                    );
                  },
                );
              }

              return const Center(child: Text('No offers available'));
            },
          ),
        ),
        const SizedBox(height: 10),
        SmoothPageIndicator(
          controller: _pageController,
          count: 3,
          effect: ScaleEffect(
            dotWidth: 8,
            dotHeight: 8,
            activeDotColor: context.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
