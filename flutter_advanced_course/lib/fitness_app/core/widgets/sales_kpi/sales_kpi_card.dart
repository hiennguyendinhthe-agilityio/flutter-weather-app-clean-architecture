import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/theme_context_ext.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SalesKpiCard — Refactored
//
// Uses ColorScheme roles exclusively. No raw color literals.
// ─────────────────────────────────────────────────────────────────────────────

class SalesKpiCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String amount;
  final String percentage;

  const SalesKpiCard({
    super.key,
    required this.icon,
    required this.title,
    required this.amount,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.cs;
    final tt = context.tt;

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: cs.onSurfaceVariant, size: 24.0),
          const SizedBox(height: 16.0),
          Text(
            title,
            style: tt.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                amount,
                style: tt.titleMedium?.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(width: 4.0),
              Text(
                percentage,
                style: tt.labelMedium?.copyWith(color: cs.onSurfaceVariant),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
