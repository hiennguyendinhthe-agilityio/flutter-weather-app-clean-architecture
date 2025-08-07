import 'dart:convert';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';

/// A demonstration screen showing how to use the encrypt package
/// to securely encrypt and decrypt sensitive data like passwords.
///
/// This example shows:
/// - How to create encryption keys and initialization vectors (IV)
/// - How to encrypt sensitive data before storage
/// - How to decrypt data when needed
/// - Best practices for handling encrypted data
class EncryptionDemoScreen extends StatefulWidget {
  const EncryptionDemoScreen({super.key});

  @override
  State<EncryptionDemoScreen> createState() => _EncryptionDemoScreenState();
}

class _EncryptionDemoScreenState extends State<EncryptionDemoScreen> {
  // Text controller for password input
  final TextEditingController _passwordController = TextEditingController();

  // Variables to store encryption states
  String _originalPassword = '';
  String _encryptedPassword = '';
  String _decryptedPassword = '';

  // Encryption components
  late final encrypt.Encrypter _encrypter;
  encrypt.IV? _iv;

  // IMPORTANT: In production, NEVER hardcode keys like this!
  // Keys should be:
  // - Generated securely and randomly
  // - Stored in secure storage (like Android Keystore/iOS Keychain)
  // - Rotated periodically
  // - Never committed to version control
  static const String _hardcodedKey =
      'my32lengthsupersecretnooneknows1'; // 32 chars for AES-256

  @override
  void initState() {
    super.initState();
    _initializeEncryption();
  }

  /// Initialize the encryption components
  ///
  /// Key: A secret key used for encryption/decryption (must be kept secure)
  /// IV: Initialization Vector - adds randomness to encryption, can be public
  /// Algorithm: AES (Advanced Encryption Standard) - industry standard
  void _initializeEncryption() {
    // Create a key from our hardcoded string
    // In production, use encrypt.Key.fromSecureRandom(32) to generate random keys
    final key = encrypt.Key.fromBase64(base64.encode(_hardcodedKey.codeUnits));

    // Create a random IV (Initialization Vector)
    // IV should be random for each encryption operation
    // It's safe to store IV alongside encrypted data
    _iv = encrypt.IV.fromSecureRandom(16); // 16 bytes for AES

    // Initialize the encrypter with AES algorithm
    _encrypter = encrypt.Encrypter(encrypt.AES(key));
  }

  /// Encrypts the password from the text field
  ///
  /// Process:
  /// 1. Get the plain text password
  /// 2. Use the encrypter to encrypt it with our key and IV
  /// 3. Convert to base64 string for storage/display
  void _encryptPassword() {
    if (_passwordController.text.isEmpty) {
      _showSnackBar('Please enter a password to encrypt');
      return;
    }

    setState(() {
      // Store the original password for comparison
      _originalPassword = _passwordController.text;

      // Encrypt the password
      // The encrypt() method returns an Encrypted object
      final encrypted = _encrypter.encrypt(_originalPassword, iv: _iv!);

      // Convert to base64 string for storage
      // In real apps, you'd save this to secure storage
      _encryptedPassword = encrypted.base64;

      // Clear other states
      _decryptedPassword = '';
    });

    _showSnackBar('Password encrypted successfully!');
  }

  /// Decrypts the stored encrypted password
  ///
  /// Process:
  /// 1. Take the base64 encrypted string
  /// 2. Convert it back to Encrypted object
  /// 3. Use the same key and IV to decrypt
  /// 4. Get back the original plain text
  void _decryptPassword() {
    if (_encryptedPassword.isEmpty) {
      _showSnackBar('No encrypted password to decrypt. Encrypt one first!');
      return;
    }

    setState(() {
      // Create Encrypted object from base64 string
      final encrypted = encrypt.Encrypted.fromBase64(_encryptedPassword);

      // Decrypt using the same key and IV that were used for encryption
      _decryptedPassword = _encrypter.decrypt(encrypted, iv: _iv!);
    });

    _showSnackBar('Password decrypted successfully!');
  }

  /// Clear all data and reset the demo
  void _clearAll() {
    setState(() {
      _passwordController.clear();
      _originalPassword = '';
      _encryptedPassword = '';
      _decryptedPassword = '';
    });

    // Generate a new IV for the next encryption
    _iv = encrypt.IV.fromSecureRandom(16);

    _showSnackBar('Demo reset with new IV');
  }

  /// Show a snackbar message
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Encryption Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Information Card
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Encryption Demo',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This demo shows how to use AES encryption to protect sensitive data. '
                      'Enter a password, encrypt it, then decrypt it to see the process.',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Password Input Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Step 1: Enter Password',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password to encrypt',
                        hintText: 'Enter any password...',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      obscureText: false, // Visible for demo purposes
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _encryptPassword,
                    icon: const Icon(Icons.security),
                    label: const Text('Save Securely'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _decryptPassword,
                    icon: const Icon(Icons.lock_open),
                    label: const Text('Load & Decrypt'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Clear button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _clearAll,
                icon: const Icon(Icons.clear_all),
                label: const Text('Clear All & Reset'),
              ),
            ),

            const SizedBox(height: 24),

            // Results Display
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Encryption Results',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Original Password
                    _buildResultRow(
                      'Original Password:',
                      _originalPassword.isEmpty ? 'Not set' : _originalPassword,
                      Colors.grey.shade700,
                      Icons.text_fields,
                    ),

                    const SizedBox(height: 12),

                    // Encrypted Password
                    _buildResultRow(
                      'Encrypted (Base64):',
                      _encryptedPassword.isEmpty
                          ? 'Not encrypted yet'
                          : _encryptedPassword,
                      Colors.red.shade700,
                      Icons.enhanced_encryption,
                    ),

                    const SizedBox(height: 12),

                    // Decrypted Password
                    _buildResultRow(
                      'Decrypted Password:',
                      _decryptedPassword.isEmpty
                          ? 'Not decrypted yet'
                          : _decryptedPassword,
                      Colors.green.shade700,
                      Icons.lock_open,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Technical Details Card
            Card(
              color: Colors.orange.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Technical Details',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '• Algorithm: AES-256 (Advanced Encryption Standard)\n'
                      '• Key: 32-byte secret key (hardcoded for demo)\n'
                      '• IV: 16-byte random initialization vector\n'
                      '• Output: Base64 encoded encrypted string\n'
                      '• Security: IV adds randomness, same input = different output',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Security Warning Card
            Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning, color: Colors.red.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'Production Security Notes',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade700,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '• Never hardcode encryption keys in production code\n'
                      '• Use secure key generation: Key.fromSecureRandom(32)\n'
                      '• Store keys in secure storage (Keychain/Keystore)\n'
                      '• Generate new IV for each encryption operation\n'
                      '• Consider key rotation and secure key management',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.red.shade700,
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

  /// Helper method to build result display rows
  Widget _buildResultRow(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  value,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
