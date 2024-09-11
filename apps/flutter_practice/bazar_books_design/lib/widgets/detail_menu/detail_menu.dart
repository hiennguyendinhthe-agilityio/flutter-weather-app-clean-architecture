import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class BazUiDetailMenu extends StatelessWidget {
  const BazUiDetailMenu({
    super.key,
    this.imgUrl = '',
  });

  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 69),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  imgUrl,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Text(
                  'The Kite Runner',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.favorite_border,
                  color: Colors.purple,
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'GoodDay',
              style: TextStyle(
                fontSize: 16,
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Viverra dignissim ac ac ac.',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            const Text(
              'Review',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.star, color: Colors.yellow[700]),
                Icon(Icons.star, color: Colors.yellow[700]),
                Icon(Icons.star, color: Colors.yellow[700]),
                Icon(Icons.star, color: Colors.yellow[700]),
                const Icon(Icons.star_border),
                const SizedBox(width: 8),
                const Text(
                  '(4.0)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Card(
                  color: context.colorScheme.onPrimary,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      const Text(
                        '1',
                        style: TextStyle(fontSize: 16),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                ),
                const Text(
                  '\$39.99',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: BazUiElevatedButton(
                    onPressed: () {},
                    text: 'Continue shopping',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: BazUiElevatedButton(
                    style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.resolveWith(
                        (Set<WidgetState> states) =>
                            context.colorScheme.primary,
                      ),
                      backgroundColor: WidgetStateProperty.resolveWith(
                          (Set<WidgetState> states) {
                        if (states.contains(WidgetState.disabled)) {
                          return context.colorScheme.secondaryContainer;
                        }

                        return context.colorScheme.onPrimary;
                      }),
                    ),
                    onPressed: () {},
                    text: 'View cart',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
