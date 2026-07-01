import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: SpringCardDemo());
  }
}

class SpringCardDemo extends StatefulWidget {
  const SpringCardDemo({super.key});
  @override
  State<SpringCardDemo> createState() => _SpringCardDemoState();
}

class _SpringCardDemoState extends State<SpringCardDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _xAnimation;
  late Animation<double> _yAnimation;

  Offset _position = Offset.zero;

  Offset _velocity = Offset.zero;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
    _xAnimation = Tween<double>(begin: 0, end: 0).animate(_controller);
    _yAnimation = Tween<double>(begin: 0, end: 0).animate(_controller);

    _controller.addListener(() {
      setState(() {
        _position = Offset(_xAnimation.value, _yAnimation.value);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _runDualSpring(SpringDescription spring) {
    _controller.stop();
    _controller.reset();

    final xSim = SpringSimulation(spring, _position.dx, 0, _velocity.dx);
    final ySim = SpringSimulation(spring, _position.dy, 0, _velocity.dy);

    final startTime = DateTime.now();

    _controller
      ..duration = const Duration(seconds: 2)
      ..addListener(() {
        final elapsed =
            DateTime.now().difference(startTime).inMilliseconds / 1000.0;

        setState(() {
          _position = Offset(xSim.x(elapsed), ySim.x(elapsed));
        });
      })
      ..forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      appBar: AppBar(
        title: const Text('Spring Card'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Center(
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.deepPurple.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: const Icon(Icons.add, color: Colors.deepPurple, size: 20),
            ),
          ),
          Positioned(
            left: screenW / 2 - 80 + _position.dx,
            top: screenH / 2 - 60 + _position.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                _controller.stop();
                setState(() {
                  _position += details.delta;
                });
              },
              onPanEnd: (details) {
                _velocity = details.velocity.pixelsPerSecond;

                _velocity = Offset(
                  _velocity.dx.clamp(-1500, 1500),
                  _velocity.dy.clamp(-1500, 1500),
                );

                _runDualSpring(
                  const SpringDescription(mass: 1, stiffness: 200, damping: 15),
                );
              },
              child: _buildDraggableCard(),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                const Text(
                  'Push card then drop',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  'Velocity: (${_velocity.dx.toStringAsFixed(0)}, '
                  '${_velocity.dy.toStringAsFixed(0)})',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDraggableCard() {
    final rotateAngle = _position.dx / 500;

    return Transform.rotate(
      angle: rotateAngle,
      child: Container(
        width: 160,
        height: 120,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.lerp(
                const Color(0xFF6C63FF),
                const Color(0xFFFF6B6B),
                (_position.dx.abs() / 200).clamp(0, 1),
              )!,
              const Color(0xFF00BFA5),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6C63FF).withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.drag_indicator, color: Colors.white, size: 32),
            SizedBox(height: 8),
            Text(
              'Push card then drop',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SpringTween extends Tween<double> {
  final SpringSimulation simulation;
  SpringTween({required this.simulation}) : super(begin: 0, end: 1);

  @override
  double lerp(double t) => simulation.x(t);
}

class SwipeDismissDemo extends StatefulWidget {
  const SwipeDismissDemo({super.key});
  @override
  State<SwipeDismissDemo> createState() => _SwipeDismissDemoState();
}

class _SwipeDismissDemoState extends State<SwipeDismissDemo> {
  final List<_NotificationItem> _items = [
    const _NotificationItem(
      id: '1',
      title: 'New message',
      body: 'Hien sent you a message',
      icon: Icons.message,
      color: Color(0xFF6C63FF),
    ),
    const _NotificationItem(
      id: '2',
      title: 'Build successful',
      body: 'Flutter app compiled without errors',
      icon: Icons.check_circle,
      color: Color(0xFF00BFA5),
    ),
    const _NotificationItem(
      id: '3',
      title: 'Meeting reminder',
      body: 'Daily standup in 10 minutes',
      icon: Icons.calendar_today,
      color: Color(0xFFFFB300),
    ),
    const _NotificationItem(
      id: '4',
      title: 'New follower',
      body: 'Someone started following you',
      icon: Icons.person_add,
      color: Color(0xFFFF6B6B),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      appBar: AppBar(
        title: const Text('Swipe to Dismiss'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () => setState(() => _items.clear()),
            child: const Text(
              'Clear all',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
      body: _items.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No notifications',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];

                return Dismissible(
                  key: Key(item.id),
                  direction: DismissDirection.horizontal,
                  onDismissed: (direction) {
                    setState(() {
                      _items.removeAt(index);
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${item.title} dismissed'),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () {
                            setState(() {
                              _items.insert(index, item);
                            });
                          },
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  background: _buildDismissBackground(
                    alignment: Alignment.centerLeft,
                    color: Colors.green,
                    icon: Icons.archive,
                    label: 'Archive',
                  ),
                  secondaryBackground: _buildDismissBackground(
                    alignment: Alignment.centerRight,
                    color: Colors.red,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.endToStart) {
                      return await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete notification?'),
                          content: Text('Delete "${item.title}"?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );
                    }

                    return true;
                  },
                  child: _buildNotificationCard(item),
                );
              },
            ),
    );
  }

  Widget _buildDismissBackground({
    required AlignmentGeometry alignment,
    required Color color,
    required IconData icon,
    required String label,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(_NotificationItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: item.color.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: item.color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(item.icon, color: item.color, size: 24),
        ),
        title: Text(
          item.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Text(
          item.body,
          style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
        ),
        trailing: Icon(Icons.swipe, color: Colors.grey.shade300, size: 20),
      ),
    );
  }
}

class _NotificationItem {
  final String id;
  final String title;
  final String body;
  final IconData icon;
  final Color color;

  const _NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.icon,
    required this.color,
  });
}
