import 'package:flutter/material.dart';

import 'core/di/injection.dart';
import 'pages/di_demo_page.dart';
import 'services/counter_service.dart';
import 'services/logger_service.dart';

void main() {
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DI Learning App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Dependency Injection Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final CounterService _counterService;
  late final LoggerService _loggerService;

  @override
  void initState() {
    super.initState();

    _counterService = getIt<CounterService>();
    _loggerService = getIt<LoggerService>();

    _loggerService.logInfo('MyHomePage initialized');
  }

  void _incrementCounter() {
    setState(() {
      _counterService.increment();
      _loggerService.log('Counter incremented to ${_counterService.count}');
    });
  }

  void _decrementCounter() {
    setState(() {
      _counterService.decrement();
      _loggerService.log('Counter decremented to ${_counterService.count}');
    });
  }

  void _resetCounter() {
    setState(() {
      _counterService.reset();
      _loggerService.log('Counter reset to ${_counterService.count}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('DI Counter Demo:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Text(
              '${_counterService.count}',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _decrementCounter,
                  child: const Icon(Icons.remove),
                ),
                ElevatedButton(
                  onPressed: _resetCounter,
                  child: const Icon(Icons.refresh),
                ),
                ElevatedButton(
                  onPressed: _incrementCounter,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DiDemoPage()),
                );
              },
              child: const Text('DI Registration Types Demo'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Check the console for logs!',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
