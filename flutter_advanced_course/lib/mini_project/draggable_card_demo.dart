import 'package:flutter/material.dart';

class DraggableCardDemo extends StatefulWidget {
  const DraggableCardDemo({super.key});

  @override
  State<DraggableCardDemo> createState() => _DraggableCardDemoState();
}

class _DraggableCardDemoState extends State<DraggableCardDemo> {
  Offset _position = Offset.zero;

  Offset _startPosition = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5E5E5),
      appBar: AppBar(
        title: const Text('Draggable Card Demo'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          const Center(
            child: Text(
              'Draggable Card',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - 80 + _position.dx,
            top: MediaQuery.of(context).size.height / 2 - 60 + _position.dy,
            child: GestureDetector(
              onPanStart: (details) {
                _startPosition = _position;
              },
              onPanUpdate: (details) {
                setState(() {
                  _position += details.delta;
                });
              },
              onPanEnd: (details) {
                setState(() {
                  _position = _startPosition;
                });
              },
              child: _buildCard(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard() {
    return Container(
      width: 160,
      height: 120,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF00BFA5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.drag_indicator, size: 40, color: Colors.white),
          SizedBox(height: 10),
          Text('Push to move', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
