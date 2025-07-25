import 'package:flutter/material.dart';

import '../core/di/injection.dart';
import '../services/analytics_service.dart';
import '../services/config_service.dart';
import '../services/logger_service.dart';
import '../services/user_service.dart';

class DiDemoPage extends StatefulWidget {
  const DiDemoPage({super.key});

  @override
  State<DiDemoPage> createState() => _DiDemoPageState();
}

class _DiDemoPageState extends State<DiDemoPage> {
  final List<String> _results = [];

  void _addResult(String result) {
    setState(() {
      _results.add(result);
    });
  }

  void _clearResults() {
    setState(() {
      _results.clear();
    });
  }

  void _testSingleton() {
    final logger1 = getIt<LoggerService>();
    final logger2 = getIt<LoggerService>();

    final isSame = identical(logger1, logger2);
    _addResult('🔄 Singleton Test (LoggerService):');
    _addResult('Instance 1: ${logger1.hashCode}');
    _addResult('Instance 2: ${logger2.hashCode}');
    _addResult('Same instance? $isSame');
    _addResult('---');
  }

  void _testLazySingleton() {
    _addResult('🔄 Lazy Singleton Test (ConfigService):');
    _addResult('Getting first instance...');
    final config1 = getIt<ConfigService>();
    _addResult('Config 1: ${config1.hashCode}');

    _addResult('Getting second instance...');
    final config2 = getIt<ConfigService>();
    _addResult('Config 2: ${config2.hashCode}');

    final isSame = identical(config1, config2);
    _addResult('Same instance? $isSame');
    _addResult('App Info: ${config1.getAppInfo()}');
    _addResult('---');
  }

  void _testFactory() {
    _addResult('🔄 Factory Test (UserService):');
    final user1 = getIt<UserService>();
    final user2 = getIt<UserService>();

    final isSame = identical(user1, user2);
    _addResult('User 1 ID: ${user1.userId}');
    _addResult('User 2 ID: ${user2.userId}');
    _addResult('Same instance? $isSame');
    _addResult('User 1: ${user1.getCurrentUser()}');
    _addResult('User 2: ${user2.getCurrentUser()}');
    _addResult('---');
  }

  void _testDependencyInjection() {
    _addResult('🔄 Dependency Injection Test:');
    final analytics = getIt<AnalyticsService>();

    analytics.trackEvent('button_click');
    analytics.trackEvent('page_view');
    analytics.trackScreenView('di_demo');

    _addResult('Analytics Info: ${analytics.getAnalyticsInfo()}');
    _addResult('---');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DI Registration Types Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Test các loại DI Registration:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: _testSingleton,
                      child: const Text('Test Singleton'),
                    ),
                    ElevatedButton(
                      onPressed: _testLazySingleton,
                      child: const Text('Test Lazy Singleton'),
                    ),
                    ElevatedButton(
                      onPressed: _testFactory,
                      child: const Text('Test Factory'),
                    ),
                    ElevatedButton(
                      onPressed: _testDependencyInjection,
                      child: const Text('Test Dependencies'),
                    ),
                    ElevatedButton(
                      onPressed: _clearResults,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _results.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    _results[index],
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: _results[index].startsWith('🔄')
                          ? Colors.blue
                          : _results[index].startsWith('---')
                          ? Colors.grey
                          : Colors.black87,
                      fontWeight: _results[index].startsWith('🔄')
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
