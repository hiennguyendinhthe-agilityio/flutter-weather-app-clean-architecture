import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'lesson_6.g.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Lesson6Screen(),
    );
  }
}

const mockUsers = {
  '1': 'Nguyen Van A - Developer',
  '2': 'Tran Thi B - Designer',
  '3': 'Le Van C - Tester',
};

@riverpod
Future<String> userDetails(Ref ref, String userId) async {
  Timer? timer;

  final keepAlive = ref.keepAlive();

  ref.onCancel(() {
    timer = Timer(const Duration(seconds: 5), () {
      keepAlive.close();
    });
  });

  ref.onResume(() {
    timer?.cancel();
  });

  ref.onDispose(() {
    timer?.cancel();
  });

  debugPrint('Getting user info for ID: $userId...');

  await Future.delayed(const Duration(milliseconds: 1500));

  final user = mockUsers[userId];
  if (user == null) {
    throw Exception('Not found user with ID $userId');
  }

  return user;
}

class Lesson6Screen extends StatefulWidget {
  const Lesson6Screen({super.key});

  @override
  State<Lesson6Screen> createState() => _Lesson6ScreenState();
}

class _Lesson6ScreenState extends State<Lesson6Screen> {
  String selectedUserId = '1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lesson 6: StateProvider'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildUserButton('1'),
                _buildUserButton('2'),
                _buildUserButton('3'),
              ],
            ),
          ),
          const Divider(),

          Expanded(child: UserDetailsWidget(userId: selectedUserId)),
        ],
      ),
    );
  }

  Widget _buildUserButton(String id) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedUserId = id;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedUserId == id ? Colors.teal : Colors.grey,
      ),
      child: Text('User $id', style: const TextStyle(color: Colors.white)),
    );
  }
}

class UserDetailsWidget extends ConsumerWidget {
  final String userId;

  const UserDetailsWidget({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUser = ref.watch(userDetailsProvider(userId));

    return Center(
      child: asyncUser.when(
        loading: () => const CircularProgressIndicator(color: Colors.teal),
        error: (err, stack) =>
            Text('Error: $err', style: const TextStyle(color: Colors.red)),
        data: (data) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person, size: 80, color: Colors.teal),
            const SizedBox(height: 16),
            Text(
              data,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '💡 Tip: Open Debug Console. \nClick from User 1 to 2, then back to 1. \nYou will see User 1 is not loaded again (not printed "Loading...") because Riverpod has automatically CACHED (stored) the data!',
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
