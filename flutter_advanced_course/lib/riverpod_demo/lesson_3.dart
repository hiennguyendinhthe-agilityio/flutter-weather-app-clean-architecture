import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Lesson3Screen(),
    );
  }
}

final cartCountProvider = StateProvider<int>((ref) => 0);

class Lesson3Screen extends ConsumerWidget {
  const Lesson3Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(cartCountProvider);

    ref.listen<int>(cartCountProvider, (previous, next) {
      if (next == 5 && (previous == null || next > previous)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              '🎉 Congratulations! You get free shipping for buying 5 items!',
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }

      if (next >= 10 && (previous != null && next > previous)) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('⚠️ Warning!'),
              content: const Text(
                'You are buying too much, save some for others!',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('I understand'),
                ),
              ],
            );
          },
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lesson 3: Side Effects'),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_bag, size: 100, color: Colors.purple),
            const SizedBox(height: 20),
            const Text(
              'Number of items in cart:',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              '$cartCount',
              style: const TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (ref.read(cartCountProvider) > 0) {
                      ref.read(cartCountProvider.notifier).state--;
                    }
                  },
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    ref.read(cartCountProvider.notifier).state++;
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Try pressing the plus sign (+) continuously until you reach 5 and 10 to see what happens!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
