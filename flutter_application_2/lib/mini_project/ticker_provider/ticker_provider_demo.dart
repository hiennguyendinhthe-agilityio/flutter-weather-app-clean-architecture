import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class TickerProviderDemo extends StatefulWidget {
  const TickerProviderDemo({super.key});

  @override
  State<TickerProviderDemo> createState() => _TickerProviderDemoState();
}

class _TickerProviderDemoState extends State<TickerProviderDemo>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  Ticker? _customTicker;
  int _customTickCount = 0;
  Duration _customElapsed = Duration.zero;

  final ValueNotifier<FrameInfo> _frameInfo = ValueNotifier(FrameInfo.empty());

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.addListener(() {
      _frameInfo.value = FrameInfo(
        value: _controller.value,
        status: _controller.status.name,
        isAnimating: _controller.isAnimating,
        velocity: _controller.velocity,
      );
    });

    _customTicker = createTicker((elapsed) {
      setState(() {
        _customTickCount++;
        _customElapsed = elapsed;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _customTicker?.dispose();
    _frameInfo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5E5E5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildTickerExplanation(),
              const SizedBox(height: 16),
              _buildSingleTickerDemo(),
              const SizedBox(height: 16),
              _buildWhileLoopComparison(),
              const SizedBox(height: 16),
              _buildLiveDemo(),
              const SizedBox(height: 16),
              _buildCustomTickerDemo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1A2E), Color(0xFF6C63FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.timer, color: Colors.white, size: 28),
              SizedBox(width: 10),
              Text(
                'Ticker & SchedulerBinding',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Understand how Flutter sync animation with 60Hz/120Hz screen',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // ── AC1: Ticker Explanation ──────────────────
  Widget _buildTickerExplanation() {
    return _buildCard(
      title: 'AC1 – Ticker Source Code',
      color: const Color(0xFF6C63FF),
      child: Column(
        children: [
          _buildInfoRow(
            icon: Icons.timer_outlined,
            title: 'Ticker._tick(Duration timeStamp)',
            description: 'Called by SchedulerBinding each frame.\n'
                'Calculate elapsed = timeStamp - startTime\n'
                'Call _onTick(elapsed) → AnimationController update',
            color: const Color(0xFF6C63FF),
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.schedule,
            title: 'SchedulerBinding.scheduleFrameCallback()',
            description: 'Register callback to run in next frame.\n'
                'Engine (C++) calls _handleBeginFrame() when GPU ready.\n'
                'All Ticker callbacks run in phase transientCallbacks.',
            color: const Color(0xFFFF6B6B),
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.screen_rotation,
            title: 'Frame Rate (60Hz vs 120Hz)',
            description: '60Hz: Frame each 16.67ms\n'
                '120Hz: Frame each 8.33ms\n'
                'Ticker auto adapt → Animation still smooth',
            color: const Color(0xFF00BFA5),
          ),
        ],
      ),
    );
  }

  // ── AC2: SingleTickerProvider ────────────────
  Widget _buildSingleTickerDemo() {
    return _buildCard(
      title: 'AC2 – SingleTickerProviderStateMixin',
      color: const Color(0xFF00BFA5),
      child: Column(
        children: [
          _buildInfoRow(
            icon: Icons.build,
            title: 'createTicker(onTick) → Ticker',
            description: 'AnimationController call vsync.createTicker().\n'
                'SingleTickerProviderStateMixin creates Ticker.\n'
                'Ticker attach to lifecycle of State.',
            color: const Color(0xFF00BFA5),
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.battery_saver,
            title: 'Ticker.muted when app background',
            description: 'TickerMode.of(context) = false when background.\n'
                'didChangeDependencies() update Ticker.muted.\n'
                '→ Ticker stop → Save battery/CPU.',
            color: const Color(0xFFFFB300),
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.warning_amber,
            title: 'dispose() clesans up Ticker',
            description: 'If AnimationController is not disposed:\n'
                '→ SingleTickerProviderStateMixin warns in debug\n'
                '→ "AnimationController was not disposed"',
            color: const Color(0xFFFF6B6B),
          ),
        ],
      ),
    );
  }

  // ── AC3: while loop vs AnimationController ───
  Widget _buildWhileLoopComparison() {
    return _buildCard(
      title: 'AC3 – while loop vs AnimationController',
      color: const Color(0xFFFF6B6B),
      child: Column(
        children: [
          // BAD: while loop
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.block, color: Colors.red.shade600, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'BAD: while loop',
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A2E),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'while (value < 1.0) {\n'
                    '  value += 0.01;\n'
                    '  // UI không update!\n'
                    '  // Thread block!\n'
                    '}',
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '❌ Main thread block\n'
                  '❌ No frame render\n'
                  '❌ User tap no handle\n'
                  '❌ App freeze completely',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontSize: 12,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // GOOD: AnimationController
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green.shade600,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'GOOD: AnimationController',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A2E),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '_controller.forward();\n'
                    '// RETURN now!\n'
                    '// Ticker register frame callback\n'
                    '// Thread released',
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '✅ Main thread free immediately\n'
                  '✅ 60 frames/second render smoothly\n'
                  '✅ User tap processed normally\n'
                  '✅ Cooperative multitasking works',
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontSize: 12,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Live Animation Demo ──────────────────────
  Widget _buildLiveDemo() {
    return _buildCard(
      title: 'Live – AnimationController Demo',
      color: const Color(0xFFFFB300),
      child: Column(
        children: [
          // Animation value display
          ValueListenableBuilder<FrameInfo>(
            valueListenable: _frameInfo,
            builder: (context, info, child) {
              return Column(
                children: [
                  // Animated bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return LinearProgressIndicator(
                          value: _animation.value,
                          minHeight: 16,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color.lerp(
                              const Color(0xFF6C63FF),
                              const Color(0xFF00BFA5),
                              _animation.value,
                            )!,
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Frame info grid
                  Row(
                    children: [
                      _buildMetricBox(
                        'value',
                        info.value.toStringAsFixed(4),
                        const Color(0xFF6C63FF),
                      ),
                      const SizedBox(width: 8),
                      _buildMetricBox(
                        'status',
                        info.status,
                        const Color(0xFF00BFA5),
                      ),
                      const SizedBox(width: 8),
                      _buildMetricBox(
                        'velocity',
                        info.velocity.toStringAsFixed(2),
                        const Color(0xFFFFB300),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 16),

          // Control buttons
          Row(
            children: [
              Expanded(
                child: _buildButton(
                  '▶ Forward',
                  const Color(0xFF6C63FF),
                  () => _controller.forward(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildButton(
                  '◀ Reverse',
                  const Color(0xFFFF6B6B),
                  () => _controller.reverse(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildButton(
                  '🔁 Repeat',
                  const Color(0xFF00BFA5),
                  () => _controller.repeat(reverse: true),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildButton(
                  '⏹ Stop',
                  Colors.grey,
                  () => _controller.stop(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Custom Ticker Demo ───────────────────────
  Widget _buildCustomTickerDemo() {
    return _buildCard(
      title: 'Custom Ticker',
      color: const Color(0xFF26C6DA),
      child: Column(
        children: [
          Text(
            'Ticker callback called every frame.\n'
            'Click button to start ticker',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildMetricBox(
                'tick count',
                _customTickCount.toString(),
                const Color(0xFF26C6DA),
              ),
              const SizedBox(width: 8),
              _buildMetricBox(
                'elapsed',
                '${_customElapsed.inMilliseconds}ms',
                const Color(0xFF6C63FF),
              ),
              const SizedBox(width: 8),
              _buildMetricBox(
                'fps (est)',
                _customElapsed.inMilliseconds > 0
                    ? (_customTickCount / _customElapsed.inMilliseconds * 1000)
                        .toStringAsFixed(0)
                    : '0',
                const Color(0xFF00BFA5),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildButton(
                  '▶ Start Ticker',
                  const Color(0xFF26C6DA),
                  () {
                    if (!(_customTicker?.isActive ?? false)) {
                      setState(() {
                        _customTickCount = 0;
                        _customElapsed = Duration.zero;
                      });
                      _customTicker?.start();
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildButton(
                  '⏹ Stop Ticker',
                  Colors.grey,
                  () => _customTicker?.stop(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '// Custom Ticker created using:\n'
              '_customTicker = createTicker((elapsed) {\n'
              '  // elapsed = Duration from start()\n'
              '  // Called each frame (60/120 times/second)\n'
              '  setState(() {\n'
              '    _customTickCount++;\n'
              '    _customElapsed = elapsed;\n'
              '  });\n'
              '});',
              style: TextStyle(
                color: Colors.greenAccent,
                fontSize: 11,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Helper Widgets ───────────────────────────

  Widget _buildCard({
    required String title,
    required Color color,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  fontFamily: 'monospace',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricBox(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                fontFamily: 'monospace',
              ),
            ),
            Text(
              label,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class FrameInfo {
  final double value;
  final String status;
  final bool isAnimating;
  final double velocity;

  const FrameInfo({
    required this.value,
    required this.status,
    required this.isAnimating,
    required this.velocity,
  });

  factory FrameInfo.empty() => const FrameInfo(
        value: 0,
        status: 'dismissed',
        isAnimating: false,
        velocity: 0,
      );
}
