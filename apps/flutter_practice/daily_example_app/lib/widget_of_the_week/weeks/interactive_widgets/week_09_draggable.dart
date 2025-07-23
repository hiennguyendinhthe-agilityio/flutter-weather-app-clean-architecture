import 'package:flutter/material.dart';

import '../../components/code_examples_manager.dart';
import '../../components/floating_code_button.dart';

class Week09Draggable extends StatefulWidget {
  const Week09Draggable({super.key});

  @override
  State<Week09Draggable> createState() => _Week09DraggableState();
}

class _Week09DraggableState extends State<Week09Draggable> {
  List<DragItem> _items = [
    DragItem(id: 1, name: 'Apple 🍎', color: Colors.red),
    DragItem(id: 2, name: 'Orange 🍊', color: Colors.orange),
    DragItem(id: 3, name: 'Banana 🍌', color: Colors.yellow),
    DragItem(id: 4, name: 'Grape 🍇', color: Colors.purple),
  ];

  final List<DragItem> _basket = [];
  String _feedbackText = 'Drag fruits into the basket!';

  // Drag settings
  Axis? _dragAxis;
  bool _enableFeedback = true;
  double _dragOpacity = 0.7;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Week 09: Draggable Widget'),
        backgroundColor: Colors.green,
      ),
      floatingActionButton: FloatingCodeButton(
        examples: _getDraggableExamples(),
        lessonTitle: 'Draggable Widget',
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
              '📚 Theory: Draggable Widget',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'The Draggable widget allows users to drag and drop a widget from one position to another. '
              'It is very useful for features like list sorting, puzzle games, or drag-and-drop interactions.',
            ),
            const SizedBox(height: 12),
            const Text(
              '🔑 Important Properties:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('• child: The widget displayed when not being dragged'),
            const Text('• feedback: The widget displayed while being dragged'),
            const Text(
              '• childWhenDragging: The widget displayed at the original position while dragging',
            ),
            const Text('• data: The data transferred on drop'),
            const Text(
              '• axis: Constrains the drag direction (horizontal/vertical)',
            ),
            const Text('• onDragStarted: Callback when dragging starts'),
            const Text('• onDragEnd: Callback when dragging ends'),
            const SizedBox(height: 12),
            const Text(
              '🎯 Combining with DragTarget:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text('• DragTarget receives data from a Draggable'),
            const Text('• onAccept: Handles a successful drop'),
            const Text(
              '• onWillAccept: Checks if the target will accept the data',
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
              '🎮 Interactive Demo - Fruit Sorting Game',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),

            // Controls
            Card(
              color: Colors.grey.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '⚙️ Settings:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    // Drag axis
                    Row(
                      children: [
                        const Text('Drag Axis: '),
                        DropdownButton<Axis?>(
                          value: _dragAxis,
                          items: const [
                            DropdownMenuItem(value: null, child: Text('Free')),
                            DropdownMenuItem(
                              value: Axis.horizontal,
                              child: Text('Horizontal'),
                            ),
                            DropdownMenuItem(
                              value: Axis.vertical,
                              child: Text('Vertical'),
                            ),
                          ],
                          onChanged: (value) =>
                              setState(() => _dragAxis = value),
                        ),
                      ],
                    ),

                    // Feedback
                    SwitchListTile(
                      title: const Text('Enable Feedback'),
                      value: _enableFeedback,
                      onChanged: (value) =>
                          setState(() => _enableFeedback = value),
                      dense: true,
                    ),

                    // Opacity
                    Text(
                      'Opacity while dragging: ${(_dragOpacity * 100).toInt()}%',
                    ),
                    Slider(
                      value: _dragOpacity,
                      min: 0.1,
                      max: 1.0,
                      onChanged: (value) =>
                          setState(() => _dragOpacity = value),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Game area
            Text(
              _feedbackText,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // Fruits area
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                children: [
                  const Text(
                    '🍎 Fruits:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _items
                        .map((item) => _buildDraggableItem(item))
                        .toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Basket area
            DragTarget<DragItem>(
              onAcceptWithDetails: (details) {
                final item = details.data;
                setState(() {
                  _basket.add(item);
                  _items.remove(item);
                  _feedbackText = '✅ Added ${item.name} to the basket!';
                });

                // Reset feedback after 2 seconds
                Future.delayed(const Duration(seconds: 2), () {
                  if (mounted) {
                    setState(() {
                      _feedbackText = _items.isEmpty
                          ? '🎉 Complete! All fruits are in the basket!'
                          : 'Drag fruits into the basket!';
                    });
                  }
                });
              },
              onWillAcceptWithDetails: (details) => true,
              onMove: (details) {
                setState(() {
                  _feedbackText = '🎯 Drop here to add to the basket!';
                });
              },
              onLeave: (item) {
                setState(() {
                  _feedbackText = 'Drag fruits into the basket!';
                });
              },
              builder: (context, candidateData, rejectedData) {
                final isHovering = candidateData.isNotEmpty;
                return Container(
                  width: double.infinity,
                  height: 120,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isHovering
                        ? Colors.orange.shade100
                        : Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isHovering
                          ? Colors.orange
                          : Colors.orange.shade200,
                      width: isHovering ? 3 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_basket,
                        size: 40,
                        color: isHovering
                            ? Colors.orange
                            : Colors.orange.shade400,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '🧺 Fruit Basket (${_basket.length})',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (_basket.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          children: _basket
                              .map(
                                (item) => Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Text(
                                    item.name.split(' ')[1],
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // Reset button
            if (_items.isEmpty || _basket.isNotEmpty)
              Center(
                child: ElevatedButton.icon(
                  onPressed: _resetGame,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Play Again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDraggableItem(DragItem item) {
    return Draggable<DragItem>(
      data: item,
      axis: _dragAxis,
      feedback: _enableFeedback
          ? Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: _dragOpacity),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(),
      childWhenDragging: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey.shade400,
            style: BorderStyle.solid,
          ),
        ),
        child: Text(
          item.name,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onDragStarted: () {
        setState(() {
          _feedbackText = '🚀 Dragging ${item.name}...';
        });
      },
      onDragEnd: (details) {
        setState(() {
          _feedbackText = 'Drag fruits into the basket!';
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: item.color,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          item.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
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

            // Simple drag example
            const Text(
              '1. Simple Drag and Drop:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Draggable<String>(
                  data: 'Hello',
                  feedback: Material(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.blue,
                      child: const Text(
                        'Hello',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.blue,
                    child: const Text(
                      'Drag me',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                DragTarget<String>(
                  onAcceptWithDetails: (details) {
                    final data = details.data;
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Received: $data')));
                  },
                  builder: (context, candidateData, rejectedData) {
                    return Container(
                      width: 100,
                      height: 50,
                      decoration: BoxDecoration(
                        color: candidateData.isNotEmpty
                            ? Colors.green.shade100
                            : Colors.grey.shade200,
                        border: Border.all(color: Colors.grey),
                      ),
                      child: const Center(child: Text('Drop here')),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Reorderable list example
            const Text(
              '2. Reorderable List:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              height: 200,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ReorderableListView(
                children: [
                  for (int i = 0; i < 5; i++)
                    ListTile(
                      key: ValueKey(i),
                      leading: const Icon(Icons.drag_handle),
                      title: Text('Item ${i + 1}'),
                      tileColor: Colors.blue.shade50,
                    ),
                ],
                onReorder: (oldIndex, newIndex) {
                  // Handle reorder logic
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _resetGame() {
    setState(() {
      _items = [
        DragItem(id: 1, name: 'Apple 🍎', color: Colors.red),
        DragItem(id: 2, name: 'Orange 🍊', color: Colors.orange),
        DragItem(id: 3, name: 'Banana 🍌', color: Colors.yellow),
        DragItem(id: 4, name: 'Grape 🍇', color: Colors.purple),
      ];
      _basket.clear();
      _feedbackText = 'Drag fruits into the basket!';
    });
  }

  List<CodeExample> _getDraggableExamples() {
    return [
      const CodeExample(
        title: 'Basic Draggable',
        code: '''
Draggable<String>(
  data: 'Hello World',
  feedback: Material(
    child: Container(
      padding: EdgeInsets.all(8),
      color: Colors.blue,
      child: Text('Dragging...', 
        style: TextStyle(color: Colors.white)),
    ),
  ),
  childWhenDragging: Container(
    padding: EdgeInsets.all(8),
    color: Colors.grey,
    child: Text('Original position'),
  ),
  child: Container(
    padding: EdgeInsets.all(8),
    color: Colors.blue,
    child: Text('Drag me!', 
      style: TextStyle(color: Colors.white)),
  ),
)''',
      ),
      const CodeExample(
        title: 'DragTarget Receiving Data',
        code: '''
DragTarget<String>(
  onAccept: (data) {
    print('Received: \$data');
    // Handle received data
  },
  onWillAccept: (data) {
    // Check if data is acceptable
    return data != null;
  },
  builder: (context, candidateData, rejectedData) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: candidateData.isNotEmpty 
            ? Colors.green.shade100 
            : Colors.grey.shade200,
        border: Border.all(color: Colors.grey),
      ),
      child: Center(
        child: Text(candidateData.isNotEmpty 
            ? 'Drop here!' 
            : 'Drag target'),
      ),
    );
  },
)''',
      ),
      const CodeExample(
        title: 'Draggable with Axis Constraint',
        code: '''
Draggable<int>(
  data: 42,
  axis: Axis.horizontal, // Only drag horizontally
  feedback: Material(
    elevation: 8,
    child: Container(
      width: 80,
      height: 40,
      color: Colors.red,
      child: Center(
        child: Text('42', 
          style: TextStyle(color: Colors.white)),
      ),
    ),
  ),
  onDragStarted: () => print('Drag started'),
  onDragEnd: (details) => print('Drag ended'),
  child: Container(
    width: 80,
    height: 40,
    color: Colors.blue,
    child: Center(
      child: Text('42', 
        style: TextStyle(color: Colors.white)),
    ),
  ),
)''',
      ),
    ];
  }
}

class DragItem {
  final int id;
  final String name;
  final Color color;

  DragItem({required this.id, required this.name, required this.color});
}
