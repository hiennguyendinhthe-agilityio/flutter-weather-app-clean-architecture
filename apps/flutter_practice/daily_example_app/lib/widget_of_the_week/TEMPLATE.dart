import 'package:flutter/material.dart';

// TEMPLATE FOR NEW LESSONS
// Copy this file and rename to week_XX_widget_name.dart

class WeekXXWidgetName extends StatefulWidget {
  const WeekXXWidgetName({super.key});

  @override
  State<WeekXXWidgetName> createState() => _WeekXXWidgetNameState();
}

class _WeekXXWidgetNameState extends State<WeekXXWidgetName> {
  // TODO: Add state variables for interactive demo
  // Example:
  // double _value = 0.0;
  // Color _color = Colors.blue;
  // bool _isEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Week XX: Widget Name'), // TODO: Update title
        backgroundColor: Colors.blue, // TODO: Choose appropriate color
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
              '📚 Theory: Widget Name', // TODO: Update widget name
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue, // TODO: Choose appropriate color
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'TODO: Explain what this widget is, what it does, when to use it.',
            ),
            const SizedBox(height: 12),
            const Text(
              '🔑 Important properties:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // TODO: List important properties
            const Text('• property1: Description of property 1'),
            const Text('• property2: Description of property 2'),
            const Text('• property3: Description of property 3'),
            const SizedBox(height: 12),
            const Text(
              '💡 TODO: Add tips and best practices!',
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.orange),
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
            
            // TODO: Add demo widget here
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'TODO: Add interactive demo widget here',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // TODO: Add controls to change properties
            // Example:
            // Text('Value: $_value'),
            // Slider(
            //   value: _value,
            //   min: 0,
            //   max: 100,
            //   onChanged: (value) => setState(() => _value = value),
            // ),
            
            const Text('TODO: Add controls here'),
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
            
            // TODO: Add 2-3 real examples using this widget
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Example 1: TODO - Describe use case',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('TODO: Add code example or UI demo'),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Example 2: TODO - Describe another use case',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('TODO: Add code example or UI demo'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


}