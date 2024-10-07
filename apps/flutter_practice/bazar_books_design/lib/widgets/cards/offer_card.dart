import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class BazUiOfferCard extends StatefulWidget {
  const BazUiOfferCard(
      {super.key,
      this.discount = '',
      this.imageUrls,
      this.width = double.infinity,
      this.borderRadius,
      this.onTap,
      this.height = 180});

  final String? discount;
  final List<String>? imageUrls;
  final double width;
  final BorderRadiusGeometry? borderRadius;
  final Function()? onTap;
  final double height;

  @override
  State<BazUiOfferCard> createState() => _BazUiOfferCardState();
}

int currentIndex = 0;
// Controller for the carousel slider
final CarouselSliderController _carouselController = CarouselSliderController();

class _BazUiOfferCardState extends State<BazUiOfferCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.colorScheme.onPrimary,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
      ),
      child: SizedBox(
        width: widget.width,
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.bazS.specialOffer,
                      style: context.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${widget.discount}%',
                      style: context.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 16),
                    BazUiElevatedButton(
                      onPressed: widget.onTap,
                      text: context.bazS.orderNow,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: CarouselSlider(
                items: widget.imageUrls?.map((url) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          url,
                          cacheWidth: 200,
                          cacheHeight: 200,
                          fit: BoxFit.cover,
                          height: widget.height,
                        ),
                      );
                    }).toList() ??
                    [],
                carouselController: _carouselController,
                options: CarouselOptions(
                  height: 250,
                  autoPlay: true,
                  enableInfiniteScroll: true,
                  enlargeCenterPage: true,
                  aspectRatio: 2.0,
                  onPageChanged: (index, reason) => setState(
                    () => currentIndex = index,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
