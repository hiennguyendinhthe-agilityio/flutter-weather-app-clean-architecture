import 'package:flutter/material.dart';

import 'code_examples_manager.dart';

/// Floating Action Button để hiển thị code examples
class FloatingCodeButton extends StatelessWidget {
  final List<CodeExample> examples;
  final String lessonTitle;

  const FloatingCodeButton({
    super.key,
    required this.examples,
    required this.lessonTitle,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _showCodeExamplesBottomSheet(context),
      icon: const Icon(Icons.code),
      label: const Text('Code'),
      backgroundColor: Colors.purple,
      foregroundColor: Colors.white,
    );
  }

  void _showCodeExamplesBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Icon(Icons.code, color: Colors.purple.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Code Examples - $lessonTitle',
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
              ),

              const Divider(),

              // Content
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  itemCount: examples.length,
                  itemBuilder: (context, index) {
                    final example = examples[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Card(
                        elevation: 2,
                        child: ExpansionTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.purple.shade100,
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: Colors.purple.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            example.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: example.description != null
                              ? Text(example.description!)
                              : null,
                          children: [
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.all(16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade900,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Dart Code',
                                        style: TextStyle(
                                          color: Colors.grey.shade300,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          // Copy code logic
                                        },
                                        icon: const Icon(
                                          Icons.copy,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                        tooltip: 'Copy code',
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  SelectableText(
                                    example.code,
                                    style: const TextStyle(
                                      fontFamily: 'Courier',
                                      fontSize: 12,
                                      color: Colors.white,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Mini floating button chỉ hiển thị icon
class MiniFloatingCodeButton extends StatelessWidget {
  final List<CodeExample> examples;
  final String lessonTitle;

  const MiniFloatingCodeButton({
    super.key,
    required this.examples,
    required this.lessonTitle,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      onPressed: () => _showQuickCodeDialog(context),
      backgroundColor: Colors.purple,
      foregroundColor: Colors.white,
      child: const Icon(Icons.code, size: 20),
    );
  }

  void _showQuickCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.code, color: Colors.purple.shade700),
            const SizedBox(width: 8),
            const Expanded(child: Text('Code Examples')),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            itemCount: examples.length,
            itemBuilder: (context, index) {
              final example = examples[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.purple.shade100,
                    child: Text('${index + 1}'),
                  ),
                  title: Text(example.title),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.of(context).pop();
                    _showCodeDialog(context, example.title, example.code);
                  },
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showCodeDialog(BuildContext context, String title, String code) {
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
