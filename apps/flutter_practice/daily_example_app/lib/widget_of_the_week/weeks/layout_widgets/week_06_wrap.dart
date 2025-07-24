import 'package:flutter/material.dart';

class Week06Wrap extends StatefulWidget {
  const Week06Wrap({super.key});

  @override
  State<Week06Wrap> createState() => _Week06WrapState();
}

class _Week06WrapState extends State<Week06Wrap> {
  WrapAlignment _alignment = WrapAlignment.start;
  final WrapCrossAlignment _crossAxisAlignment = WrapCrossAlignment.start;
  Axis _direction = Axis.horizontal;
  double _spacing = 8.0;
  double _runSpacing = 8.0;
  final List<String> _tags = [
    'Flutter',
    'Dart',
    'Mobile',
    'iOS',
    'Android',
    'Web',
    'Desktop',
    'UI/UX',
    'Firebase',
    'API',
    'Database',
    'Git',
    'VS Code',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Week 06: Wrap Widget'),
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
              '📚 Theory: Wrap Widget',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'The Wrap widget automatically flows to the next line (or column) when there isn\'t enough space. '
              'It\'s very useful for tags, chips, and buttons when the number of items is unknown.',
            ),
            const SizedBox(height: 12),
            const Text(
              '🔑 Important properties:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '• direction: The direction to lay out the children (horizontal/vertical).',
            ),
            const Text(
              '• alignment: How the children within a run should be aligned along the main axis.',
            ),
            const Text(
              '• crossAxisAlignment: How the children within a run should be aligned along the cross axis.',
            ),
            const Text(
              '• spacing: The space between children in the main axis.',
            ),
            const Text(
              '• runSpacing: The space between runs in the cross axis.',
            ),
            const SizedBox(height: 12),
            const Text(
              '💡 When to use Wrap:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text('• Dynamic tags and chips.'),
            const Text('• Grids of buttons with variable counts.'),
            const Text('• Responsive layouts.'),
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
            Row(
              children: [
                const Text('Direction: '),
                Switch(
                  value: _direction == Axis.horizontal,
                  onChanged: (value) => setState(() {
                    _direction = value ? Axis.horizontal : Axis.vertical;
                  }),
                ),
                Text(_direction == Axis.horizontal ? 'Horizontal' : 'Vertical'),
              ],
            ),

            const SizedBox(height: 12),

            const Text('Alignment:'),
            DropdownButton<WrapAlignment>(
              value: _alignment,
              isExpanded: true,
              items: const [
                DropdownMenuItem(
                  value: WrapAlignment.start,
                  child: Text('start'),
                ),
                DropdownMenuItem(
                  value: WrapAlignment.center,
                  child: Text('center'),
                ),
                DropdownMenuItem(value: WrapAlignment.end, child: Text('end')),
                DropdownMenuItem(
                  value: WrapAlignment.spaceBetween,
                  child: Text('spaceBetween'),
                ),
                DropdownMenuItem(
                  value: WrapAlignment.spaceAround,
                  child: Text('spaceAround'),
                ),
                DropdownMenuItem(
                  value: WrapAlignment.spaceEvenly,
                  child: Text('spaceEvenly'),
                ),
              ],
              onChanged: (value) => setState(() => _alignment = value!),
            ),

            const SizedBox(height: 12),

            Text('Spacing: ${_spacing.toInt()}'),
            Slider(
              value: _spacing,
              min: 0,
              max: 20,
              onChanged: (value) => setState(() => _spacing = value),
            ),

            Text('Run Spacing: ${_runSpacing.toInt()}'),
            Slider(
              value: _runSpacing,
              min: 0,
              max: 20,
              onChanged: (value) => setState(() => _runSpacing = value),
            ),

            const SizedBox(height: 20),

            // Demo Container
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Wrap(
                direction: _direction,
                alignment: _alignment,
                crossAxisAlignment: _crossAxisAlignment,
                spacing: _spacing,
                runSpacing: _runSpacing,
                children: _tags
                    .map(
                      (tag) => Chip(
                        label: Text(tag),
                        backgroundColor: Colors.teal.shade100,
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () {
                          setState(() {
                            _tags.remove(tag);
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
            ),

            const SizedBox(height: 16),

            // Add tag button
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _tags.add('New Tag ${_tags.length + 1}');
                });
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Tag'),
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

            // Skills tags
            const Text(
              'Skills Tags:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children:
                  ['Flutter', 'React Native', 'iOS', 'Android', 'Firebase']
                      .map(
                        (skill) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            skill,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      )
                      .toList(),
            ),

            const SizedBox(height: 20),

            // Action buttons
            const Text(
              'Action Buttons:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.save, size: 16),
                  label: const Text('Save'),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.share, size: 16),
                  label: const Text('Share'),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download, size: 16),
                  label: const Text('Download'),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.print, size: 16),
                  label: const Text('Print'),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Image gallery
            const Text(
              'Image Gallery:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(
                8,
                (index) => Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.image, color: Colors.grey.shade600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
