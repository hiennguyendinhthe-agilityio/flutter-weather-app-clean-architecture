import 'package:flutter/material.dart';
import '../../components/code_viewer.dart';
import '../../components/code_examples.dart';
import '../../components/code_examples_manager.dart';
import '../../components/floating_code_button.dart';

class Week01Container extends StatefulWidget {
  const Week01Container({super.key});

  @override
  State<Week01Container> createState() => _Week01ContainerState();
}

class _Week01ContainerState extends State<Week01Container> {
  double _width = 200;
  double _height = 200;
  Color _color = Colors.blue;
  double _borderRadius = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Week 01: Container Widget'),
        backgroundColor: Colors.blue,
      ),
      floatingActionButton: FloatingCodeButton(
        examples: CommonCodeExamples.containerExamples,
        lessonTitle: 'Container Widget',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Theory
            _buildTheorySection(),
            
            const SizedBox(height: 24),
            
            // Interactive Demo
            _buildInteractiveDemo(),
            
            const SizedBox(height: 24),
            
            // Real Examples
            _buildExamples(),
            
            const SizedBox(height: 24),
            
            // Code Examples Section
            _buildCodeExamplesSection(),
            
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
              '📚 Theory: Container Widget',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Container is one of the most basic and important widgets in Flutter. '
              'It allows you to create a "box" that can contain other widgets and customize the interface.',
            ),
            const SizedBox(height: 12),
            const Text(
              '🔑 Important properties:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('• width, height: Size dimensions'),
            const Text('• color: Background color'),
            const Text('• decoration: Styling (border, gradient, shadow...)'),
            const Text('• padding: Inner spacing'),
            const Text('• margin: Outer spacing'),
            const Text('• alignment: Content alignment'),
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
            
            // Container demo
            Center(
              child: Container(
                width: _width,
                height: _height,
                decoration: BoxDecoration(
                  color: _color,
                  borderRadius: BorderRadius.circular(_borderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'Container',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Controls
            Text('Width: ${_width.toInt()}'),
            Slider(
              value: _width,
              min: 100,
              max: 300,
              onChanged: (value) => setState(() => _width = value),
            ),
            
            Text('Height: ${_height.toInt()}'),
            Slider(
              value: _height,
              min: 100,
              max: 300,
              onChanged: (value) => setState(() => _height = value),
            ),
            
            Text('Border Radius: ${_borderRadius.toInt()}'),
            Slider(
              value: _borderRadius,
              min: 0,
              max: 50,
              onChanged: (value) => setState(() => _borderRadius = value),
            ),
            
            const Text('Colors:'),
            Row(
              children: [
                _colorButton(Colors.blue),
                _colorButton(Colors.red),
                _colorButton(Colors.green),
                _colorButton(Colors.orange),
                _colorButton(Colors.purple),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _colorButton(Color color) {
    return GestureDetector(
      onTap: () => setState(() => _color = color),
      child: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: _color == color 
              ? Border.all(color: Colors.black, width: 3)
              : null,
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
            
            // Card-like container with code
            QuickCodeExample(
              title: 'Card-style Container',
              code: CodeExamples.containerCard,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Card-style Container',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('Sử dụng Container để tạo card với shadow và border radius'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            const SizedBox(height: 16),
            
            // Gradient container with code
            QuickCodeExample(
              title: 'Gradient Container',
              code: CodeExamples.containerGradient,
              child: Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.purple, Colors.blue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'Gradient Container',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeExamplesSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '💻 Code Examples',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 16),
            
            const Text(
              'Dưới đây là các code examples bạn có thể sao chép và sử dụng:',
              style: TextStyle(fontSize: 14),
            ),
            
            const SizedBox(height: 16),
            
            // Basic Container
            CodeViewer(
              title: 'Container cơ bản với decoration',
              code: CodeExamples.containerBasic,
            ),
            
            const SizedBox(height: 12),
            
            // Interactive demo code
            CodeViewer(
              title: 'Container với properties động',
              code: '''
Container(
  width: \$_width,
  height: \$_height,
  decoration: BoxDecoration(
    color: \$_color,
    borderRadius: BorderRadius.circular(\$_borderRadius),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 8,
        offset: Offset(0, 4),
      ),
    ],
  ),
  child: Center(
    child: Text(
      'Container',
      style: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
)''',
            ),
          ],
        ),
      ),
    );
  }
}