import 'package:flutter/material.dart';

class Week05ExpandedFlexible extends StatefulWidget {
  const Week05ExpandedFlexible({super.key});

  @override
  State<Week05ExpandedFlexible> createState() => _Week05ExpandedFlexibleState();
}

class _Week05ExpandedFlexibleState extends State<Week05ExpandedFlexible> {
  int _flex1 = 1;
  int _flex2 = 1;
  int _flex3 = 1;
  bool _useExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Week 05: Expanded & Flexible'),
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
              '📚 Theory: Expanded & Flexible',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Expanded and Flexible are widgets used to control how a child widget occupies space within a parent, especially in Row, Column, and Flex layouts.',
            ),
            const SizedBox(height: 12),
            const Text(
              'The Difference:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '• Expanded: FORCES its child to fill all the available space.',
            ),
            const Text(
              '• Flexible: ALLOWS its child to be smaller than the available space.',
            ),
            const SizedBox(height: 12),
            const Text(
              '📏 The `flex` property:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('• flex: 1 → takes up 1 part of the space.'),
            const Text(
              '• flex: 2 → takes up 2 parts (twice as much as flex: 1).',
            ),
            const Text('• The sum of all flex factors determines the ratio.'),
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

            // Switch giữa Expanded và Flexible
            SwitchListTile(
              title: Text(_useExpanded ? 'Expanded' : 'Flexible'),
              subtitle: Text(
                _useExpanded
                    ? 'The child is FORCED to fill the space'
                    : 'The child CAN BE smaller than the space',
              ),
              value: _useExpanded,
              onChanged: (value) => setState(() => _useExpanded = value),
            ),

            const SizedBox(height: 16),

            // Demo Row với Expanded/Flexible
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  _buildFlexWidget(
                    flex: _flex1,
                    color: Colors.red,
                    label: 'Box 1\nflex: $_flex1',
                  ),
                  _buildFlexWidget(
                    flex: _flex2,
                    color: Colors.green,
                    label: 'Box 2\nflex: $_flex2',
                  ),
                  _buildFlexWidget(
                    flex: _flex3,
                    color: Colors.blue,
                    label: 'Box 3\nflex: $_flex3',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Controls
            Text('Flex Box 1: $_flex1'),
            Slider(
              value: _flex1.toDouble(),
              min: 1,
              max: 5,
              divisions: 4,
              onChanged: (value) => setState(() => _flex1 = value.toInt()),
            ),

            Text('Flex Box 2: $_flex2'),
            Slider(
              value: _flex2.toDouble(),
              min: 1,
              max: 5,
              divisions: 4,
              onChanged: (value) => setState(() => _flex2 = value.toInt()),
            ),

            Text('Flex Box 3: $_flex3'),
            Slider(
              value: _flex3.toDouble(),
              min: 1,
              max: 5,
              divisions: 4,
              onChanged: (value) => setState(() => _flex3 = value.toInt()),
            ),

            const SizedBox(height: 12),
            Text(
              'Ratio: $_flex1:$_flex2:$_flex3 (Total: ${_flex1 + _flex2 + _flex3})',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlexWidget({
    required int flex,
    required Color color,
    required String label,
  }) {
    final widget = Container(
      height: double.infinity,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.7),
        border: Border.all(color: color, width: 2),
      ),
      child: Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );

    return _useExpanded
        ? Expanded(flex: flex, child: widget)
        : Flexible(flex: flex, child: widget);
  }

  Widget _buildExamples() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '💡 Real-world Examples',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 16),

            // App Bar tùy chỉnh
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.menu, color: Colors.white),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'App Title',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Form layout
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(
                        width: 80,
                        child: Text(
                          'Name:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Enter your name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const SizedBox(
                        width: 80,
                        child: Text(
                          'Email:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'example@email.com',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text('Check'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Bottom navigation simulation
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(child: _buildNavItem(Icons.home, 'Home')),
                  Expanded(child: _buildNavItem(Icons.search, 'Search')),
                  Expanded(child: _buildNavItem(Icons.favorite, 'Favorites')),
                  Expanded(child: _buildNavItem(Icons.person, 'Profile')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.blue)),
      ],
    );
  }
}
