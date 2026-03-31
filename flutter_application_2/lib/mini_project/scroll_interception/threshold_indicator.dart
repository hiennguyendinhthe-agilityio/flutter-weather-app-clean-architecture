import 'package:flutter/material.dart';
import 'package:flutter_application_2/mini_project/scroll_interception/scroll_debug_info.dart';

class ThresholdIndicator extends StatelessWidget {
  final bool showButton;
  final double threshold;
  final ValueNotifier<ScrollDebugInfo> debugInfo;

  const ThresholdIndicator({
    super.key,
    required this.showButton,
    required this.threshold,
    required this.debugInfo,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ScrollDebugInfo>(
      valueListenable: debugInfo,
      builder: (context, info, _) {
        final remaining = (threshold - info.pixels).clamp(0.0, threshold);

        final progress = (info.pixels / threshold).clamp(0.0, 1.0);

        return Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: showButton ? Colors.green.shade50 : Colors.orange.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: showButton
                  ? Colors.green.shade200
                  : Colors.orange.shade200,
            ),
          ),
          child: Column(
            children: [
              // Status row
              Row(
                children: [
                  Icon(
                    showButton
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: showButton ? Colors.green : Colors.orange,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      showButton
                          ? '✅ Back to Top button VISIBLE\n'
                                '(pixels > ${threshold.toInt()}px)'
                          : '⏳ Scroll ${remaining.toStringAsFixed(0)}px more to show button\n'
                                '(threshold: ${threshold.toInt()}px)',
                      style: TextStyle(
                        color: showButton
                            ? Colors.green.shade700
                            : Colors.orange.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Progress bar đến threshold
              Row(
                children: [
                  Text(
                    '0px',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 10),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Stack(
                        children: [
                          // Background
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                showButton ? Colors.green : Colors.orange,
                              ),
                              minHeight: 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    '${threshold.toInt()}px',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 10),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // AC4 note
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.flash_on, size: 13, color: Color(0xFF6C63FF)),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'AC4: ValueNotifier → Chỉ rebuild FAB, KHÔNG rebuild ScrollView',
                        style: TextStyle(
                          color: Color(0xFF6C63FF),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
