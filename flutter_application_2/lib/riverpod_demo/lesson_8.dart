import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'lesson_8.g.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Lesson8Screen(),
    );
  }
}

@riverpod
class UserProfile extends _$UserProfile {
  @override
  Future<String> build() async {
    await Future.delayed(const Duration(seconds: 1));
    return 'Hien Nguyen';
  }

  Future<void> updateName(String newName) async {
    state = const AsyncValue.loading();

    try {
      await Future.delayed(const Duration(seconds: 2));

      if (newName.toLowerCase() == 'error') {
        throw Exception('Server rejected this name!');
      }

      state = AsyncValue.data(newName);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

class Lesson8Screen extends ConsumerStatefulWidget {
  const Lesson8Screen({super.key});

  @override
  ConsumerState<Lesson8Screen> createState() => _Lesson8ScreenState();
}

class _Lesson8ScreenState extends ConsumerState<Lesson8Screen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);

    ref.listen<AsyncValue<String>>(userProfileProvider, (previous, next) {
      if (!next.isLoading && next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${next.error}'),
            backgroundColor: Colors.red,
          ),
        );
      }

      if (previous != null &&
          previous.isLoading &&
          !next.isLoading &&
          !next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Save successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lesson 8: Edit Profile (AsyncNotifier)'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.deepOrange,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 32),

            profileAsync.when(
              data: (name) => Text(
                'Hello, $name',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              loading: () =>
                  const CircularProgressIndicator(color: Colors.deepOrange),
              error: (err, stack) {
                return const Text(
                  'Current name is hidden due to error',
                  style: TextStyle(color: Colors.red),
                );
              },
            ),

            const SizedBox(height: 40),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter new name...',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _controller.clear(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: profileAsync.isLoading
                    ? null
                    : () {
                        final newName = _controller.text.trim();
                        if (newName.isNotEmpty) {
                          ref
                              .read(userProfileProvider.notifier)
                              .updateName(newName);

                          FocusScope.of(context).unfocus();
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                ),
                child: profileAsync.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Save to Server',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Tip: Try typing "error" and tap save to see how errors are handled.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
