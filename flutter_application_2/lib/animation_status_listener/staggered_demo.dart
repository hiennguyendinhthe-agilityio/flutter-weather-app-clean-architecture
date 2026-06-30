import 'package:flutter/material.dart';

class StaggeredDemo extends StatefulWidget {
  const StaggeredDemo({super.key});

  @override
  State<StaggeredDemo> createState() => _StaggeredDemoState();
}

class _StaggeredDemoState extends State<StaggeredDemo>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _opacity1;
  late Animation<Offset> _slide1;

  late Animation<double> _opacity2;
  late Animation<Offset> _slide2;

  late Animation<double> _opacity3;
  late Animation<Offset> _slide3;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _opacity1 = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.4, curve: Curves.elasticOut),
      ),
    );

    _slide1 = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0, 0.5, curve: Curves.elasticOut),
          ),
        );

    _opacity2 = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.7, curve: Curves.elasticOut),
      ),
    );

    _slide2 = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.3, 0.7, curve: Curves.elasticOut),
          ),
        );

    _opacity3 = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.6, 1)),
    );

    _slide3 = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.6, 1, curve: Curves.elasticOut),
          ),
        );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildAnimatedItem({
    required Animation<double> opacity,
    required Animation<Offset> slide,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: opacity,
          child: SlideTransition(position: slide, child: child),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: color,
            child: Icon(icon, color: Colors.white),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(subtitle),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Staggered Demo')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildAnimatedItem(
            opacity: _opacity1,
            slide: _slide1,
            title: 'Flutter Animation',
            subtitle: 'Module 5 - Day 2',
            icon: Icons.animation,
            color: Colors.purple,
          ),
          _buildAnimatedItem(
            opacity: _opacity2,
            slide: _slide2,
            title: 'Flutter Animation',
            subtitle: 'Module 5 - Day 2',
            icon: Icons.queue,
            color: Colors.green,
          ),
          _buildAnimatedItem(
            opacity: _opacity3,
            slide: _slide3,
            title: 'Flutter Animation',
            subtitle: 'Module 5 - Day 2',
            icon: Icons.timer,
            color: Colors.purple,
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  _controller.reset();
                  _controller.forward();
                },
                child: const Text('Play'),
              ),

              const SizedBox(width: 20),

              ElevatedButton(
                onPressed: () => _controller.reset(),
                child: const Text('Reset'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
