import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/riverpod_demo/counter_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: CounterDemoScreen());
  }
}

class CounterDemoScreen extends ConsumerWidget {
  const CounterDemoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    final counterNotifier = ref.read(counterProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Riverpod Core Concepts')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Current Value: '),
            Text('$count', style: Theme.of(context).textTheme.headlineLarge),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            onPressed: () {
              counterNotifier.decrement();
            },
            child: const Icon(Icons.remove),
          ),
          FloatingActionButton(
            onPressed: () {
              counterNotifier.increment();
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
