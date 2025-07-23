import 'package:flutter/material.dart';

import '../../components/code_examples_manager.dart';
import '../../components/floating_code_button.dart';

class Week10RawMagnifier extends StatefulWidget {
  const Week10RawMagnifier({super.key});

  @override
  State<Week10RawMagnifier> createState() => _Week10RawMagnifierState();
}

class _Week10RawMagnifierState extends State<Week10RawMagnifier> {
  bool _showMagnifier = false;
  Offset _magnifierPosition = Offset.zero;

  // Magnifier settings
  double _magnificationScale = 2.0;
  double _magnifierSize = 100.0;
  bool _clipBehavior = true;

  // Text for magnification demo
  final String _sampleText = '''🔍 RawMagnifier Widget Demo

This is a sample text to demonstrate the zoom feature of RawMagnifier. 
You can move your mouse or touch the screen to see the magnifying glass effect.

RawMagnifier is very useful for:
• Reading small text
• Viewing image details
• Accessibility for visually impaired users
• Interactive games and applications

Try moving the cursor around to see the zoom effect!

Lorem ipsum dolor sit amet, consectetur adipiscing elit. 
Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. 
Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.

🎯 Tips: You can adjust the magnification scale and magnifier size below.
  ''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Week 10: RawMagnifier Widget'),
        backgroundColor: Colors.deepPurple,
      ),
      floatingActionButton: FloatingCodeButton(
        examples: _getMagnifierExamples(),
        lessonTitle: 'RawMagnifier Widget',
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
              '📚 Theory: RawMagnifier Widget',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'RawMagnifier is a widget that creates a magnifying glass effect to zoom in on a part of the screen. '
              'It\'s very useful for accessibility, reading small text, or viewing image details.',
            ),
            const SizedBox(height: 12),
            const Text(
              '🔑 Important properties:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('• magnificationScale: The zoom level (1.0 = no zoom)'),
            const Text('• size: The size of the magnifier'),
            const Text('• focalPointOffset: The focal point of the zoom'),
            const Text('• decoration: The decoration for the magnifier border'),
            const Text('• clipBehavior: How to handle overflow'),
            const SizedBox(height: 12),
            const Text(
              '🎯 Common use cases:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text('• Text magnification for visually impaired users'),
            const Text('• Image detail viewer'),
            const Text('• Map zoom functionality'),
            const Text('• Game magnifying glass'),
            const Text('• Reading assistance tools'),
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
              '🎮 Interactive Demo - Text Magnifier',
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
                      '⚙️ Magnifier Settings:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    // Magnification scale
                    Text(
                      'Magnification Scale: ${_magnificationScale.toStringAsFixed(1)}x',
                    ),
                    Slider(
                      value: _magnificationScale,
                      min: 1.0,
                      max: 5.0,
                      divisions: 8,
                      onChanged: (value) =>
                          setState(() => _magnificationScale = value),
                    ),

                    // Magnifier size
                    Text('Magnifier Size: ${_magnifierSize.toInt()}px'),
                    Slider(
                      value: _magnifierSize,
                      min: 50.0,
                      max: 200.0,
                      divisions: 15,
                      onChanged: (value) =>
                          setState(() => _magnifierSize = value),
                    ),

                    // Clip behavior
                    SwitchListTile(
                      title: const Text('Clip Overflow'),
                      subtitle: const Text(
                        'Clips content that overflows the magnifier',
                      ),
                      value: _clipBehavior,
                      onChanged: (value) =>
                          setState(() => _clipBehavior = value),
                      dense: true,
                    ),

                    // Show/hide toggle
                    SwitchListTile(
                      title: const Text('Show Magnifier'),
                      subtitle: const Text('Toggle the magnifier effect'),
                      value: _showMagnifier,
                      onChanged: (value) =>
                          setState(() => _showMagnifier = value),
                      dense: true,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Magnifier demo area
            Container(
              width: double.infinity,
              height: 400,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  // Content to magnify
                  Positioned.fill(
                    child: MouseRegion(
                      onHover: (event) {
                        setState(() {
                          _magnifierPosition = event.localPosition;
                        });
                      },
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            _magnifierPosition = details.localPosition;
                          });
                        },
                        onTapDown: (details) {
                          setState(() {
                            _magnifierPosition = details.localPosition;
                            _showMagnifier = true;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Sample text
                                Text(
                                  _sampleText,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    height: 1.5,
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // Sample image
                                Container(
                                  width: double.infinity,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.blue,
                                        Colors.purple,
                                        Colors.pink,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '🖼️ Sample Image\nHover to magnify details',
                                      textAlign: TextAlign.center,
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
                        ),
                      ),
                    ),
                  ),

                  // Magnifier overlay
                  if (_showMagnifier)
                    Positioned(
                      left: _magnifierPosition.dx - _magnifierSize / 2,
                      top: _magnifierPosition.dy - _magnifierSize / 2,
                      child: RawMagnifier(
                        decoration: MagnifierDecoration(
                          shape: const CircleBorder(
                            side: BorderSide(
                              color: Colors.deepPurple,
                              width: 3,
                            ),
                          ),
                          shadows: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        size: Size(_magnifierSize, _magnifierSize),
                        magnificationScale: _magnificationScale,
                        focalPointOffset: _magnifierPosition,
                        clipBehavior: _clipBehavior ? Clip.hardEdge : Clip.none,
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Instructions
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💡 How to use:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('• Move the mouse over the text to see the zoom effect'),
                  Text('• On mobile: tap and drag to move the magnifier'),
                  Text(
                    '• Adjust the magnification scale and size in the settings section',
                  ),
                  Text(
                    '• Toggle the magnifier on/off with the "Show Magnifier" switch',
                  ),
                ],
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
              '💡 Real-world Examples',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 16),

            // Simple magnifier example
            const Text(
              '1. Simple Magnifier:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: const Text(
                        'This is sample text with a small font size. '
                        'RawMagnifier helps to zoom in for easier reading. '
                        'It is very useful for people with vision problems.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  const Positioned(
                    right: 20,
                    top: 20,
                    child: RawMagnifier(
                      size: Size(80, 80),
                      magnificationScale: 2.5,
                      decoration: MagnifierDecoration(
                        shape: CircleBorder(
                          side: BorderSide(color: Colors.blue, width: 2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Image magnifier example
            const Text(
              '2. Image Magnification:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.red, Colors.orange, Colors.yellow],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          '🌅 Beautiful Gradient\nWith fine details',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 30,
                    bottom: 30,
                    child: RawMagnifier(
                      size: Size(60, 60),
                      magnificationScale: 3.0,
                      decoration: MagnifierDecoration(
                        shape: CircleBorder(
                          side: BorderSide(color: Colors.white, width: 3),
                        ),
                        shadows: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Custom shaped magnifier
            const Text(
              '3. Square-shaped Magnifier:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: const Text(
                        '📊 Data Analysis Dashboard\n'
                        'Revenue: \$1,234,567\n'
                        'Growth: +15.3%\n'
                        'Users: 45,678',
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 15,
                    bottom: 15,
                    child: RawMagnifier(
                      size: Size(70, 70),
                      magnificationScale: 2.0,
                      decoration: MagnifierDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: Colors.green, width: 2),
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

  List<CodeExample> _getMagnifierExamples() {
    return [
      const CodeExample(
        title: 'Basic RawMagnifier',
        code: '''
RawMagnifier(
  size: Size(100, 100),
  magnificationScale: 2.0,
  decoration: MagnifierDecoration(
    shape: CircleBorder(
      side: BorderSide(
        color: Colors.blue,
        width: 2,
      ),
    ),
  ),
)''',
      ),
      const CodeExample(
        title: 'Magnifier with custom decoration',
        code: '''
RawMagnifier(
  size: Size(120, 120),
  magnificationScale: 3.0,
  focalPointOffset: Offset(50, 50),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: Colors.purple,
      width: 3,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.3),
        blurRadius: 10,
        offset: Offset(0, 5),
      ),
    ],
  ),
  clipBehavior: Clip.hardEdge,
)''',
      ),
      const CodeExample(
        title: 'Interactive magnifier with gestures',
        code: '''
class InteractiveMagnifier extends StatefulWidget {
  @override
  _InteractiveMagnifierState createState() => _InteractiveMagnifierState();
}

class _InteractiveMagnifierState extends State<InteractiveMagnifier> {
  Offset _position = Offset.zero;
  bool _showMagnifier = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _position = details.localPosition;
          _showMagnifier = true;
        });
      },
      onPanEnd: (details) {
        setState(() {
          _showMagnifier = false;
        });
      },
      child: Stack(
        children: [
          // Your content here
          Container(
            width: double.infinity,
            height: 300,
            child: Text('Content to magnify'),
          ),
          
          // Magnifier
          if (_showMagnifier)
            Positioned(
              left: _position.dx - 50,
              top: _position.dy - 50,
              child: RawMagnifier(
                size: Size(100, 100),
                magnificationScale: 2.5,
                focalPointOffset: _position,
              ),
            ),
        ],
      ),
    );
  }
}''',
      ),
    ];
  }
}
