import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../core/di/injection.dart';
import '../services/ios_integration_service.dart';

class IOSIntegrationDemoScreen extends StatefulWidget {
  const IOSIntegrationDemoScreen({super.key});

  @override
  State<IOSIntegrationDemoScreen> createState() =>
      _IOSIntegrationDemoScreenState();
}

class _IOSIntegrationDemoScreenState extends State<IOSIntegrationDemoScreen> {
  final IOSIntegrationService _iosService = getIt<IOSIntegrationService>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _appIdController = TextEditingController();

  String _result = '';

  @override
  void initState() {
    super.initState();
    // Set default values
    _phoneController.text = '+84123456789';
    _messageController.text = 'Hello from Flutter iOS!';
    _emailController.text = 'test@example.com';
    _urlController.text = 'https://flutter.dev';
    _addressController.text = 'Ho Chi Minh City, Vietnam';
    _appIdController.text = '544007664'; // YouTube app ID
  }

  void _showResult(String message) {
    setState(() {
      _result = message;
    });
  }

  Future<void> _executeOperation(
    String operationName,
    Future<void> Function() operation,
  ) async {
    if (!(!kIsWeb && Platform.isIOS)) {
      _showResult('❌ This feature only works on iOS');
      return;
    }

    try {
      _showResult('🔄 Executing: $operationName...');
      await operation();
      _showResult('✅ Executed: $operationName');
    } catch (e) {
      _showResult('❌ Error executing $operationName: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('iOS Integration Demo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: (!kIsWeb && Platform.isIOS)
          ? _buildIOSContent()
          : _buildNonIOSContent(),
    );
  }

  Widget _buildNonIOSContent() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.phone_iphone, size: 100, color: Colors.grey),
          SizedBox(height: 20),
          Text(
            'iOS Integration Demo',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'This feature only works on iOS',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildIOSContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Platform Info
          Card(
            color: Colors.blue[50],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.phone_iphone, color: Colors.blue, size: 30),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '📱 iOS Integration Demo',
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
              _buildOperationButton(
                'Open Settings',
                Icons.settings,
                Colors.blue,
                () => _iosService.openSettings(),
              ),
              _buildOperationButton(
                'WiFi Settings',
                Icons.wifi,
                Colors.blue,
                () => _iosService.openWifiSettings(),
              ),
              _buildOperationButton(
                'Bluetooth Settings',
                Icons.bluetooth,
                Colors.blue,
                () => _iosService.openBluetoothSettings(),
              ),
              _buildOperationButton(
                'Location Settings',
                Icons.location_on,
                Colors.blue,
                () => _iosService.openLocationSettings(),
              ),
              _buildOperationButton(
                'Notification Settings',
                Icons.notifications,
                Colors.blue,
                () => _iosService.openNotificationSettings(),
              ),
              _buildOperationButton(
                'App Settings',
                Icons.app_settings_alt,
                Colors.blue,
                () => _iosService.openAppSettings(),
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
                    child: _buildOperationButton(
                      'Make Call',
                      Icons.call,
                      Colors.green,
                      () => _iosService.makePhoneCall(_phoneController.text),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildOperationButton(
                      'FaceTime',
                      Icons.video_call,
                      Colors.green,
                      () => _iosService.openFaceTime(_phoneController.text),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildOperationButton(
                      'FaceTime Audio',
                      Icons.phone,
                      Colors.orange,
                      () =>
                          _iosService.openFaceTimeAudio(_phoneController.text),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildOperationButton(
                      'WhatsApp',
                      Icons.chat,
                      Colors.green,
                      () => _iosService.openWhatsApp(
                        phoneNumber: _phoneController.text,
                      ),
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
              _buildOperationButton(
                'Send SMS',
                Icons.sms,
                Colors.purple,
                () => _iosService.sendSMS(
                  _phoneController.text,
                  message: _messageController.text,
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
              _buildOperationButton(
                'Send Email',
                Icons.mail_outline,
                Colors.red,
                () => _iosService.sendEmail(
                  to: _emailController.text,
                  subject: 'Hello from Flutter iOS',
                  body:
                      'This email was sent from Flutter app using iOS URL schemes!',
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Navigation Section
          _buildSectionCard(
            title: '🗺️ Navigation & Maps',
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
              _buildOperationButton(
                'Open URL in Safari',
                Icons.open_in_browser,
                Colors.indigo,
                () => _iosService.openURL(_urlController.text),
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
                    child: _buildOperationButton(
                      'Open Maps',
                      Icons.map,
                      Colors.green,
                      () => _iosService.openMaps(_addressController.text),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildOperationButton(
                      'Maps (Coordinates)',
                      Icons.my_location,
                      Colors.teal,
                      () => _iosService.openMapsWithCoordinates(
                        10.8231,
                        106.6297,
                      ), // HCM City
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildOperationButton(
                'Maps Directions',
                Icons.directions,
                Colors.blue,
                () => _iosService.openMapsDirections(
                  destination: _addressController.text,
                  source: 'Current Location',
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Apple Apps Section
          _buildSectionCard(
            title: '🍎 Apple Apps',
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildOperationButton(
                      'Calendar',
                      Icons.calendar_today,
                      Colors.red,
                      () => _iosService.openCalendar(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildOperationButton(
                      'Contacts',
                      Icons.contacts,
                      Colors.blue,
                      () => _iosService.openContacts(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildOperationButton(
                      'Photos',
                      Icons.photo_library,
                      Colors.yellow,
                      () => _iosService.openPhotos(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildOperationButton(
                      'Music',
                      Icons.music_note,
                      Colors.pink,
                      () => _iosService.openMusic(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildOperationButton(
                      'Clock',
                      Icons.access_time,
                      Colors.grey,
                      () => _iosService.openClock(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildOperationButton(
                      'Weather',
                      Icons.wb_sunny,
                      Colors.orange,
                      () => _iosService.openWeather(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildOperationButton(
                      'Health',
                      Icons.favorite,
                      Colors.red,
                      () => _iosService.openHealth(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildOperationButton(
                      'Wallet',
                      Icons.account_balance_wallet,
                      Colors.black,
                      () => _iosService.openWallet(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildOperationButton(
                      'Shortcuts',
                      Icons.shortcut,
                      Colors.blue,
                      () => _iosService.openShortcuts(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildOperationButton(
                      'Find My',
                      Icons.my_location,
                      Colors.green,
                      () => _iosService.openFindMy(),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Social Media Section
          _buildSectionCard(
            title: '📱 Social Media',
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildOperationButton(
                      'Instagram',
                      Icons.camera_alt,
                      Colors.purple,
                      () => _iosService.openInstagram(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildOperationButton(
                      'Twitter',
                      Icons.alternate_email,
                      Colors.blue,
                      () => _iosService.openTwitter(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildOperationButton(
                      'YouTube',
                      Icons.play_circle,
                      Colors.red,
                      () => _iosService.openYouTube(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildOperationButton(
                      'Telegram',
                      Icons.send,
                      Colors.blue,
                      () => _iosService.openTelegram(),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // App Store Section
          _buildSectionCard(
            title: '🏪 App Store',
            children: [
              TextField(
                controller: _appIdController,
                decoration: const InputDecoration(
                  labelText: 'App ID (e.g., 544007664 for YouTube)',
                  prefixIcon: Icon(Icons.apps),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _buildOperationButton(
                'Open App Store',
                Icons.store,
                Colors.blue,
                () => _iosService.openAppStore(_appIdController.text),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Timer Section
          _buildSectionCard(
            title: '⏰ Timer & Alarms',
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildOperationButton(
                      'Set Timer (60s)',
                      Icons.timer,
                      Colors.orange,
                      () => _iosService.setTimer(60),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildOperationButton(
                      'Voice Memos',
                      Icons.mic,
                      Colors.red,
                      () => _iosService.openVoiceMemos(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildOperationButton(
                'Create Calendar Event',
                Icons.event,
                Colors.green,
                () => _iosService.createCalendarEvent(
                  title: 'Flutter iOS Meeting',
                  startDate: DateTime.now().add(const Duration(hours: 1)),
                  endDate: DateTime.now().add(const Duration(hours: 2)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Advanced Settings Section
          _buildSectionCard(
            title: '🔧 Advanced Settings',
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: IOSIntegrationService.commonSettingsPaths.entries.map(
                  (entry) {
                    return SizedBox(
                      width: (MediaQuery.of(context).size.width - 48) / 2,
                      child: ElevatedButton(
                        onPressed: () => _executeOperation(
                          'Open ${entry.key}',
                          () => _iosService.openSpecificSettings(entry.value),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[600],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        child: Text(
                          entry.key,
                          style: const TextStyle(fontSize: 11),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ).toList(),
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

  Widget _buildOperationButton(
    String text,
    IconData icon,
    Color color,
    Future<void> Function() onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _executeOperation(text, onPressed),
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
    _appIdController.dispose();
    super.dispose();
  }
}
