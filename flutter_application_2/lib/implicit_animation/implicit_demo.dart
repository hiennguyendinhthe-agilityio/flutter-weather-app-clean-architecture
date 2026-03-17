import 'package:flutter/material.dart';

class ImplicitDemo extends StatefulWidget {
  const ImplicitDemo({super.key});

  @override
  State<ImplicitDemo> createState() => _ImplicitDemoState();
}

class _ImplicitDemoState extends State<ImplicitDemo> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() {
        _expanded = !_expanded;
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
        width: _expanded ? 200 : 100,
        height: _expanded ? 100 : 200,
        color: _expanded ? Colors.red : Colors.blue,
        child: const Center(child: Text('Click Me')),
      ),
    );
  }
}
