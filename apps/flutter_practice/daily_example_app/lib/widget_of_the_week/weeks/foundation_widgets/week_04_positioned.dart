import 'package:flutter/material.dart';

class Week04Positioned extends StatefulWidget {
  const Week04Positioned({super.key});

  @override
  State<Week04Positioned> createState() => _Week04PositionedState();
}

class _Week04PositionedState extends State<Week04Positioned> {
  double _top = 50;
  double _left = 50;
  double _right = 50;
  double _bottom = 50;
  bool _useRight = false;
  bool _useBottom = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Week 04: Positioned Widget'),
        backgroundColor: Colors.teal,
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
              '📚 Theory: Positioned Widget',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Positioned can only be used inside a Stack. It allows you to precisely position '
              'a child widget within the Stack by specifying its distance from the edges.',
            ),
            const SizedBox(height: 12),
            const Text(
              '🔑 Key Properties:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('• top: The distance from the top edge.'),
            const Text('• left: The distance from the left edge.'),
            const Text('• right: The distance from the right edge.'),
            const Text('• bottom: The distance from the bottom edge.'),
            const Text('• width: A fixed width for the child.'),
            const Text('• height: A fixed height for the child.'),
            const SizedBox(height: 12),
            const Text(
              '⚠️ Note: You cannot use left + right or top + bottom simultaneously unless you want to stretch the widget!',
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

            // Stack demo với Positioned
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade100,
              ),
              child: Stack(
                children: [
                  // Background grid for better visibility
                  ...List.generate(
                    5,
                    (i) => Positioned(
                      top: i * 50.0,
                      left: 0,
                      right: 0,
                      child: Container(height: 1, color: Colors.grey.shade300),
                    ),
                  ),
                  ...List.generate(
                    8,
                    (i) => Positioned(
                      left: i * 50.0,
                      top: 0,
                      bottom: 0,
                      child: Container(width: 1, color: Colors.grey.shade300),
                    ),
                  ),

                  // Positioned widget
                  Positioned(
                    top: _useBottom ? null : _top,
                    left: _useRight ? null : _left,
                    right: _useRight ? _right : null,
                    bottom: _useBottom ? _bottom : null,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 4,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'Box',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Controls
            Row(
              children: [
                Expanded(
                  child: SwitchListTile(
                    title: const Text('Use Right'),
                    subtitle: Text('Right: ${_right.toInt()}'),
                    value: _useRight,
                    onChanged: (value) => setState(() => _useRight = value),
                  ),
                ),
                Expanded(
                  child: SwitchListTile(
                    title: const Text('Use Bottom'),
                    subtitle: Text('Bottom: ${_bottom.toInt()}'),
                    value: _useBottom,
                    onChanged: (value) => setState(() => _useBottom = value),
                  ),
                ),
              ],
            ),

            if (!_useRight) ...[
              Text('Left: ${_left.toInt()}'),
              Slider(
                value: _left,
                min: 0,
                max: 200,
                onChanged: (value) => setState(() => _left = value),
              ),
            ] else ...[
              Text('Right: ${_right.toInt()}'),
              Slider(
                value: _right,
                min: 0,
                max: 200,
                onChanged: (value) => setState(() => _right = value),
              ),
            ],

            if (!_useBottom) ...[
              Text('Top: ${_top.toInt()}'),
              Slider(
                value: _top,
                min: 0,
                max: 150,
                onChanged: (value) => setState(() => _top = value),
              ),
            ] else ...[
              Text('Bottom: ${_bottom.toInt()}'),
              Slider(
                value: _bottom,
                min: 0,
                max: 150,
                onChanged: (value) => setState(() => _bottom = value),
              ),
            ],
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
              '💡 Real-world Examples',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 16),

            // Floating Action Button tùy chỉnh
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Text(
                      'Main Content Area',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),

                  // FAB at the bottom right corner
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: FloatingActionButton(
                      onPressed: () {},
                      backgroundColor: Colors.blue,
                      child: const Icon(Icons.add),
                    ),
                  ),

                  // Notification badge
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        '3',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Close button
                  Positioned(
                    top: 8,
                    left: 8,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.close),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Card với ribbon
            SizedBox(
              width: double.infinity,
              height: 120,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 10, right: 10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Special Product',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text('Description of this amazing product...'),
                        Spacer(),
                        Text(
                          'Price: \$12.99',
                          style: TextStyle(fontSize: 16, color: Colors.green),
                        ),
                      ],
                    ),
                  ),

                  // Ribbon "SALE"
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'SALE',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
}
