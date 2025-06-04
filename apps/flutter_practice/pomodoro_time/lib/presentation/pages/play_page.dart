import 'package:flutter/material.dart';

class PlayPage extends StatelessWidget {
  const PlayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Play Page'),
      ),
      body: Center(
        child: Text(
          'This is the Play Page',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
