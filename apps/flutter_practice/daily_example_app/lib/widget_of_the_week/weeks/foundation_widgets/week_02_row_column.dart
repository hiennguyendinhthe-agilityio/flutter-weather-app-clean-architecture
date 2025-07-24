import 'package:flutter/material.dart';
import '../../components/code_viewer.dart';
import '../../components/code_examples.dart';
import '../../components/code_examples_manager.dart';

class Week02RowColumn extends StatefulWidget {
  const Week02RowColumn({super.key});

  @override
  State<Week02RowColumn> createState() => _Week02RowColumnState();
}

class _Week02RowColumnState extends State<Week02RowColumn> {
  MainAxisAlignment _mainAxisAlignment = MainAxisAlignment.start;
  CrossAxisAlignment _crossAxisAlignment = CrossAxisAlignment.start;
  bool _isRow = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Week 02: Row & Column'),
        backgroundColor: Colors.green,
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
            const SizedBox(height: 24),
            
            // Code Examples Section
            CodeExamplesManager.buildCodeExamplesSection(
              context: context,
              examples: CommonCodeExamples.rowColumnExamples,
            ),
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
              '📚 Theory: Row & Column',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Row and Column are the two most basic layout widgets in Flutter:\n'
              '• Row: Arranges widgets horizontally\n'
              '• Column: Arranges widgets vertically',
            ),
            const SizedBox(height: 12),
            const Text(
              '🔑 Important properties:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('• mainAxisAlignment: Alignment along main axis'),
            const Text('• crossAxisAlignment: Alignment along cross axis'),
            const Text('• children: List of child widgets'),
            const Text('• mainAxisSize: Size along main axis'),
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
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),

            // Controls
            Row(
              children: [
                const Text('Layout: '),
                Switch(
                  value: _isRow,
                  onChanged: (value) => setState(() => _isRow = value),
                ),
                Text(_isRow ? 'Row' : 'Column'),
              ],
            ),

            const SizedBox(height: 12),

            const Text('MainAxisAlignment:'),
            DropdownButton<MainAxisAlignment>(
              value: _mainAxisAlignment,
              isExpanded: true,
              items: const [
                DropdownMenuItem(
                  value: MainAxisAlignment.start,
                  child: Text('start'),
                ),
                DropdownMenuItem(
                  value: MainAxisAlignment.center,
                  child: Text('center'),
                ),
                DropdownMenuItem(
                  value: MainAxisAlignment.end,
                  child: Text('end'),
                ),
                DropdownMenuItem(
                  value: MainAxisAlignment.spaceBetween,
                  child: Text('spaceBetween'),
                ),
                DropdownMenuItem(
                  value: MainAxisAlignment.spaceAround,
                  child: Text('spaceAround'),
                ),
                DropdownMenuItem(
                  value: MainAxisAlignment.spaceEvenly,
                  child: Text('spaceEvenly'),
                ),
              ],
              onChanged: (value) => setState(() => _mainAxisAlignment = value!),
            ),

            const SizedBox(height: 12),

            const Text('CrossAxisAlignment:'),
            DropdownButton<CrossAxisAlignment>(
              value: _crossAxisAlignment,
              isExpanded: true,
              items: const [
                DropdownMenuItem(
                  value: CrossAxisAlignment.start,
                  child: Text('start'),
                ),
                DropdownMenuItem(
                  value: CrossAxisAlignment.center,
                  child: Text('center'),
                ),
                DropdownMenuItem(
                  value: CrossAxisAlignment.end,
                  child: Text('end'),
                ),
                DropdownMenuItem(
                  value: CrossAxisAlignment.stretch,
                  child: Text('stretch'),
                ),
              ],
              onChanged: (value) =>
                  setState(() => _crossAxisAlignment = value!),
            ),

            const SizedBox(height: 20),

            // Demo container
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _isRow
                  ? Row(
                      mainAxisAlignment: _mainAxisAlignment,
                      crossAxisAlignment: _crossAxisAlignment,
                      children: _buildDemoChildren(),
                    )
                  : Column(
                      mainAxisAlignment: _mainAxisAlignment,
                      crossAxisAlignment: _crossAxisAlignment,
                      children: _buildDemoChildren(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDemoChildren() {
    return [
      Container(
        width: 60,
        height: 60,
        color: Colors.red,
        child: const Center(
          child: Text('1', style: TextStyle(color: Colors.white)),
        ),
      ),
      Container(
        width: 60,
        height: 80,
        color: Colors.green,
        child: const Center(
          child: Text('2', style: TextStyle(color: Colors.white)),
        ),
      ),
      Container(
        width: 60,
        height: 40,
        color: Colors.blue,
        child: const Center(
          child: Text('3', style: TextStyle(color: Colors.white)),
        ),
      ),
    ];
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

            // Profile card example with code
            QuickCodeExample(
              title: 'Profile Card với Row',
              code: CodeExamples.profileCard,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.person, color: Colors.white, size: 30),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'John Doe',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('Flutter Developer'),
                          Text('New York, USA'),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.more_vert),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Button row example
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () {}, child: const Text('Cancel')),
                ElevatedButton(onPressed: () {}, child: const Text('Save')),
                ElevatedButton(onPressed: () {}, child: const Text('Send')),
              ],
            ),
          ],
        ),
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
              '1. Create a profile card with Row:\n'
              '   • Avatar on the left\n'
              '   • Information in the middle\n'
              '   • Menu button on the right\n\n'
              '2. Create a login form with Column:\n'
              '   • Logo at the top\n'
              '   • Username TextField\n'
              '   • Password TextField\n'
              '   • Login button\n\n'
              '3. Experiment with different alignments',
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Great! You completed the Row & Column lesson!',
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
