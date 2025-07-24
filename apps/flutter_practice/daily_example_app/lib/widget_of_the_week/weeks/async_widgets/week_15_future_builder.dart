import 'dart:async';

import 'package:flutter/material.dart';

import '../../components/code_examples_manager.dart';
import '../../components/floating_code_button.dart';

/// Week 15: FutureBuilder Widget - Comprehensive Learning Module
///
/// Learn about the FutureBuilder widget in Flutter:
/// - Handling async operations and Future objects
/// - ConnectionState and snapshot handling
/// - Error handling and loading states
/// - Real-world patterns with API calls
/// - Performance optimization and best practices
class Week15FutureBuilder extends StatefulWidget {
  const Week15FutureBuilder({super.key});

  @override
  State<Week15FutureBuilder> createState() => _Week15FutureBuilderState();
}

class _Week15FutureBuilderState extends State<Week15FutureBuilder> {
  // Demo futures for different scenarios
  Future<String>? _currentFuture;
  String _selectedDemo = 'success';
  bool _showAdvanced = false;

  // Simulated data
  final List<Map<String, dynamic>> _users = [
    {
      'id': 1,
      'name': 'John Doe',
      'email': 'john.d@example.com',
      'avatar': '👨‍💻',
    },
    {
      'id': 2,
      'name': 'Jane Smith',
      'email': 'jane.s@example.com',
      'avatar': '👩‍🎨',
    },
    {
      'id': 3,
      'name': 'Peter Jones',
      'email': 'peter.j@example.com',
      'avatar': '👨‍🔬',
    },
  ];

  @override
  void initState() {
    super.initState();
    _currentFuture = _getSuccessData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Week 15: FutureBuilder Widget'),
        backgroundColor: Colors.teal,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_showAdvanced ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(() => _showAdvanced = !_showAdvanced),
            tooltip: _showAdvanced ? 'Hide Advanced' : 'Show Advanced',
          ),
        ],
      ),
      floatingActionButton: FloatingCodeButton(
        examples: _getFutureBuilderExamples(),
        lessonTitle: 'FutureBuilder Widget - Week 15',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTheorySection(),
            const SizedBox(height: 20),
            _buildDartFundamentals(),
            const SizedBox(height: 20),
            _buildDemoSelector(),
            const SizedBox(height: 20),
            _buildInteractiveDemo(),
            const SizedBox(height: 20),
            _buildRealWorldExamples(),
            const SizedBox(height: 20),
            if (_showAdvanced) ...[
              _buildAdvancedSection(),
              const SizedBox(height: 20),
            ],
            _buildBestPractices(),
            const SizedBox(height: 20),
            _buildExercises(),
          ],
        ),
      ),
    );
  }

  Widget _buildTheorySection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.hourglass_empty, color: Colors.teal),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'FutureBuilder - The Async Widget Master',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: const Text(
                '🎯 FutureBuilder is a special widget for handling async operations. '
                'It automatically rebuilds the UI when a Future completes, helping to handle loading states, '
                'success data, and error cases elegantly.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ),

            const SizedBox(height: 20),

            _buildConnectionStatesGrid(),

            const SizedBox(height: 20),

            _buildAsyncConcepts(),
          ],
        ),
      ),
    );
  }

  Widget _buildDartFundamentals() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.code, color: Colors.blue),
                ),
                const SizedBox(width: 12),
                Text(
                  'Dart Async Fundamentals',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            _buildDartConcept(
              'Future<T>',
              'Represents a value that will be available in the future',
              '''
Future<String> fetchData() async {
  await Future.delayed(Duration(seconds: 2));
  return "Data loaded!";
}
''',
              Colors.blue,
            ),

            const SizedBox(height: 12),

            _buildDartConcept(
              'async/await',
              'Syntax to write async code like synchronous code',
              '''
// Instead of callback hell:
fetchData().then((data) => print(data));

// Using async/await:
final data = await fetchData();
print(data);
''',
              Colors.green,
            ),

            const SizedBox(height: 12),

            _buildDartConcept(
              'Error Handling',
              'Using try-catch for async operations',
              '''
try {
  final result = await riskyOperation();
  print('Success: \$result');
} catch (error) {
  print('Error: \$error');
}
''',
              Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDartConcept(
    String title,
    String description,
    String code,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              code,
              style: const TextStyle(
                color: Colors.green,
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionStatesGrid() {
    final states = [
      {
        'state': 'none',
        'icon': Icons.radio_button_unchecked,
        'title': 'ConnectionState.none',
        'desc': 'No Future provided',
        'color': Colors.grey,
      },
      {
        'state': 'waiting',
        'icon': Icons.hourglass_empty,
        'title': 'ConnectionState.waiting',
        'desc': 'Future is running',
        'color': Colors.orange,
      },
      {
        'state': 'active',
        'icon': Icons.stream,
        'title': 'ConnectionState.active',
        'desc': 'Stream is active (for StreamBuilder)',
        'color': Colors.blue,
      },
      {
        'state': 'done',
        'icon': Icons.check_circle,
        'title': 'ConnectionState.done',
        'desc': 'Future is complete',
        'color': Colors.green,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🔄 ConnectionState in FutureBuilder:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: states.length,
          itemBuilder: (context, index) {
            final state = states[index];
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (state['color'] as Color).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: (state['color'] as Color).withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        state['icon'] as IconData,
                        color: state['color'] as Color,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          state['title'] as String,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: state['color'] as Color,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    state['desc'] as String,
                    style: const TextStyle(fontSize: 11),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAsyncConcepts() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.teal.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.psychology, color: Colors.teal.shade700),
              const SizedBox(width: 8),
              Text(
                'Async Programming Concepts',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.teal.shade700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text('🔄 Asynchronous: Code that doesn\'t block the UI thread'),
          const SizedBox(height: 6),
          const Text('⏳ Future: A promise of a value in the future'),
          const SizedBox(height: 6),
          const Text('🎯 Snapshot: The current state of the Future'),
          const SizedBox(height: 6),
          const Text('🛡️ Error Handling: Handling errors gracefully'),
          const SizedBox(height: 6),
          const Text('🚀 Performance: Doesn\'t block the main thread'),
        ],
      ),
    );
  }

  Widget _buildDemoSelector() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.science, color: Colors.purple),
                const SizedBox(width: 8),
                Text(
                  'Demo Scenarios',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _buildDemoChip(
                  'success',
                  'Success Case',
                  Icons.check_circle,
                  Colors.green,
                ),
                _buildDemoChip('error', 'Error Case', Icons.error, Colors.red),
                _buildDemoChip(
                  'slow',
                  'Slow Loading',
                  Icons.hourglass_empty,
                  Colors.orange,
                ),
                _buildDemoChip(
                  'timeout',
                  'Timeout',
                  Icons.timer_off,
                  Colors.grey,
                ),
              ],
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.purple.shade200),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info, color: Colors.purple, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Select a scenario to test different cases of FutureBuilder',
                      style: TextStyle(fontSize: 13),
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

  Widget _buildDemoChip(String type, String label, IconData icon, Color color) {
    final isSelected = _selectedDemo == type;
    return FilterChip(
      selected: isSelected,
      avatar: Icon(icon, size: 18, color: isSelected ? color : Colors.grey),
      label: Text(label),
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedDemo = type;
            _currentFuture = _getFutureForDemo(type);
          });
        }
      },
      selectedColor: color.withValues(alpha: 0.2),
      backgroundColor: Colors.white,
      side: BorderSide(
        color: isSelected ? color : Colors.grey.shade300,
        width: isSelected ? 2 : 1,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  Widget _buildInteractiveDemo() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.play_arrow, color: Colors.indigo),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Live FutureBuilder Demo',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // FutureBuilder demo area
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.grey.shade50, Colors.grey.shade100],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300, width: 2),
              ),
              child: FutureBuilder<String>(
                future: _currentFuture,
                builder: (context, snapshot) {
                  return _buildFutureBuilderContent(snapshot);
                },
              ),
            ),

            const SizedBox(height: 16),

            // Control buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _currentFuture = _getFutureForDemo(_selectedDemo);
                    });
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.withValues(alpha: 0.1),
                    foregroundColor: Colors.blue,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _currentFuture = null;
                    });
                  },
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.withValues(alpha: 0.1),
                    foregroundColor: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFutureBuilderContent(AsyncSnapshot<String> snapshot) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Connection state indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getStateColor(
                snapshot.connectionState,
              ).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _getStateColor(snapshot.connectionState),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getStateIcon(snapshot.connectionState),
                  size: 16,
                  color: _getStateColor(snapshot.connectionState),
                ),
                const SizedBox(width: 6),
                Text(
                  'ConnectionState.${snapshot.connectionState.name}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _getStateColor(snapshot.connectionState),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Content based on state
          if (snapshot.connectionState == ConnectionState.waiting) ...[
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text('Loading...', style: TextStyle(fontSize: 16)),
          ] else if (snapshot.hasError) ...[
            const Icon(Icons.error, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ] else if (snapshot.hasData) ...[
            const Icon(Icons.check_circle, color: Colors.green, size: 48),
            const SizedBox(height: 16),
            Text(
              snapshot.data!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ] else ...[
            const Icon(
              Icons.radio_button_unchecked,
              color: Colors.grey,
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'No Future provided',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ],
      ),
    );
  }

  Color _getStateColor(ConnectionState state) {
    switch (state) {
      case ConnectionState.none:
        return Colors.grey;
      case ConnectionState.waiting:
        return Colors.orange;
      case ConnectionState.active:
        return Colors.blue;
      case ConnectionState.done:
        return Colors.green;
    }
  }

  IconData _getStateIcon(ConnectionState state) {
    switch (state) {
      case ConnectionState.none:
        return Icons.radio_button_unchecked;
      case ConnectionState.waiting:
        return Icons.hourglass_empty;
      case ConnectionState.active:
        return Icons.stream;
      case ConnectionState.done:
        return Icons.check_circle;
    }
  }

  // Demo futures
  Future<String> _getFutureForDemo(String type) {
    switch (type) {
      case 'success':
        return _getSuccessData();
      case 'error':
        return _getErrorData();
      case 'slow':
        return _getSlowData();
      case 'timeout':
        return _getTimeoutData();
      default:
        return _getSuccessData();
    }
  }

  Future<String> _getSuccessData() async {
    await Future.delayed(const Duration(seconds: 1));
    return '✅ Data loaded successfully!';
  }

  Future<String> _getErrorData() async {
    await Future.delayed(const Duration(milliseconds: 800));
    throw Exception('Network error occurred');
  }

  Future<String> _getSlowData() async {
    await Future.delayed(const Duration(seconds: 4));
    return '🐌 Slow data finally loaded!';
  }

  Future<String> _getTimeoutData() async {
    await Future.delayed(const Duration(seconds: 10));
    return 'This will timeout';
  }

  Widget _buildRealWorldExamples() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.apps, color: Colors.orange),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Real-World Examples',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // User List Example
            _buildRealWorldExample(
              '👥 User List from API',
              'Fetch and display a list of users',
              _buildUserListDemo(),
            ),

            const SizedBox(height: 16),

            // Weather Example
            _buildRealWorldExample(
              '🌤️ Weather Data',
              'Async weather information',
              _buildWeatherDemo(),
            ),

            const SizedBox(height: 16),

            // File Loading Example
            _buildRealWorldExample(
              '📁 File Processing',
              'Load và process files',
              _buildFileDemo(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRealWorldExample(String title, String description, Widget demo) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
          const SizedBox(height: 12),
          demo,
        ],
      ),
    );
  }

  Widget _buildUserListDemo() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.error, color: Colors.red),
                const SizedBox(width: 8),
                Text('Error: ${snapshot.error}'),
              ],
            ),
          );
        }

        if (snapshot.hasData) {
          return Column(
            children: snapshot.data!
                .map(
                  (user) => ListTile(
                    leading: CircleAvatar(child: Text(user['avatar'])),
                    title: Text(user['name']),
                    subtitle: Text(user['email']),
                    dense: true,
                  ),
                )
                .toList(),
          );
        }

        return const Text('No data');
      },
    );
  }

  Widget _buildWeatherDemo() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchWeather(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 12),
              Text('Fetching weather...'),
            ],
          );
        }

        if (snapshot.hasData) {
          final weather = snapshot.data!;
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade100, Colors.blue.shade200],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text(weather['icon'], style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        weather['location'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('${weather['temp']}°C - ${weather['condition']}'),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return const Text('Weather unavailable');
      },
    );
  }

  Widget _buildFileDemo() {
    return FutureBuilder<String>(
      future: _processFile(),
      builder: (context, snapshot) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              if (snapshot.connectionState == ConnectionState.waiting)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else if (snapshot.hasData)
                const Icon(Icons.check_circle, color: Colors.green)
              else
                const Icon(Icons.folder, color: Colors.grey),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  snapshot.connectionState == ConnectionState.waiting
                      ? 'Processing file...'
                      : snapshot.hasData
                      ? snapshot.data!
                      : 'Ready to process',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Simulated async functions
  Future<List<Map<String, dynamic>>> _fetchUsers() async {
    await Future.delayed(const Duration(seconds: 2));
    return _users;
  }

  Future<Map<String, dynamic>> _fetchWeather() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return {
      'location': 'Hanoi',
      'temp': 28,
      'condition': 'Sunny',
      'icon': '☀️',
    };
  }

  Future<String> _processFile() async {
    await Future.delayed(const Duration(seconds: 3));
    return '📄 File processed: 1,234 lines';
  }

  Widget _buildAdvancedSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.science, color: Colors.purple),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Advanced FutureBuilder Techniques',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _buildAdvancedTopic(
              'Future Caching',
              'Avoid unnecessary rebuilds',
              '''
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late Future<String> _future;
  
  @override
  void initState() {
    super.initState();
    _future = fetchData(); // Cache future
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _future, // Reuse cached future
      builder: (context, snapshot) {
        // Builder logic
      },
    );
  }
}
''',
            ),

            const SizedBox(height: 16),

            _buildAdvancedTopic(
              'Error Recovery',
              'Retry mechanism for failed futures',
              '''
Future<T> retryFuture<T>(
  Future<T> Function() operation,
  {int maxRetries = 3}
) async {
  for (int i = 0; i < maxRetries; i++) {
    try {
      return await operation();
    } catch (e) {
      if (i == maxRetries - 1) rethrow;
      await Future.delayed(Duration(seconds: i + 1));
    }
  }
  throw Exception('Max retries exceeded');
}
''',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedTopic(String title, String description, String code) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              code,
              style: const TextStyle(
                color: Colors.green,
                fontFamily: 'monospace',
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBestPractices() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.tips_and_updates,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Best Practices & Performance',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _buildTipItem(
              Icons.check_circle,
              'DO: Cache the Future in initState()',
              'Avoid creating a new Future on every rebuild',
              Colors.green,
            ),

            _buildTipItem(
              Icons.check_circle,
              'DO: Handle all states',
              'waiting, error, success, and none states',
              Colors.green,
            ),

            _buildTipItem(
              Icons.warning,
              'AVOID: Creating a Future in the build method',
              'This creates a new Future on every rebuild',
              Colors.orange,
            ),

            _buildTipItem(
              Icons.error,
              'DON\'T: Ignore error handling',
              'Always check for snapshot.hasError',
              Colors.red,
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.blue.shade700),
                      const SizedBox(width: 8),
                      Text(
                        'Pro Tips',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('• Use FutureBuilder for one-time operations'),
                  const Text('• Use StreamBuilder for continuous data'),
                  const Text('• Implement timeouts for network calls'),
                  const Text(
                    '• Consider using state management for complex apps',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(
    IconData icon,
    String title,
    String description,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, color: color),
                ),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExercises() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.assignment, color: Colors.red),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Practice Exercises',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _buildExerciseItem(
              '📱 Todo App with API',
              'Beginner',
              Colors.green,
              [
                'Fetch todos from the JSONPlaceholder API',
                'Display loading state and handle errors',
                'Implement pull-to-refresh',
                'Add/delete todos with optimistic updates',
              ],
            ),

            const SizedBox(height: 16),

            _buildExerciseItem(
              '🌐 Weather App',
              'Intermediate',
              Colors.orange,
              [
                'Multiple API calls cho current & forecast',
                'Location-based weather data',
                'Caching mechanism cho offline support',
                'Background refresh với periodic updates',
              ],
            ),

            const SizedBox(height: 16),

            _buildExerciseItem('💬 Chat Application', 'Advanced', Colors.red, [
              'Real-time messaging với WebSocket',
              'File upload với progress tracking',
              'Message pagination với infinite scroll',
              'Offline message queue và sync',
            ]),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal.shade50, Colors.teal.shade100],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.teal.shade200),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.school, color: Colors.teal),
                      const SizedBox(width: 8),
                      const Text(
                        'You have finished learning FutureBuilder & Dart Async!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'You have mastered: Future/async/await, ConnectionState handling, '
                    'Error management, Performance optimization, and Real-world patterns!',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Row(
                            children: [
                              Icon(Icons.celebration, color: Colors.white),
                              SizedBox(width: 8),
                              Text('🎉 Async programming mastered!'),
                            ],
                          ),
                          backgroundColor: Colors.teal,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.check_circle),
                    label: const Text('Complete Lesson'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
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

  Widget _buildExerciseItem(
    String title,
    String difficulty,
    Color color,
    List<String> tasks,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: color,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  difficulty,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...tasks.map(
            (task) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• ',
                    style: TextStyle(color: color, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Text(task, style: const TextStyle(fontSize: 14)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<CodeExample> _getFutureBuilderExamples() {
    return [
      const CodeExample(
        title: 'Basic FutureBuilder Pattern',
        code: '''
FutureBuilder<String>(
  future: fetchData(), // Your async function
  builder: (context, snapshot) {
    // Handle different states
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }
    
    if (snapshot.hasError) {
      return Text('Error: \${snapshot.error}');
    }
    
    if (snapshot.hasData) {
      return Text('Data: \${snapshot.data}');
    }
    
    return Text('No data');
  },
)''',
      ),

      const CodeExample(
        title: 'Dart Async Function',
        code: '''
// Async function returning Future
Future<String> fetchUserData(int userId) async {
  try {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 2));
    
    // Simulate API call
    final response = await http.get(
      Uri.parse('https://api.example.com/users/\$userId')
    );
    
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load user');
    }
  } catch (e) {
    throw Exception('Network error: \$e');
  }
}''',
      ),

      const CodeExample(
        title: 'Cached Future Pattern',
        code: '''
class UserProfile extends StatefulWidget {
  final int userId;
  const UserProfile({Key? key, required this.userId}) : super(key: key);
  
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late Future<User> _userFuture;
  
  @override
  void initState() {
    super.initState();
    // Cache future to prevent rebuilds
    _userFuture = fetchUser(widget.userId);
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: _userFuture, // Reuse cached future
      builder: (context, snapshot) {
        return _buildUserUI(snapshot);
      },
    );
  }
}''',
      ),

      const CodeExample(
        title: 'Error Handling & Retry',
        code: '''
class RobustFutureBuilder extends StatefulWidget {
  @override
  _RobustFutureBuilderState createState() => _RobustFutureBuilderState();
}

class _RobustFutureBuilderState extends State<RobustFutureBuilder> {
  late Future<String> _future;
  int _retryCount = 0;
  
  @override
  void initState() {
    super.initState();
    _future = _fetchWithRetry();
  }
  
  Future<String> _fetchWithRetry() async {
    for (int i = 0; i < 3; i++) {
      try {
        return await fetchData();
      } catch (e) {
        if (i == 2) rethrow; // Last attempt
        await Future.delayed(Duration(seconds: i + 1));
      }
    }
    throw Exception('Max retries exceeded');
  }
  
  void _retry() {
    setState(() {
      _retryCount++;
      _future = _fetchWithRetry();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Column(
            children: [
              Text('Error: \${snapshot.error}'),
              ElevatedButton(
                onPressed: _retry,
                child: Text('Retry (\$_retryCount)'),
              ),
            ],
          );
        }
        
        return _buildSuccessUI(snapshot);
      },
    );
  }
}''',
      ),

      const CodeExample(
        title: 'Multiple Futures với Future.wait',
        code: '''
class MultipleFuturesExample extends StatefulWidget {
  @override
  _MultipleFuturesExampleState createState() => _MultipleFuturesExampleState();
}

class _MultipleFuturesExampleState extends State<MultipleFuturesExample> {
  late Future<List<dynamic>> _combinedFuture;
  
  @override
  void initState() {
    super.initState();
    _combinedFuture = _fetchAllData();
  }
  
  Future<List<dynamic>> _fetchAllData() async {
    // Wait for multiple futures to complete
    return await Future.wait([
      fetchUserData(),
      fetchUserPosts(),
      fetchUserFriends(),
    ]);
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _combinedFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading user data, posts, and friends...'),
            ],
          );
        }
        
        if (snapshot.hasError) {
          return Text('Error loading data: \${snapshot.error}');
        }
        
        if (snapshot.hasData) {
          final results = snapshot.data!;
          final userData = results[0];
          final posts = results[1];
          final friends = results[2];
          
          return Column(
            children: [
              UserCard(user: userData),
              PostsList(posts: posts),
              FriendsList(friends: friends),
            ],
          );
        }
        
        return Text('No data available');
      },
    );
  }
}''',
      ),

      const CodeExample(
        title: 'FutureBuilder với Timeout',
        code: '''
class TimeoutFutureBuilder extends StatefulWidget {
  @override
  _TimeoutFutureBuilderState createState() => _TimeoutFutureBuilderState();
}

class _TimeoutFutureBuilderState extends State<TimeoutFutureBuilder> {
  late Future<String> _future;
  
  @override
  void initState() {
    super.initState();
    _future = _fetchWithTimeout();
  }
  
  Future<String> _fetchWithTimeout() async {
    try {
      // Add timeout to prevent hanging
      return await fetchData().timeout(
        Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Request timed out', Duration(seconds: 10));
        },
      );
    } catch (e) {
      rethrow;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading... (timeout in 10s)'),
            ],
          );
        }
        
        if (snapshot.hasError) {
          final error = snapshot.error;
          if (error is TimeoutException) {
            return Column(
              children: [
                Icon(Icons.timer_off, color: Colors.orange, size: 48),
                SizedBox(height: 16),
                Text('Request timed out'),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _future = _fetchWithTimeout();
                    });
                  },
                  child: Text('Retry'),
                ),
              ],
            );
          }
          
          return Text('Error: \$error');
        }
        
        return Text('Success: \${snapshot.data}');
      },
    );
  }
}''',
      ),
    ];
  }
}
