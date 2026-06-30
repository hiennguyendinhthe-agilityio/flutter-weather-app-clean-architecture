import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: FadeDemo()));
}

class FadeDemo extends StatefulWidget {
  const FadeDemo({super.key});

  @override
  State<FadeDemo> createState() => _FadeDemoState();
}

class _FadeDemoState extends State<FadeDemo> {
  double _opacity = 1.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(seconds: 2),
              curve: Curves.elasticOut,
              child: Container(
                width: 200,
                height: 200,
                color: Colors.purple,
                child: const Center(
                  child: Text(
                    'Hello World',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _opacity = _opacity == 1.0 ? 0.0 : 1.0;
                });
              },
              child: Text(_opacity == 1.0 ? 'Fade Out' : 'Fade In'),
            ),
          ],
        ),
      ),
    );
  }
}
