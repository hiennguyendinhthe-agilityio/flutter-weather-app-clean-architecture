import 'package:flutter/material.dart';
import 'package:flutter_auth_demo/core/di/injection.dart';

import '../services/secure_storage_service.dart';

class SecureStorageDemoScreen extends StatefulWidget {
  const SecureStorageDemoScreen({super.key});

  @override
  State<SecureStorageDemoScreen> createState() =>
      _SecureStorageDemoScreenState();
}

class _SecureStorageDemoScreenState extends State<SecureStorageDemoScreen> {
  final SecureStorageService _secureStorage = getIt<SecureStorageService>();
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();

  String _result = '';
  Map<String, String> _allData = {};

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    final data = await _secureStorage.getAllData();
    setState(() {
      _allData = data;
    });
  }

  Future<void> _saveData() async {
    if (_keyController.text.isEmpty || _valueController.text.isEmpty) {
      _showResult('Please enter both a key and a value');
      return;
    }

    try {
      await _secureStorage.saveCustomData(
        _keyController.text,
        _valueController.text,
      );
      _showResult('✅ Saved successfully!');
      _loadAllData();
      _keyController.clear();
      _valueController.clear();
    } catch (e) {
      _showResult('❌ Error: $e');
    }
  }

  Future<void> _readData() async {
    if (_keyController.text.isEmpty) {
      _showResult('Please enter a key');
      return;
    }

    try {
      final value = await _secureStorage.getCustomData(_keyController.text);
      if (value != null) {
        _showResult('📖 Value: $value');
      } else {
        _showResult('❌ Key not found');
      }
    } catch (e) {
      _showResult('❌ Error: $e');
    }
  }

  Future<void> _deleteData() async {
    if (_keyController.text.isEmpty) {
      _showResult('Please enter a key');
      return;
    }

    try {
      await _secureStorage.deleteKey(_keyController.text);
      _showResult('🗑️ Key deleted successfully!');
      _loadAllData();
      _keyController.clear();
    } catch (e) {
      _showResult('❌ Error: $e');
    }
  }

  Future<void> _clearAll() async {
    try {
      await _secureStorage.clearAll();
      _showResult('🧹 All data cleared!');
      _loadAllData();
    } catch (e) {
      _showResult('❌ Error: $e');
    }
  }

  Future<void> _testTokenOperations() async {
    try {
      // Test lưu tokens
      await _secureStorage.saveAccessToken('sample_access_token_123');
      await _secureStorage.saveRefreshToken('sample_refresh_token_456');
      await _secureStorage.saveUserId('user_789');

      // Test đọc tokens
      final accessToken = await _secureStorage.getAccessToken();
      final refreshToken = await _secureStorage.getRefreshToken();
      final userId = await _secureStorage.getUserId();

      _showResult(
        '🔐 Tokens saved:\n'
        'Access: $accessToken\n'
        'Refresh: $refreshToken\n'
        'User ID: $userId',
      );

      _loadAllData();
    } catch (e) {
      _showResult('❌ Error: $e');
    }
  }

  void _showResult(String message) {
    setState(() {
      _result = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Secure Storage Demo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input fields
            TextField(
              controller: _keyController,
              decoration: const InputDecoration(
                labelText: 'Key',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.key),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _valueController,
              decoration: const InputDecoration(
                labelText: 'Value',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.text_fields),
              ),
            ),
            const SizedBox(height: 20),

            // Action buttons
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: _saveData,
                  icon: const Icon(Icons.save),
                  label: const Text('Save'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _readData,
                  icon: const Icon(Icons.read_more),
                  label: const Text('Read'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
                ElevatedButton.icon(
                  onPressed: _deleteData,
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _clearAll,
                  icon: const Icon(Icons.clear_all),
                  label: const Text('Clear All'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),

            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _testTokenOperations,
              icon: const Icon(Icons.security),
              label: const Text('Test Auth Tokens'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            ),

            const SizedBox(height: 20),

            // Result display
            if (_result.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Text(_result, style: const TextStyle(fontSize: 14)),
              ),

            const SizedBox(height: 20),

            // All stored data
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.storage, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          'Stored Data (${_allData.length} items)',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: _loadAllData,
                          icon: const Icon(Icons.refresh),
                          tooltip: 'Refresh',
                        ),
                      ],
                    ),
                    const Divider(),
                    Expanded(
                      child: _allData.isEmpty
                          ? const Center(
                              child: Text(
                                'No data has been saved yet',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: _allData.length,
                              itemBuilder: (context, index) {
                                final entry = _allData.entries.elementAt(index);
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: ListTile(
                                    leading: const Icon(
                                      Icons.key,
                                      color: Colors.blue,
                                    ),
                                    title: Text(
                                      entry.key,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      entry.value.length > 50
                                          ? '${entry.value.substring(0, 50)}...'
                                          : entry.value,
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.copy, size: 20),
                                      onPressed: () {
                                        _keyController.text = entry.key;
                                        _showResult(
                                          '📋 Copied key: ${entry.key}',
                                        );
                                      },
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
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _keyController.dispose();
    _valueController.dispose();
    super.dispose();
  }
}
