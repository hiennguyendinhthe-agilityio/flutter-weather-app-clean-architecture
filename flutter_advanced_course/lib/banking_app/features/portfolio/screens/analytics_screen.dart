import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/banking_app/core/constants/app_colors.dart';

// ════════════════════════════════════════════════
// SPENDING BAR CHART – CustomPainter + Animation
// ════════════════════════════════════════════════
class SpendingBarChart extends StatefulWidget {
  final List<ChartData> data;

  const SpendingBarChart({super.key, required this.data});

  @override
  State<SpendingBarChart> createState() => _SpendingBarChartState();
}

class _SpendingBarChartState extends State<SpendingBarChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _ctrl
      ..addListener(() => setState(() {}))
      ..forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 180,
          child: CustomPaint(
            painter: _BarPainter(
              data: widget.data,
              animValue: _anim.value,
              isDark: isDark,
            ),
            size: Size.infinite,
          ),
        ),
        const SizedBox(height: 16),
        // Legend
        Wrap(
          spacing: 12,
          runSpacing: 6,
          children: widget.data.map((d) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: d.color,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  '${d.label} (\$${d.amount.toStringAsFixed(0)})',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.white54 : AppColors.grey600,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}

class ChartData {
  final String label;
  final double amount;
  final Color color;
  const ChartData(this.label, this.amount, this.color);
}

class _BarPainter extends CustomPainter {
  final List<ChartData> data;
  final double animValue;
  final bool isDark;

  const _BarPainter({
    required this.data,
    required this.animValue,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final maxAmt = data.map((d) => d.amount).reduce(max);
    final totalBars = data.length;
    // Gap between bars = barWidth * 0.4
    final barWidth = size.width / (totalBars + (totalBars - 1) * 0.4);
    final gap = barWidth * 0.4;
    final maxBarH = size.height * 0.75;
    final baseY = size.height * 0.82;

    // Grid
    final gridPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05)
      ..strokeWidth = 1;

    for (int g = 0; g <= 4; g++) {
      final y = size.height * 0.06 + maxBarH * g / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    for (int i = 0; i < data.length; i++) {
      final d = data[i];
      final barH = (d.amount / maxAmt) * maxBarH * animValue;
      final left = i * (barWidth + gap);

      final rRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, baseY - barH, barWidth, barH),
        const Radius.circular(6),
      );

      // Bar gradient
      canvas.drawRRect(
        rRect,
        Paint()
          ..shader = LinearGradient(
            colors: [d.color, d.color.withValues(alpha: 0.5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(rRect.outerRect),
      );

      // Amount label (fade in after 80% animation)
      if (animValue > 0.8) {
        final opacity = ((animValue - 0.8) * 5).clamp(0.0, 1.0);
        final amtPainter = TextPainter(
          text: TextSpan(
            text: '\$${d.amount.toStringAsFixed(0)}',
            style: TextStyle(
              color: d.color.withValues(alpha: opacity),
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        amtPainter.paint(
          canvas,
          Offset(
            left + (barWidth - amtPainter.width) / 2,
            baseY - barH - amtPainter.height - 4,
          ),
        );
      }

      // X label
      final lblPainter = TextPainter(
        text: TextSpan(
          text: d.label,
          style: TextStyle(
            color: (isDark ? Colors.white : Colors.black).withValues(
              alpha: 0.4,
            ),
            fontSize: 10,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      lblPainter.paint(
        canvas,
        Offset(left + (barWidth - lblPainter.width) / 2, baseY + 6),
      );
    }
  }

  @override
  bool shouldRepaint(_BarPainter old) =>
      old.animValue != animValue || old.isDark != isDark;
}

// ════════════════════════════════════════════════
// ANALYTICS SCREEN
// ════════════════════════════════════════════════
class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  static const _chartData = [
    ChartData('Food', 320, AppColors.error),
    ChartData('Shop', 480, AppColors.primary),
    ChartData('Trans', 180, AppColors.accent),
    ChartData('Health', 215, Color(0xFF4CAF50)),
    ChartData('Entmt', 156, AppColors.warning),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
          title: Text(
            'Analytics',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.grey900,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary row
                const Row(
                  children: [
                    _SummaryCard(
                      label: 'Total Spent',
                      value: '\$1,351',
                      color: AppColors.expense,
                      icon: Icons.arrow_upward_rounded,
                    ),
                    SizedBox(width: 12),
                    _SummaryCard(
                      label: 'Saved',
                      value: '\$5,258',
                      color: AppColors.income,
                      icon: Icons.arrow_downward_rounded,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Chart card
                Text(
                  'Spending by Category',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.grey900,
                  ),
                ),

                const SizedBox(height: 14),

                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: const SpendingBarChart(data: _chartData),
                ),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    label,
                    style: TextStyle(
                      color: isDark ? Colors.white54 : AppColors.grey600,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
