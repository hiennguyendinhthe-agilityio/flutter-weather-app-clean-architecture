import 'dart:io' show Platform;

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class AdvancedAndroidIntentDemoScreen extends StatefulWidget {
  const AdvancedAndroidIntentDemoScreen({super.key});

  @override
  State<AdvancedAndroidIntentDemoScreen> createState() =>
      _AdvancedAndroidIntentDemoScreenState();
}

class _AdvancedAndroidIntentDemoScreenState
    extends State<AdvancedAndroidIntentDemoScreen> {
  final TextEditingController _packageController = TextEditingController();
  final TextEditingController _actionController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  String _result = '';
  final List<String> _selectedFlags = [];
  final Map<String, String> _extras = {};

  final List<String> _commonActions = [
    'android.intent.action.VIEW',
    'android.intent.action.SEND',
    'android.intent.action.SENDTO',
    'android.intent.action.MAIN',
    'android.intent.action.CALL',
    'android.intent.action.DIAL',
    'android.intent.action.PICK',
    'android.intent.action.GET_CONTENT',
    'android.intent.action.INSERT',
    'android.intent.action.EDIT',
    'android.intent.action.DELETE',
    'android.settings.SETTINGS',
    'android.settings.WIFI_SETTINGS',
    'android.settings.BLUETOOTH_SETTINGS',
  ];

  final List<String> _commonFlags = [
    'FLAG_ACTIVITY_NEW_TASK',
    'FLAG_ACTIVITY_CLEAR_TOP',
    'FLAG_ACTIVITY_SINGLE_TOP',
    'FLAG_ACTIVITY_CLEAR_TASK',
    'FLAG_ACTIVITY_NO_HISTORY',
    'FLAG_ACTIVITY_MULTIPLE_TASK',
  ];

  @override
  void initState() {
    super.initState();
    _packageController.text = 'com.android.settings';
    _actionController.text = 'android.intent.action.VIEW';
    _dataController.text = 'https://flutter.dev';
    _typeController.text = 'text/plain';
  }

  void _showResult(String message) {
    setState(() {
      _result = message;
    });
  }

  Future<void> _launchCustomIntent() async {
    if (kIsWeb || !Platform.isAndroid) {
      _showResult('❌ This feature only works on Android');
      return;
    }

    try {
      _showResult('🔄 Creating and launching custom intent...');

      // Convert string flags to Flag enum
      final flags = _selectedFlags.map((flagName) {
        switch (flagName) {
          case 'FLAG_ACTIVITY_NEW_TASK':
            return Flag.FLAG_ACTIVITY_NEW_TASK;
          case 'FLAG_ACTIVITY_CLEAR_TOP':
            return Flag.FLAG_ACTIVITY_CLEAR_TOP;
          case 'FLAG_ACTIVITY_SINGLE_TOP':
            return Flag.FLAG_ACTIVITY_SINGLE_TOP;
          case 'FLAG_ACTIVITY_CLEAR_TASK':
            return Flag.FLAG_ACTIVITY_CLEAR_TASK;
          case 'FLAG_ACTIVITY_NO_HISTORY':
            return Flag.FLAG_ACTIVITY_NO_HISTORY;
          case 'FLAG_ACTIVITY_MULTIPLE_TASK':
            return Flag.FLAG_ACTIVITY_MULTIPLE_TASK;
          default:
            return Flag.FLAG_ACTIVITY_NEW_TASK;
        }
      }).toList();

      final intent = AndroidIntent(
        action: _actionController.text.isNotEmpty
            ? _actionController.text
            : null,
        data: _dataController.text.isNotEmpty ? _dataController.text : null,
        type: _typeController.text.isNotEmpty ? _typeController.text : null,
        package: _packageController.text.isNotEmpty
            ? _packageController.text
            : null,
        category: _categoryController.text.isNotEmpty
            ? _categoryController.text
            : null,
        flags: flags.isNotEmpty ? flags : null,
        arguments: _extras.isNotEmpty ? _extras : null,
      );

      await intent.launch();
      _showResult('✅ Custom intent launched successfully!');
    } catch (e) {
      _showResult('❌ Error launching intent: $e');
    }
  }

  Future<void> _launchPresetIntent(String name, AndroidIntent intent) async {
    if (kIsWeb || !Platform.isAndroid) {
      _showResult('❌ This feature only works on Android');
      return;
    }

    try {
      _showResult('🔄 Launching: $name...');
      await intent.launch();
      _showResult('✅ Launched: $name');
    } catch (e) {
      _showResult('❌ Error launching $name: $e');
    }
  }

  void _addExtra() {
    showDialog(
      context: context,
      builder: (context) {
        final keyController = TextEditingController();
        final valueController = TextEditingController();

        return AlertDialog(
          title: const Text('Add Extra'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: keyController,
                decoration: const InputDecoration(
                  labelText: 'Key',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: valueController,
                decoration: const InputDecoration(
                  labelText: 'Value',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (keyController.text.isNotEmpty &&
                    valueController.text.isNotEmpty) {
                  setState(() {
                    _extras[keyController.text] = valueController.text;
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Android Intent'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: (!kIsWeb && Platform.isAndroid)
          ? _buildAndroidContent()
          : _buildNonAndroidContent(),
    );
  }

  Widget _buildNonAndroidContent() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.android, size: 100, color: Colors.grey),
          SizedBox(height: 20),
          Text(
            'Advanced Android Intent Demo',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'This feature only works on Android',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAndroidContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Custom Intent Builder
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🛠️ Custom Intent Builder',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Action
                  DropdownButtonFormField<String>(
                    value: _actionController.text.isNotEmpty
                        ? _actionController.text
                        : null,
                    decoration: const InputDecoration(
                      labelText: 'Action',
                      border: OutlineInputBorder(),
                    ),
                    items: _commonActions.map((action) {
                      return DropdownMenuItem(
                        value: action,
                        child: Text(
                          action,
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        _actionController.text = value;
                      }
                    },
                  ),
                  const SizedBox(height: 12),

                  // Package
                  TextField(
                    controller: _packageController,
                    decoration: const InputDecoration(
                      labelText: 'Package (optional)',
                      border: OutlineInputBorder(),
                      hintText: 'com.example.app',
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Data
                  TextField(
                    controller: _dataController,
                    decoration: const InputDecoration(
                      labelText: 'Data (optional)',
                      border: OutlineInputBorder(),
                      hintText: 'https://example.com',
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Type
                  TextField(
                    controller: _typeController,
                    decoration: const InputDecoration(
                      labelText: 'Type (optional)',
                      border: OutlineInputBorder(),
                      hintText: 'text/plain',
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Category
                  TextField(
                    controller: _categoryController,
                    decoration: const InputDecoration(
                      labelText: 'Category (optional)',
                      border: OutlineInputBorder(),
                      hintText: 'android.intent.category.DEFAULT',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Flags
                  const Text(
                    'Flags:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _commonFlags.map((flag) {
                      final isSelected = _selectedFlags.contains(flag);
                      return FilterChip(
                        label: Text(
                          flag.replaceAll('FLAG_ACTIVITY_', ''),
                          style: const TextStyle(fontSize: 10),
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedFlags.add(flag);
                            } else {
                              _selectedFlags.remove(flag);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Extras
                  Row(
                    children: [
                      const Text(
                        'Extras:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: _addExtra,
                        icon: const Icon(Icons.add, semanticLabel: 'Add Extra'),
                        tooltip: 'Add Extra',
                      ),
                    ],
                  ),
                  if (_extras.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: _extras.entries.map((entry) {
                          return Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${entry.key}: ${entry.value}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _extras.remove(entry.key);
                                  });
                                },
                                icon: const Icon(Icons.delete, size: 16),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),

                  // Launch Button
                  ElevatedButton.icon(
                    onPressed: _launchCustomIntent,
                    icon: const Icon(Icons.launch),
                    label: const Text('Launch Custom Intent'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Preset Advanced Intents
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🚀 Advanced Intent Examples',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // System UI Tuner
                  _buildPresetButton(
                    'System UI Tuner',
                    Icons.tune,
                    Colors.purple,
                    const AndroidIntent(
                      action: 'com.android.settings.action.SYSTEM_UI_TUNER',
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Developer Options
                  _buildPresetButton(
                    'Developer Options',
                    Icons.developer_mode,
                    Colors.orange,
                    const AndroidIntent(
                      action:
                          'android.settings.APPLICATION_DEVELOPMENT_SETTINGS',
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Accessibility Settings
                  _buildPresetButton(
                    'Accessibility Settings',
                    Icons.accessibility,
                    Colors.blue,
                    const AndroidIntent(
                      action: 'android.settings.ACCESSIBILITY_SETTINGS',
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Security Settings
                  _buildPresetButton(
                    'Security Settings',
                    Icons.security,
                    Colors.red,
                    const AndroidIntent(
                      action: 'android.settings.SECURITY_SETTINGS',
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Privacy Settings
                  _buildPresetButton(
                    'Privacy Settings',
                    Icons.privacy_tip,
                    Colors.green,
                    const AndroidIntent(
                      action: 'android.settings.PRIVACY_SETTINGS',
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Battery Optimization
                  _buildPresetButton(
                    'Battery Optimization',
                    Icons.battery_saver,
                    Colors.amber,
                    const AndroidIntent(
                      action:
                          'android.settings.IGNORE_BATTERY_OPTIMIZATION_SETTINGS',
                    ),
                  ),
                  const SizedBox(height: 8),

                  // App Notification Settings
                  _buildPresetButton(
                    'App Notification Settings',
                    Icons.notifications,
                    Colors.indigo,
                    const AndroidIntent(
                      action: 'android.settings.APP_NOTIFICATION_SETTINGS',
                      arguments: {
                        'android.provider.extra.APP_PACKAGE':
                            'com.example.flutter_auth_demo',
                      },
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Storage Settings
                  _buildPresetButton(
                    'Storage Settings',
                    Icons.storage,
                    Colors.teal,
                    const AndroidIntent(
                      action: 'android.settings.INTERNAL_STORAGE_SETTINGS',
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Display Settings
                  _buildPresetButton(
                    'Display Settings',
                    Icons.display_settings,
                    Colors.cyan,
                    const AndroidIntent(
                      action: 'android.settings.DISPLAY_SETTINGS',
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Sound Settings
                  _buildPresetButton(
                    'Sound Settings',
                    Icons.volume_up,
                    Colors.pink,
                    const AndroidIntent(
                      action: 'android.settings.SOUND_SETTINGS',
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Advanced App Intents
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '📱 Advanced App Intents',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Open specific app with flags
                  _buildPresetButton(
                    'Open Calculator (New Task)',
                    Icons.calculate,
                    Colors.blue,
                    const AndroidIntent(
                      action: 'android.intent.action.MAIN',
                      package: 'com.google.android.calculator',
                      flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Share with specific app
                  _buildPresetButton(
                    'Share to WhatsApp',
                    Icons.share,
                    Colors.green,
                    const AndroidIntent(
                      action: 'android.intent.action.SEND',
                      package: 'com.whatsapp',
                      type: 'text/plain',
                      arguments: {
                        'android.intent.extra.TEXT': 'Hello from Flutter! 🚀',
                      },
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Open specific contact
                  _buildPresetButton(
                    'View Contact',
                    Icons.person,
                    Colors.purple,
                    const AndroidIntent(
                      action: 'android.intent.action.VIEW',
                      data: 'content://contacts/people/1',
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Create note
                  _buildPresetButton(
                    'Create Note',
                    Icons.note_add,
                    Colors.orange,
                    const AndroidIntent(
                      action: 'android.intent.action.INSERT',
                      type: 'vnd.android.cursor.dir/vnd.google.note',
                      arguments: {
                        'title': 'Flutter Note',
                        'description': 'Created from Flutter app',
                      },
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Open specific YouTube video
                  _buildPresetButton(
                    'Flutter YouTube Channel',
                    Icons.play_circle,
                    Colors.red,
                    const AndroidIntent(
                      action: 'android.intent.action.VIEW',
                      data: 'https://www.youtube.com/c/flutterdev',
                      package: 'com.google.android.youtube',
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Result Display
          if (_result.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Text(_result, style: const TextStyle(fontSize: 14)),
            ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildPresetButton(
    String text,
    IconData icon,
    Color color,
    AndroidIntent intent,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _launchPresetIntent(text, intent),
        icon: Icon(icon),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _packageController.dispose();
    _actionController.dispose();
    _dataController.dispose();
    _typeController.dispose();
    _categoryController.dispose();
    super.dispose();
  }
}
