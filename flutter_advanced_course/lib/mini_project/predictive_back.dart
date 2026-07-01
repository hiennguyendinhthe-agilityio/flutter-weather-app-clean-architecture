import 'package:flutter/material.dart';

class PredictiveBackHomeScreen extends StatelessWidget {
  const PredictiveBackHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      appBar: AppBar(
        title: const Text('Predictive Back'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withValues(alpha: 0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.swipe_left,
                    size: 48,
                    color: Colors.deepPurple,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Predictive Back Gesture',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Swipe left to go back',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PredictiveBackDetailScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Open Detail Screen'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PredictiveBackDetailScreen extends StatefulWidget {
  const PredictiveBackDetailScreen({super.key});

  @override
  State<PredictiveBackDetailScreen> createState() =>
      _PredictiveBackDetailScreenState();
}

class _PredictiveBackDetailScreenState extends State<PredictiveBackDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  bool _isBackGesturing = false;

  double _backProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          debugPrint('Screen popped successfully');
        }
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final scale = _isBackGesturing ? 1.0 - (_backProgress * 0.08) : 1.0;

          final offsetX = _isBackGesturing ? _backProgress * 40 : 0.0;

          return Transform.translate(
            offset: Offset(offsetX, 0),
            child: Transform.scale(scale: scale, child: child),
          );
        },
        child: GestureDetector(
          onHorizontalDragStart: (details) {
            if (details.globalPosition.dx < 30) {
              setState(() => _isBackGesturing = true);
            }
          },
          onHorizontalDragUpdate: (details) {
            if (!_isBackGesturing) return;
            setState(() {
              _backProgress = (details.globalPosition.dx / 200).clamp(0.0, 1.0);
            });
          },
          onHorizontalDragEnd: (details) {
            if (!_isBackGesturing) return;

            if (_backProgress > 0.5) {
              Navigator.pop(context);
            } else {
              setState(() {
                _isBackGesturing = false;
                _backProgress = 0;
              });
            }
          },
          child: Scaffold(
            backgroundColor: Colors.deepPurple,
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'Detail Screen',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.touch_app,
                            size: 64,
                            color: Colors.white,
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Swipe left to go back',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              height: 1.4,
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
