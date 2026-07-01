import 'package:flutter/material.dart';

class ControllerDemo extends StatefulWidget {
  const ControllerDemo({super.key});

  @override
  State<ControllerDemo> createState() => _ControllerDemoState();
}

class _ControllerDemoState extends State<ControllerDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${(_controller.value * 100).toInt()}%'),

            const SizedBox(height: 20),

            LinearProgressIndicator(value: _controller.value),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _controller.forward(),
                  child: const Text('Play'),
                ),

                const SizedBox(width: 20),

                ElevatedButton(
                  onPressed: () => _controller.reverse(),
                  child: const Text('Reverse'),
                ),

                const SizedBox(width: 20),

                ElevatedButton(
                  onPressed: () => _controller.stop(),
                  child: const Text('Stop'),
                ),
              ],
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () => _controller.repeat(reverse: true),
              child: const Text('Loop'),
            ),
          ],
        ),
      ),
    );
  }
}
