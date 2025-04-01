import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:flutter/widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BazUiPageIndicator extends StatelessWidget {
  const BazUiPageIndicator({
    this.child,
    this.pageController,
    super.key,
  });

  final Widget? child;

  final PageController? pageController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        child ?? const SizedBox.shrink(),
        const SizedBox(height: 10),
        SmoothPageIndicator(
          controller: pageController ?? PageController(),
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
