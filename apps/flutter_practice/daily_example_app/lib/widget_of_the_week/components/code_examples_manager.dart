import 'package:flutter/material.dart';

import 'code_viewer.dart';

class CodeExamplesManager {
  static Widget buildCodeExamplesSection({
    required BuildContext context,
    required List<CodeExample> examples,
    String title = '💻 Code Examples',
    String description = 'This section contains code examples:',
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 16),

            Text(description, style: const TextStyle(fontSize: 14)),

            const SizedBox(height: 16),

            // Code examples
            ...examples.map(
              (example) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CodeViewer(title: example.title, code: example.code),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildQuickExample({
    required String title,
    required Widget child,
    required String code,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Visual example
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: child,
        ),

        const SizedBox(height: 8),

        // Code viewer
        CodeViewer(title: title, code: code),
      ],
    );
  }

  static Widget buildInlineCodeButton({
    required String title,
    required String code,
    required BuildContext context,
  }) {
    return IconButton(
      onPressed: () => _showCodeDialog(context, title, code),
      icon: const Icon(Icons.code, size: 20),
      tooltip: 'Xem code: $title',
      padding: const EdgeInsets.all(4),
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
    );
  }

  /// Hiển thị code trong dialog
  static void _showCodeDialog(BuildContext context, String title, String code) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(Icons.code, color: Colors.blue.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),

              const Divider(),

              // Code content
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SingleChildScrollView(
                    child: SelectableText(
                      code,
                      style: const TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 12,
                        color: Colors.white,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      // Copy code logic here
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Model cho Code Example
class CodeExample {
  final String title;
  final String code;
  final String? description;

  const CodeExample({
    required this.title,
    required this.code,
    this.description,
  });
}

class CommonCodeExamples {
  static const List<CodeExample> containerExamples = [
    CodeExample(
      title: 'Container basic',
      code: '''
Container(
  width: 200,
  height: 100,
  color: Colors.blue,
  child: Center(
    child: Text('Hello Container'),
  ),
)''',
    ),
    CodeExample(
      title: 'Styled Container',
      code: '''
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.3),
        blurRadius: 6,
        offset: Offset(0, 2),
      ),
    ],
  ),
  child: Text('Styled Container'),
)''',
    ),
  ];

  static const List<CodeExample> rowColumnExamples = [
    CodeExample(
      title: 'Row with Icons',
      code: '''
Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    Icon(Icons.home),
    Icon(Icons.search),
    Icon(Icons.person),
  ],
)''',
    ),
    CodeExample(
      title: 'Column with Expanded',
      code: '''
Column(
  children: [
    Container(height: 100, color: Colors.red),
    Expanded(
      child: Container(color: Colors.green),
    ),
    Container(height: 100, color: Colors.blue),
  ],
)''',
    ),
  ];
}
