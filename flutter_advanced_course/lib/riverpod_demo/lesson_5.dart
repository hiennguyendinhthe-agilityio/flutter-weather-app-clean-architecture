import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'lesson_5.g.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Lesson5Screen(),
    );
  }
}

@riverpod
Future<int> weatherTemperature(Ref ref) async {
  await Future.delayed(const Duration(seconds: 2));

  return 34;
}

class Lesson5Screen extends ConsumerWidget {
  const Lesson5Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(weatherTemperatureProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lesson 5: AsyncValue'),
        backgroundColor: Colors.blueAccent,
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(weatherTemperatureProvider);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.cloud,
                      size: 100,
                      color: Colors.blueAccent,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Weather today:',
                      style: TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 20),

                    weatherAsync.when(
                      data: (temperature) {
                        return Text(
                          '$temperature°C',
                          style: const TextStyle(
                            fontSize: 80,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        );
                      },

                      error: (error, stackTrace) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Oh no, it\'s broken:\n$error',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                            ),
                          ),
                        );
                      },

                      loading: () {
                        return const CircularProgressIndicator(
                          color: Colors.blueAccent,
                        );
                      },
                    ),

                    const SizedBox(height: 40),
                    const Text(
                      'Pull to refresh',
                      style: TextStyle(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
