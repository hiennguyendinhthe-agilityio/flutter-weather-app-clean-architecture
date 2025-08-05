import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_auth_demo/core/di/injection.dart';

import '../services/android_intent_service.dart';

class AndroidIntentDemoScreen extends StatefulWidget {
  const AndroidIntentDemoScreen({super.key});

  @override
  State<AndroidIntentDemoScreen> createState() =>
      _AndroidIntentDemoScreenState();
}

class _AndroidIntentDemoScreenState extends State<AndroidIntentDemoScreen> {
  final AndroidIntentService _intentService = getIt<AndroidIntentService>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  String _result = '';

  @override
  void initState() {
    super.initState();
    // Set default values
    _phoneController.text = '+84123456789';
    _messageController.text = 'Hello from Flutter!';
    _emailController.text = 'test@example.com';
    _urlController.text = 'https://flutter.dev';
    _addressController.text = 'Ho Chi Minh City, Vietnam';
    _searchController.text = 'Flutter development';
  }

  void _showResult(String message) {
    setState(() {
      _result = message;
    });
  }

  Future<void> _executeIntent(
    String intentName,
    Future<void> Function() intentFunction,
  ) async {
    if (kIsWeb || !Platform.isAndroid) {
      _showResult('❌ This feature only works on Android');
      return;
    }

    try {
      _showResult('🔄 Executing: $intentName...');
      await intentFunction();
      _showResult('✅ Executed: $intentName');
    } catch (e) {
      _showResult('❌ Error executing $intentName: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Android Intent Demo'),
        backgroundColor: Colors.green,
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
            'Android Intent Demo',
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
          // Platform Info
          Card(
            color: Colors.green[50],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.android, color: Colors.green, size: 30),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '🤖 Android Intent Plus Demo',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Platform: ${Platform.operatingSystem}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // System Settings Section
          _buildSectionCard(
            title: '⚙️ System Settings',
            children: [
              _buildIntentButton(
                'Open Settings',
                Icons.settings,
                Colors.blue,
                () => _intentService.openSettings(),
              ),
              _buildIntentButton(
                'WiFi Settings',
                Icons.wifi,
                Colors.blue,
                () => _intentService.openWifiSettings(),
              ),
              _buildIntentButton(
                'Bluetooth Settings',
                Icons.bluetooth,
                Colors.blue,
                () => _intentService.openBluetoothSettings(),
              ),
              _buildIntentButton(
                'Location Settings',
                Icons.location_on,
                Colors.blue,
                () => _intentService.openLocationSettings(),
              ),
              _buildIntentButton(
                'App Settings',
                Icons.app_settings_alt,
                Colors.blue,
                () => _intentService.openAppSettings(),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Communication Section
          _buildSectionCard(
            title: '📞 Communication',
            children: [
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildIntentButton(
                      'Make Call',
                      Icons.call,
                      Colors.green,
                      () => _intentService.makePhoneCall(_phoneController.text),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildIntentButton(
                      'Open Dialer',
                      Icons.dialpad,
                      Colors.orange,
                      () => _intentService.openDialer(_phoneController.text),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  labelText: 'SMS Message',
                  prefixIcon: Icon(Icons.message),
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              _buildIntentButton(
                'Send SMS',
                Icons.sms,
                Colors.purple,
                () => _intentService.sendSMS(
                  _phoneController.text,
                  _messageController.text,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Email Section
          _buildSectionCard(
            title: '📧 Email',
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email address',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              _buildIntentButton(
                'Send Email',
                Icons.mail_outline,
                Colors.red,
                () => _intentService.sendEmail(
                  to: _emailController.text,
                  subject: 'Hello from Flutter',
                  body:
                      'This email was sent from Flutter app using Android Intent!',
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Web & Navigation Section
          _buildSectionCard(
            title: '🌐 Web & Navigation',
            children: [
              TextField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'URL',
                  prefixIcon: Icon(Icons.link),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 12),
              _buildIntentButton(
                'Open URL',
                Icons.open_in_browser,
                Colors.indigo,
                () => _intentService.openUrl(_urlController.text),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildIntentButton(
                      'Open Maps',
                      Icons.map,
                      Colors.green,
                      () => _intentService.openMaps(_addressController.text),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildIntentButton(
                      'Maps (Coordinates)',
                      Icons.my_location,
                      Colors.teal,
                      () => _intentService.openMapsWithCoordinates(
                        10.8231,
                        106.6297,
                      ), // HCM City
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Media Section
          _buildSectionCard(
            title: '📸 Media & Files',
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildIntentButton(
                      'Open Camera',
                      Icons.camera_alt,
                      Colors.purple,
                      () => _intentService.openCamera(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildIntentButton(
                      'Open Gallery',
                      Icons.photo_library,
                      Colors.pink,
                      () => _intentService.openGallery(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildIntentButton(
                      'File Manager',
                      Icons.folder,
                      Colors.brown,
                      () => _intentService.openFileManager(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildIntentButton(
                      'Voice Recorder',
                      Icons.mic,
                      Colors.red,
                      () => _intentService.openVoiceRecorder(),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Share Section
          _buildSectionCard(
            title: '🔗 Share & Search',
            children: [
              _buildIntentButton(
                'Share Text',
                Icons.share,
                Colors.blue,
                () => _intentService.shareText('Hello from Flutter App! 🚀'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Từ khóa tìm kiếm',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              _buildIntentButton(
                'Tìm kiếm Google',
                Icons.search,
                Colors.red,
                () => _intentService.searchGoogle(_searchController.text),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Apps Section
          _buildSectionCard(
            title: '📱 Apps & Store',
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildIntentButton(
                      'YouTube',
                      Icons.play_circle,
                      Colors.red,
                      () => _intentService.openYouTube(
                        'dQw4w9WgXcQ',
                      ), // Rick Roll 😄
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildIntentButton(
                      'Play Store',
                      Icons.store,
                      Colors.green,
                      () => _intentService.openPlayStore(
                        'com.google.android.apps.maps',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildIntentButton(
                'Music Player',
                Icons.music_note,
                Colors.purple,
                () => _intentService.openMusicPlayer(),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Time & Calendar Section
          _buildSectionCard(
            title: '⏰ Time & Calendar',
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildIntentButton(
                      'Set Alarm (9:00)',
                      Icons.alarm,
                      Colors.orange,
                      () => _intentService.setAlarm(9, 0, 'Flutter Demo Alarm'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildIntentButton(
                      'Set Timer (60s)',
                      Icons.timer,
                      Colors.blue,
                      () => _intentService.setTimer(60, 'Flutter Timer'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildIntentButton(
                'Tạo Calendar Event',
                Icons.event,
                Colors.green,
                () => _intentService.createCalendarEvent(
                  title: 'Flutter Meeting',
                  startTime: DateTime.now().add(const Duration(hours: 1)),
                  endTime: DateTime.now().add(const Duration(hours: 2)),
                  description: 'Meeting about Flutter development',
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Contacts Section
          _buildSectionCard(
            title: '👥 Contacts',
            children: [
              _buildIntentButton(
                'Pick Contact',
                Icons.contacts,
                Colors.indigo,
                () => _intentService.pickContact(),
              ),
            ],
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

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildIntentButton(
    String text,
    IconData icon,
    Color color,
    Future<void> Function() onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _executeIntent(text, onPressed),
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
    _phoneController.dispose();
    _messageController.dispose();
    _emailController.dispose();
    _urlController.dispose();
    _addressController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
