import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/chart_demo/core/account_stats_theme.dart';

// ─────────────────────────────────────────────────────────────
// CHART LEGEND — glassmorphic capsule + coloured dot + label pairs
// ─────────────────────────────────────────────────────────────

class ChartLegend extends StatelessWidget {
  const ChartLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: BackdropFilter(
        // Frosted-glass blur behind the capsule.
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            // Semi-transparent white overlay creates the frosted look.
            color: AccountStatsTheme.legendCapsuleBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AccountStatsTheme.legendCapsuleBorder,
              width: 0.8,
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _LegendItem(
                color: AccountStatsTheme.followersColor,
                label: 'Followers',
              ),
              SizedBox(width: 14),
              _LegendItem(
                // Use the solid mid-tone for the legend dot; the actual bar
                // uses clicksBarColor which is semi-transparent.
                color: Color(0xFF5A5880),
                label: 'Clicks',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// SINGLE LEGEND ITEM
// ─────────────────────────────────────────────────────────────

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: AccountStatsTheme.legendDotSize,
          height: AccountStatsTheme.legendDotSize,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AccountStatsTheme.secondaryText,
            fontFamily: 'SF Pro Display',
          ),
        ),
      ],
    );
  }
}
