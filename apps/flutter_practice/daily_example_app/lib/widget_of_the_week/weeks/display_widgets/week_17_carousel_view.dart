import 'package:flutter/material.dart';

class Week17CarouselView extends StatefulWidget {
  const Week17CarouselView({super.key});

  @override
  State<Week17CarouselView> createState() => _Week17CarouselViewState();
}

class _Week17CarouselViewState extends State<Week17CarouselView> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  bool _autoPlay = true;
  bool _showIndicators = true;
  double _itemExtent = 200.0;

  final List<CarouselItem> _items = [
    CarouselItem(
      title: 'Beautiful Sunset',
      description: 'A stunning sunset over the mountains',
      color: Colors.orange,
      icon: Icons.wb_sunny,
    ),
    CarouselItem(
      title: 'Ocean Waves',
      description: 'Peaceful waves crashing on the shore',
      color: Colors.blue,
      icon: Icons.waves,
    ),
    CarouselItem(
      title: 'Forest Path',
      description: 'A serene path through the green forest',
      color: Colors.green,
      icon: Icons.forest,
    ),
    CarouselItem(
      title: 'Mountain Peak',
      description: 'Majestic mountain peak covered in snow',
      color: Colors.grey,
      icon: Icons.terrain,
    ),
    CarouselItem(
      title: 'City Lights',
      description: 'Vibrant city skyline at night',
      color: Colors.purple,
      icon: Icons.location_city,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Week 17: CarouselView'),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTheorySection(),
            const SizedBox(height: 24),
            _buildInteractiveDemo(),
            const SizedBox(height: 24),
            _buildExamples(),
            const SizedBox(height: 24),
            _buildExercises(),
          ],
        ),
      ),
    );
  }

  Widget _buildTheorySection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📚 Theory: CarouselView',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'CarouselView is a scrollable widget that displays a series of items in a '
              'horizontal carousel format. It\'s perfect for showcasing images, products, '
              'or any content that benefits from a swipeable interface.',
            ),
            const SizedBox(height: 12),
            const Text(
              '🔑 Important properties:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('• itemExtent: Width of each carousel item'),
            const Text('• shrinkExtent: Minimum width when shrinking'),
            const Text('• children: List of widgets to display'),
            const Text('• onTap: Callback when item is tapped'),
            const Text('• controller: Controls the carousel scrolling'),
            const SizedBox(height: 12),
            const Text(
              '💡 Great for image galleries, product showcases, and feature highlights!',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractiveDemo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🎮 Interactive Demo',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16),

            // Controls
            Text('Item Width: ${_itemExtent.toInt()}px'),
            Slider(
              value: _itemExtent,
              min: 150,
              max: 300,
              divisions: 15,
              onChanged: (value) => setState(() => _itemExtent = value),
            ),

            Row(
              children: [
                Expanded(
                  child: SwitchListTile(
                    title: const Text('Auto Play'),
                    value: _autoPlay,
                    onChanged: (value) => setState(() => _autoPlay = value),
                  ),
                ),
                Expanded(
                  child: SwitchListTile(
                    title: const Text('Show Indicators'),
                    value: _showIndicators,
                    onChanged: (value) =>
                        setState(() => _showIndicators = value),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // CarouselView Demo
            SizedBox(
              height: 250,
              child: CarouselView(
                itemExtent: _itemExtent,
                shrinkExtent: _itemExtent * 0.8,
                children: _items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          item.color.withValues(alpha: 0.8),
                          item.color.withValues(alpha: 0.6),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: item.color.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          setState(() => _currentIndex = index);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Tapped: ${item.title}'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(item.icon, size: 48, color: Colors.white),
                              const SizedBox(height: 16),
                              Text(
                                item.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item.description,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 16),

            // Indicators
            if (_showIndicators)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _items.asMap().entries.map((entry) {
                  final index = entry.key;
                  return Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == index
                          ? Colors.indigo
                          : Colors.grey.shade300,
                    ),
                  );
                }).toList(),
              ),

            const SizedBox(height: 16),

            // Navigation buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _currentIndex > 0
                      ? () => setState(() => _currentIndex--)
                      : null,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Previous'),
                ),
                ElevatedButton.icon(
                  onPressed: _currentIndex < _items.length - 1
                      ? () => setState(() => _currentIndex++)
                      : null,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExamples() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '💡 Real Examples',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 16),

            // Product Showcase Example
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Example 1: Product Showcase',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('E-commerce product carousel with pricing'),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 120,
                    child: CarouselView(
                      itemExtent: 100,
                      children: [
                        _buildProductCard('Laptop', '\$999', Colors.blue),
                        _buildProductCard('Phone', '\$699', Colors.green),
                        _buildProductCard('Tablet', '\$399', Colors.orange),
                        _buildProductCard('Watch', '\$299', Colors.purple),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Feature Highlights Example
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Example 2: Feature Highlights',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('App feature introduction carousel'),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 100,
                    child: CarouselView(
                      itemExtent: 200,
                      children: [
                        _buildFeatureCard('Fast', Icons.speed, Colors.red),
                        _buildFeatureCard(
                          'Secure',
                          Icons.security,
                          Colors.green,
                        ),
                        _buildFeatureCard('Easy', Icons.touch_app, Colors.blue),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Image Gallery Example
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Example 3: Image Gallery',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('Photo gallery with thumbnail preview'),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 80,
                    child: CarouselView(
                      itemExtent: 80,
                      children: [
                        _buildImageCard(Colors.red.shade300),
                        _buildImageCard(Colors.green.shade300),
                        _buildImageCard(Colors.blue.shade300),
                        _buildImageCard(Colors.orange.shade300),
                        _buildImageCard(Colors.purple.shade300),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(String name, String price, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.devices, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
          Text(price, style: TextStyle(color: color.withValues(alpha: 0.7))),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(String title, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCard(Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Icon(Icons.image, color: Colors.white, size: 24),
      ),
    );
  }

  Widget _buildExercises() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📝 Practice Exercises',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '1. Basic Carousel Implementation:\n'
              '   • Create a simple image carousel\n'
              '   • Add navigation dots indicator\n'
              '   • Implement tap-to-view functionality\n\n'
              '2. Product Carousel:\n'
              '   • Build an e-commerce product carousel\n'
              '   • Add product details overlay\n'
              '   • Implement add-to-cart functionality\n\n'
              '3. Auto-playing Carousel:\n'
              '   • Create auto-advancing carousel\n'
              '   • Add pause on user interaction\n'
              '   • Implement infinite scrolling\n\n'
              '4. Advanced Carousel Features:\n'
              '   • Add zoom functionality on tap\n'
              '   • Implement lazy loading for images\n'
              '   • Add swipe gestures and animations\n'
              '   • Create thumbnail navigation',
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Great! You completed the CarouselView lesson!',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Complete Lesson'),
            ),
          ],
        ),
      ),
    );
  }
}

class CarouselItem {
  final String title;
  final String description;
  final Color color;
  final IconData icon;

  CarouselItem({
    required this.title,
    required this.description,
    required this.color,
    required this.icon,
  });
}
