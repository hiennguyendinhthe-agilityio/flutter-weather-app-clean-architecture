import 'package:flutter/material.dart';
import 'package:training_router/screens/detail_screen.dart';
import 'package:training_router/screens/matrix_transition.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onItemSeclected});

  final ValueChanged<String> onItemSeclected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home Screen'),
        ),
        body: Center(
          child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MatrixTransitionPageRoute(page: const DetailsScreen()),
                );
              },
              child: const Text('Go to Settings Screen')),
        ));
  }
}
