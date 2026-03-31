import 'package:flutter/material.dart';
import 'package:flutter_application_2/mini_project/scroll_interception/scroll_debug_info.dart';

class DebugPanel extends StatelessWidget {
  final ScrollDebugInfo info;

  const DebugPanel({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.monitor, color: Colors.greenAccent, size: 16),
              SizedBox(width: 8),
              Text(
                'NotificationListener Inspector',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          Text(
            'AC2: Scroll notifications captured in real-time',
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 11,
            ),
          ),

          const Divider(color: Colors.white12, height: 20),

          // Phase
          _buildRow('phase', info.phase, Colors.yellowAccent),

          // AC3: metrics.pixels
          _buildRow(
            'metrics.pixels',
            '${info.pixels.toStringAsFixed(1)}px',
            Colors.lightBlueAccent,
          ),

          _buildRow(
            'metrics.maxScrollExtent',
            '${info.maxExtent.toStringAsFixed(1)}px',
            Colors.greenAccent,
          ),

          _buildRow(
            'metrics.viewportDimension',
            '${info.viewportDimension.toStringAsFixed(1)}px',
            Colors.purpleAccent,
          ),

          _buildRow(
            'metrics.atEdge',
            info.atEdge.toString(),
            Colors.orangeAccent,
          ),

          _buildRow(
            'scrollDelta',
            '${info.scrollDelta.toStringAsFixed(2)}px/frame',
            Colors.pinkAccent,
          ),

          const SizedBox(height: 10),

          // Progress bar
          Row(
            children: [
              Text(
                'progress: ${(info.progress * 100).toStringAsFixed(1)}%',
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 11,
                  fontFamily: 'monospace',
                ),
              ),
              const Spacer(),
              Text(
                '${info.pixels.toStringAsFixed(0)} / '
                '${info.maxExtent.toStringAsFixed(0)} px',
                style: const TextStyle(color: Colors.white38, fontSize: 10),
              ),
            ],
          ),

          const SizedBox(height: 6),

          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: info.progress,
              backgroundColor: Colors.white12,
              valueColor: AlwaysStoppedAnimation<Color>(
                Color.lerp(
                  Colors.greenAccent,
                  Colors.redAccent,
                  info.progress,
                )!,
              ),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          SizedBox(
            width: 170,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 11,
                fontFamily: 'monospace',
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
