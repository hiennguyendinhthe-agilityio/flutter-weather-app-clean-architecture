import 'package:flutter/material.dart';

class Week08GridView extends StatefulWidget {
  const Week08GridView({super.key});

  @override
  State<Week08GridView> createState() => _Week08GridViewState();
}

class _Week08GridViewState extends State<Week08GridView> {
  int _crossAxisCount = 2;
  double _childAspectRatio = 1.0;
  double _crossAxisSpacing = 8.0;
  double _mainAxisSpacing = 8.0;

  final List<Color> _colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
    Colors.amber,
    Colors.cyan,
    Colors.lime,
    Colors.brown,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Week 08: GridView Widget'),
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
              '📚 Theory: GridView Widget',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'GridView displays items in a grid format. '
              'It\'s perfect for photo galleries, product lists, and dashboards.',
            ),
            const SizedBox(height: 12),
            const Text(
              '🔑 Types of GridView:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('• GridView.count(): Fixed number of columns.'),
            const Text(
              '• GridView.extent(): Maximum cross-axis extent for items.',
            ),
            const Text(
              '• GridView.builder(): Creates items on demand (efficient).',
            ),
            const Text('• GridView.custom(): Fully customizable.'),
            const SizedBox(height: 12),
            const Text(
              '⚙️ Important Properties:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text('• crossAxisCount: The number of columns.'),
            const Text(
              '• childAspectRatio: The width-to-height ratio of each child.',
            ),
            const Text('• crossAxisSpacing: The spacing between columns.'),
            const Text('• mainAxisSpacing: The spacing between rows.'),
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
            Text('Cross Axis Count: $_crossAxisCount'),
            Slider(
              value: _crossAxisCount.toDouble(),
              min: 1,
              max: 4,
              divisions: 3,
              onChanged: (value) =>
                  setState(() => _crossAxisCount = value.toInt()),
            ),

            Text('Child Aspect Ratio: ${_childAspectRatio.toStringAsFixed(1)}'),
            Slider(
              value: _childAspectRatio,
              min: 0.5,
              max: 2.0,
              onChanged: (value) => setState(() => _childAspectRatio = value),
            ),

            Text('Cross Axis Spacing: ${_crossAxisSpacing.toInt()}'),
            Slider(
              value: _crossAxisSpacing,
              min: 0,
              max: 20,
              onChanged: (value) => setState(() => _crossAxisSpacing = value),
            ),

            Text('Main Axis Spacing: ${_mainAxisSpacing.toInt()}'),
            Slider(
              value: _mainAxisSpacing,
              min: 0,
              max: 20,
              onChanged: (value) => setState(() => _mainAxisSpacing = value),
            ),

            const SizedBox(height: 20),

            // Demo GridView
            Container(
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _crossAxisCount,
                  childAspectRatio: _childAspectRatio,
                  crossAxisSpacing: _crossAxisSpacing,
                  mainAxisSpacing: _mainAxisSpacing,
                ),
                itemCount: _colors.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: _colors[index],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star, color: Colors.white, size: 30),
                          const SizedBox(height: 4),
                          Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
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

            // Photo Gallery
            const Text(
              'Photo Gallery:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: 12,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Icon(
                            Icons.image,
                            color: Colors.grey.shade600,
                            size: 30,
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.favorite_border,
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Dashboard Cards
            const Text(
              'Dashboard Cards:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _buildDashboardCard(
                    icon: Icons.people,
                    title: 'Users',
                    value: '1,234',
                    color: Colors.blue,
                  ),
                  _buildDashboardCard(
                    icon: Icons.shopping_cart,
                    title: 'Orders',
                    value: '567',
                    color: Colors.green,
                  ),
                  _buildDashboardCard(
                    icon: Icons.attach_money,
                    title: 'Revenue',
                    value: '\$12,345',
                    color: Colors.orange,
                  ),
                  _buildDashboardCard(
                    icon: Icons.trending_up,
                    title: 'Growth',
                    value: '+15%',
                    color: Colors.purple,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Product Grid
            const Text(
              'Product Grid:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  final products = [
                    'Laptop',
                    'Phone',
                    'Tablet',
                    'Watch',
                    'Headphones',
                    'Camera',
                  ];
                  final prices = [
                    '\$999',
                    '\$699',
                    '\$399',
                    '\$299',
                    '\$199',
                    '\$599',
                  ];

                  return Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(4),
                              ),
                            ),
                            child: Icon(
                              Icons.devices,
                              color: Colors.grey.shade600,
                              size: 40,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                products[index],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                prices[index],
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

}
