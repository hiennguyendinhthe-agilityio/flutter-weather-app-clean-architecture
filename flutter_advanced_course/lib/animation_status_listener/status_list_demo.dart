import 'package:flutter/material.dart';

class StatusListDemo extends StatefulWidget {
  const StatusListDemo({super.key});

  @override
  State<StatusListDemo> createState() => _StatusListDemoState();
}

class _StatusListDemoState extends State<StatusListDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;

  String _statusText = 'dismissed';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _sizeAnimation = Tween<double>(
      begin: 50,
      end: 200,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticInOut));

    _controller.addListener(() {
      setState(() {});
    });

    _controller.addStatusListener((AnimationStatus status) {
      setState(() {
        switch (status) {
          case AnimationStatus.dismissed:
            _statusText = 'dismissed';
            break;
          case AnimationStatus.forward:
            _statusText = 'forward';
            break;
          case AnimationStatus.reverse:
            _statusText = 'reverse';
            break;
          case AnimationStatus.completed:
            _statusText = 'completed';
            Future.delayed(const Duration(seconds: 2), () {
              _controller.reverse();
            });
            break;
        }
      });
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
      appBar: AppBar(title: const Text('Status List Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _statusText,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'Value: ${_controller.value.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Container(
              width: _sizeAnimation.value,
              height: _sizeAnimation.value,
              decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                if (_controller.isDismissed) {
                  _controller.forward();
                }
              },
              child: const Text('Play'),
            ),
          ],
        ),
      ),
    );
  }
}
