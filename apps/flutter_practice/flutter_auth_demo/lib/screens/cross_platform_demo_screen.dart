import 'package:flutter/material.dart';

import '../core/di/injection.dart';
import '../services/cross_platform_integration_service.dart';

class CrossPlatformDemoScreen extends StatefulWidget {
  const CrossPlatformDemoScreen({super.key});

  @override
  State<CrossPlatformDemoScreen> createState() =>
      _CrossPlatformDemoScreenState();
}

class _CrossPlatformDemoScreenState extends State<CrossPlatformDemoScreen> {
  final CrossPlatformIntegrationService _crossPlatformService =
      getIt<CrossPlatformIntegrationService>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String _result = '';
  Map<String, bool> _capabilities = {};
  List<String> _limitations = [];

  @override
  void initState() {
    super.initState();
    // Set default values
    _phoneController.text = '+84123456789';
    _messageController.text = 'Hello from Flutter Cross-Platform!';
    _emailController.text = 'test@example.com';
    _urlController.text = 'https://flutter.dev';
    _addressController.text = 'Ho Chi Minh City, Vietnam';

    // Load platform capabilities
    _loadPlatformInfo();
  }

  void _loadPlatformInfo() {
    setState(() {
      _capabilities = _crossPlatformService.getPlatformCapabilities();
      _limitations = _crossPlatformService.getPlatformLimitations();
    });
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
    try {
      _showResult('🔄 Đang thực hiện: $operationName...');
      await operation();
      _showResult(
        '✅ Đã thực hiện: $operationName trên ${_crossPlatformService.currentPlatform}',
      );
    } catch (e) {
      _showResult('❌ Lỗi khi thực hiện $operationName: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cross-Platform Demo'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Platform Info Card
            Card(
              color: Colors.purple[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _getPlatformIcon(),
                          color: Colors.purple,
                          size: 30,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '🌐 Cross-Platform Integration',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Current Platform: ${_crossPlatformService.currentPlatform}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Platform Capabilities
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '✨ Platform Capabilities',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._capabilities.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          children: [
                            Icon(
                              entry.value ? Icons.check_circle : Icons.cancel,
                              color: entry.value ? Colors.green : Colors.red,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                entry.key
                                    .replaceAll(RegExp(r'([A-Z])'), ' \$1')
                                    .toLowerCase(),
                                style: TextStyle(
                                  color: entry.value
                                      ? Colors.black87
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Platform Limitations
            if (_limitations.isNotEmpty)
              Card(
                color: Colors.orange[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.warning, color: Colors.orange),
                          SizedBox(width: 8),
                          Text(
                            'Platform Limitations',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ..._limitations.map((limitation) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '• ',
                                style: TextStyle(color: Colors.orange),
                              ),
                              Expanded(
                                child: Text(
                                  limitation,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // System Settings Section
            _buildSectionCard(
              title: '⚙️ System Settings (Cross-Platform)',
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildOperationButton(
                        'Settings',
                        Icons.settings,
                        Colors.blue,
                        () => _crossPlatformService.openSettings(),
                        enabled: _capabilities['canOpenSettings'] ?? false,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildOperationButton(
                        'WiFi',
                        Icons.wifi,
                        Colors.blue,
                        () => _crossPlatformService.openWifiSettings(),
                        enabled: _capabilities['canOpenSettings'] ?? false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildOperationButton(
                        'Bluetooth',
                        Icons.bluetooth,
                        Colors.blue,
                        () => _crossPlatformService.openBluetoothSettings(),
                        enabled: _capabilities['canOpenSettings'] ?? false,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildOperationButton(
                        'Location',
                        Icons.location_on,
                        Colors.blue,
                        () => _crossPlatformService.openLocationSettings(),
                        enabled: _capabilities['canOpenSettings'] ?? false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildOperationButton(
                  'App Settings',
                  Icons.app_settings_alt,
                  Colors.blue,
                  () => _crossPlatformService.openAppSettings(),
                  enabled: _capabilities['canOpenSettings'] ?? false,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Communication Section
            _buildSectionCard(
              title: '📞 Communication (Cross-Platform)',
              children: [
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Số điện thoại',
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
                        'Gọi điện',
                        Icons.call,
                        Colors.green,
                        () => _crossPlatformService.makePhoneCall(
                          _phoneController.text,
                        ),
                        enabled: _capabilities['canMakePhoneCalls'] ?? false,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildOperationButton(
                        'Mở Dialer',
                        Icons.dialpad,
                        Colors.orange,
                        () => _crossPlatformService.openDialer(
                          _phoneController.text,
                        ),
                        enabled: _capabilities['canMakePhoneCalls'] ?? false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    labelText: 'Tin nhắn SMS',
                    prefixIcon: Icon(Icons.message),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                _buildOperationButton(
                  'Gửi SMS',
                  Icons.sms,
                  Colors.purple,
                  () => _crossPlatformService.sendSMS(
                    _phoneController.text,
                    _messageController.text,
                  ),
                  enabled: _capabilities['canSendSMS'] ?? false,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Email Section
            _buildSectionCard(
              title: '📧 Email (Cross-Platform)',
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
                  'Gửi Email',
                  Icons.mail_outline,
                  Colors.red,
                  () => _crossPlatformService.sendEmail(
                    to: _emailController.text,
                    subject: 'Hello from Flutter Cross-Platform',
                    body:
                        'This email was sent from Flutter app running on ${_crossPlatformService.currentPlatform}!',
                  ),
                  enabled: _capabilities['canSendEmail'] ?? false,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Navigation Section
            _buildSectionCard(
              title: '🗺️ Navigation (Cross-Platform)',
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
                  'Mở URL',
                  Icons.open_in_browser,
                  Colors.indigo,
                  () => _crossPlatformService.openURL(_urlController.text),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Địa chỉ',
                    prefixIcon: Icon(Icons.location_on),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildOperationButton(
                        'Mở Maps',
                        Icons.map,
                        Colors.green,
                        () => _crossPlatformService.openMaps(
                          _addressController.text,
                        ),
                        enabled: _capabilities['canOpenMaps'] ?? false,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildOperationButton(
                        'Maps (Tọa độ)',
                        Icons.my_location,
                        Colors.teal,
                        () => _crossPlatformService.openMapsWithCoordinates(
                          10.8231,
                          106.6297,
                        ),
                        enabled: _capabilities['canOpenMaps'] ?? false,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Media & Apps Section
            _buildSectionCard(
              title: '📱 Media & Apps (Cross-Platform)',
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildOperationButton(
                        'Camera',
                        Icons.camera_alt,
                        Colors.purple,
                        () => _crossPlatformService.openCamera(),
                        enabled: _capabilities['canOpenCamera'] ?? false,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildOperationButton(
                        'Gallery/Photos',
                        Icons.photo_library,
                        Colors.pink,
                        () => _crossPlatformService.openGallery(),
                        enabled: _capabilities['canOpenGallery'] ?? false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildOperationButton(
                        'Music Player',
                        Icons.music_note,
                        Colors.purple,
                        () => _crossPlatformService.openMusicPlayer(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildOperationButton(
                        'Calendar',
                        Icons.calendar_today,
                        Colors.red,
                        () => _crossPlatformService.openCalendar(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildOperationButton(
                  'Share Text',
                  Icons.share,
                  Colors.blue,
                  () => _crossPlatformService.shareText(
                    'Hello from Flutter Cross-Platform! 🚀',
                  ),
                  enabled: _capabilities['canShareText'] ?? false,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Social Media Section
            _buildSectionCard(
              title: '📱 Social Media (Cross-Platform)',
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildOperationButton(
                        'Instagram',
                        Icons.camera_alt,
                        Colors.purple,
                        () => _crossPlatformService.openInstagram(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildOperationButton(
                        'YouTube',
                        Icons.play_circle,
                        Colors.red,
                        () => _crossPlatformService.openYouTube(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildOperationButton(
                  'WhatsApp',
                  Icons.chat,
                  Colors.green,
                  () => _crossPlatformService.openWhatsApp(
                    phoneNumber: _phoneController.text,
                    message: _messageController.text,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Time & Events Section
            _buildSectionCard(
              title: '⏰ Time & Events (Cross-Platform)',
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildOperationButton(
                        'Set Timer (60s)',
                        Icons.timer,
                        Colors.orange,
                        () =>
                            _crossPlatformService.setTimer(60, 'Flutter Timer'),
                        enabled: _capabilities['canSetTimers'] ?? false,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildOperationButton(
                        'Set Alarm (9:00)',
                        Icons.alarm,
                        Colors.blue,
                        () => _crossPlatformService.setAlarm(
                          9,
                          0,
                          'Flutter Alarm',
                        ),
                        enabled: _capabilities['canSetAlarms'] ?? false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildOperationButton(
                  'Create Calendar Event',
                  Icons.event,
                  Colors.green,
                  () => _crossPlatformService.createCalendarEvent(
                    title: 'Flutter Cross-Platform Meeting',
                    startTime: DateTime.now().add(const Duration(hours: 1)),
                    endTime: DateTime.now().add(const Duration(hours: 2)),
                    description: 'Meeting about cross-platform development',
                  ),
                  enabled: _capabilities['canCreateCalendarEvents'] ?? false,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // App Store Section
            _buildSectionCard(
              title: '🏪 App Store (Cross-Platform)',
              children: [
                _buildOperationButton(
                  _crossPlatformService.isAndroid
                      ? 'Open Play Store'
                      : 'Open App Store',
                  Icons.store,
                  Colors.blue,
                  () => _crossPlatformService.openAppStore(
                    _crossPlatformService.isAndroid
                        ? 'com.google.android.apps.maps'
                        : '544007664', // YouTube
                  ),
                  enabled: _capabilities['canOpenAppStore'] ?? false,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Batch Operations Section
            _buildSectionCard(
              title: '🔄 Batch Operations',
              children: [
                _buildOperationButton(
                  'Test All Settings',
                  Icons.settings_applications,
                  Colors.purple,
                  () async {
                    _showResult('🔄 Đang test batch operations...');
                    final results = await _crossPlatformService
                        .executeBatchOperations([
                          'settings',
                          'wifi',
                          'bluetooth',
                          'location',
                          'app_settings',
                        ]);
                    final successCount = results.where((r) => r).length;
                    _showResult(
                      '✅ Batch operations completed: $successCount/${results.length} successful',
                    );
                  },
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
      ),
    );
  }

  IconData _getPlatformIcon() {
    if (_crossPlatformService.isAndroid) return Icons.android;
    if (_crossPlatformService.isIOS) return Icons.phone_iphone;
    if (_crossPlatformService.isWeb) return Icons.web;
    return Icons.device_unknown;
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
    Future<void> Function() onPressed, {
    bool enabled = true,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: enabled ? () => _executeOperation(text, onPressed) : null,
        icon: Icon(icon),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled ? color : Colors.grey,
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
    super.dispose();
  }
}
