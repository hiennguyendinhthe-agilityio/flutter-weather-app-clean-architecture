import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/di/injection.dart';
import 'pages/api_demo_page.dart';
import 'pages/di_demo_page.dart';
import 'pages/mockapi_demo_page.dart';
import 'pages/provider_demo_page.dart';
import 'providers/counter_provider.dart';
import 'providers/user_provider.dart';
import 'services/logger_service.dart';

void main() {
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CounterProvider>(
          create: (_) => getIt<CounterProvider>(),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (_) => getIt<UserProvider>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Learning App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Flutter Learning Demo'),
      ),
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
  late final LoggerService _loggerService;

  @override
  void initState() {
    super.initState();
    _loggerService = getIt<LoggerService>();
    _loggerService.logInfo('MyHomePage initialized with Provider');
  }

  void _incrementCounter() {
    context.read<CounterProvider>().increment();
  }

  void _decrementCounter() {
    context.read<CounterProvider>().decrement();
  }

  void _resetCounter() {
    context.read<CounterProvider>().reset();
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
            const Text(
              'Provider Counter Demo:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),

            Consumer<CounterProvider>(
              builder: (context, counterProvider, child) {
                return Column(
                  children: [
                    Text(
                      '${counterProvider.count}',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    if (counterProvider.isLoading)
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: CircularProgressIndicator(),
                      ),
                    if (counterProvider.hasError)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          counterProvider.errorMessage!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                );
              },
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

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<CounterProvider>().loadCounterFromServer();
              },
              child: const Text('Load from Server'),
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

            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProviderDemoPage(),
                  ),
                );
              },
              child: const Text('Provider Patterns Demo'),
            ),

            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ApiDemoPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('🚀 API Integration Demo'),
            ),

            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MockApiDemoPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white,
              ),
              child: const Text('🌐 MockAPI CRUD Demo'),
            ),

            const SizedBox(height: 20),
            const Text(
              'Provider Auto Change Detection Demo!',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
