import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'lesson_4.g.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Lesson4Screen(),
    );
  }
}

@riverpod
class ModernCounter extends _$ModernCounter {
  @override
  int build() => 0;

  void increment() => state++;

  void reset() => state = 0;
}

class Lesson4Screen extends ConsumerStatefulWidget {
  const Lesson4Screen({super.key});

  @override
  ConsumerState<Lesson4Screen> createState() => _Lesson4ScreenState();
}

class _Lesson4ScreenState extends ConsumerState<Lesson4Screen> {
  String _localGreeting = 'Good morning';

  @override
  void initState() {
    super.initState();

    debugPrint(
      'The initial value of the counter is: ${ref.read(modernCounterProvider)}',
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('The entire screen is being rebuilt!');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lesson 4: Consumer & Generator'),
        backgroundColor: Colors.indigo,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _localGreeting,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                final count = ref.watch(modernCounterProvider);
                debugPrint('Only this Text is being rebuilt!');

                return Text(
                  '$count',
                  style: const TextStyle(fontSize: 80, color: Colors.indigo),
                );
              },
            ),

            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                ref.read(modernCounterProvider.notifier).increment();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
              child: const Text('Add 1', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _localGreeting = _localGreeting == 'Good morning'
                      ? 'Good afternoon'
                      : 'Good morning';
                });
              },
              child: const Text('Change Local State (SetState)'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                ref.read(modernCounterProvider.notifier).reset();
              },
              child: const Text('Reset Counter'),
            ),
          ],
        ),
      ),
    );
  }
}
