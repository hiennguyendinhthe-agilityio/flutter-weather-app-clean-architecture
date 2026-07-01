import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'riverpod_playground.g.dart';

@riverpod
String helloWorld(Ref ref) {
  return 'Hello Riverpod! This is data from Provider.';
}

@riverpod
class Counter extends _$Counter {
  @override
  int build() {
    return 0;
  }

  void increment() {
    state = state + 1;
  }

  void decrement() {
    state = state - 1;
  }
}

@riverpod
Future<double> accountBalance(Ref ref) async {
  await Future.delayed(const Duration(seconds: 2));

  return 5432000.0;
}

@riverpod
Future<String> userDetails(Ref ref, String userId) async {
  await Future.delayed(const Duration(seconds: 1));
  return 'Information of User $userId: Nguyen Van A';
}

class RiverpodPlayground extends ConsumerWidget {
  const RiverpodPlayground({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(counterProvider, (previous, next) {
      if (next > 0 && next % 5 == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Congratulations! You have reached $next points! 🎉'),
          ),
        );
      }
    });

    final helloText = ref.watch(helloWorldProvider);

    final count = ref.watch(counterProvider);

    final balanceAsync = ref.watch(accountBalanceProvider);

    final userAsync = ref.watch(userDetailsProvider('123'));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riverpod Playground'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.rocket_launch, size: 64, color: Colors.blue),
            const SizedBox(height: 24),
            Text(
              helloText,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const Divider(height: 60, thickness: 2, endIndent: 30, indent: 30),
            const Text(
              'Phase 2: Counter',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Text(
              '$count',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    ref.read(counterProvider.notifier).decrement();
                  },
                  icon: const Icon(Icons.remove),
                  label: const Text('Minus'),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.read(counterProvider.notifier).increment();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Plus'),
                ),
              ],
            ),
            const Divider(height: 60, thickness: 2, endIndent: 30, indent: 30),
            const Text(
              'Phase 3: Async',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            balanceAsync.when(
              loading: () => const CircularProgressIndicator(),

              error: (error, stack) => Text(
                'Error: $error',
                style: const TextStyle(color: Colors.red),
              ),

              data: (balance) => Text(
                'Balance: ${balance.toStringAsFixed(0)} USD',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.invalidate(accountBalanceProvider);
              },
              child: const Text('Load Data API'),
            ),
            const Divider(height: 60, thickness: 2, endIndent: 30, indent: 30),
            const Text(
              'Phase 4: Provider with Parameters (Family)',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            userAsync.when(
              loading: () => const CircularProgressIndicator(),
              error: (e, st) => Text('Error: $e'),
              data: (data) => Text(
                data,
                style: const TextStyle(fontSize: 18, color: Colors.purple),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main(List<String> args) {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(length: 5, child: RiverpodPlayground()),
    );
  }
}
