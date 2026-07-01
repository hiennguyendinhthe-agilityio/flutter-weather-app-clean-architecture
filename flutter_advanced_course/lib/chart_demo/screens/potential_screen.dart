import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/chart_demo/models/bar_item_data.dart';
import 'package:flutter_advanced_course/chart_demo/widgets/bar_chart/bar_chart.dart';

const _kMaxValue = 100.0;

const _kInitialData = [
  BarItemData(
    label: 'T1',
    value: 55,
    secondaryValue: 15,
    maxValue: _kMaxValue,
    color: Color(0xFF6C63FF),
    valueLabel: '55%',
  ),
  BarItemData(
    label: 'T2',
    value: 62,
    secondaryValue: 12,
    maxValue: _kMaxValue,
    color: Color(0xFF6C63FF),
    valueLabel: '62%',
  ),
  BarItemData(
    label: 'T3',
    value: 48,
    secondaryValue: 20,
    maxValue: _kMaxValue,
    color: Color(0xFF6C63FF),
    valueLabel: '48%',
  ),
  BarItemData(
    label: 'T4',
    value: 75,
    secondaryValue: 10,
    maxValue: _kMaxValue,
    color: Color(0xFF6C63FF),
    valueLabel: '75%',
  ),
  BarItemData(
    label: 'T5',
    value: 83,
    secondaryValue: 8,
    maxValue: _kMaxValue,
    color: Color(0xFF6C63FF),
    valueLabel: '83%',
  ),
  BarItemData(
    label: 'T6',
    value: 91,
    secondaryValue: 6,
    maxValue: _kMaxValue,
    color: Color(0xFF6C63FF),
    valueLabel: '91%',
  ),
];

class PotentialScreen extends StatefulWidget {
  const PotentialScreen({super.key});

  @override
  State<PotentialScreen> createState() => _PotentialScreenState();
}

class _PotentialScreenState extends State<PotentialScreen> {
  List<BarItemData> _items = _kInitialData;
  final _random = Random();

  Key _chartKey = UniqueKey();

  void _onShuffle() {
    final newItems = List.generate(6, (i) {
      final primary = 30 + _random.nextInt(60);
      final secondary = 5 + _random.nextInt(15);
      return BarItemData(
        label: 'T${i + 1}',
        value: primary.toDouble(),
        secondaryValue: secondary.toDouble(),
        maxValue: _kMaxValue,
        color: const Color(0xFF6C63FF),
        valueLabel: '$primary%',
      );
    });

    setState(() {
      _items = newItems;
      _chartKey = UniqueKey();
    });
  }

  void _onReset() {
    setState(() {
      _items = _kInitialData;
      _chartKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              _buildHeader(),
              const SizedBox(height: 28),
              _buildSummaryCards(),
              const SizedBox(height: 28),
              _buildChartCard(),
              const SizedBox(height: 20),
              _buildActionButtons(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Growth potential',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Vietnamese stocks • Q2 2025',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  Widget _buildSummaryCards() {
    final values = _items.map((e) => e.value).toList();
    final avg = values.fold(0.0, (a, b) => a + b) / values.length;
    final peak = values.reduce(max);
    final lastMonth = values.last;
    final prevMonth = values.length > 1 ? values[values.length - 2] : 0.0;
    final growth = lastMonth - prevMonth;

    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            label: 'Medium',
            value: '${avg.toStringAsFixed(0)}%',
            icon: Icons.trending_up_rounded,
            color: const Color(0xFF00C6AE),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            label: 'The highest peak',
            value: '${peak.toStringAsFixed(0)}%',
            icon: Icons.emoji_events_rounded,
            color: const Color(0xFFFFB347),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            label: 'Growth',
            value: '${growth >= 0 ? '+' : ''}${growth.toStringAsFixed(0)}%',
            icon: growth >= 0
                ? Icons.arrow_upward_rounded
                : Icons.arrow_downward_rounded,
            color: growth >= 0
                ? const Color(0xFF6C63FF)
                : const Color(0xFFFF6584),
          ),
        ),
      ],
    );
  }

  Widget _buildChartCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Performance by month',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),

              Row(
                children: [
                  const _LegendDot(color: Color(0xFF6C63FF), label: 'Reality'),
                  const SizedBox(width: 12),
                  _LegendDot(
                    color: const Color(0xFF6C63FF).withValues(alpha: 0.35),
                    label: 'Target',
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const _YAxisLabels(maxValue: _kMaxValue),
              const SizedBox(width: 12),

              Expanded(
                child: BarChart(
                  key: _chartKey,
                  items: _items,
                  maxHeight: 180,
                  columnWidth: 32,
                  columnSpacing: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: FilledButton.icon(
            onPressed: _onShuffle,
            icon: const Icon(Icons.shuffle_rounded, size: 18),
            label: const Text('Update data'),
            style: FilledButton.styleFrom(
              backgroundColor: scheme.primary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: OutlinedButton.icon(
            onPressed: _onReset,
            icon: const Icon(Icons.restart_alt_rounded, size: 18),
            label: const Text('Reset'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              side: BorderSide(color: scheme.primary.withValues(alpha: 0.4)),
            ),
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.grey.shade900,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
        ),
      ],
    );
  }
}

class _YAxisLabels extends StatelessWidget {
  const _YAxisLabels({required this.maxValue});

  final double maxValue;

  @override
  Widget build(BuildContext context) {
    const levels = [100, 75, 50, 25, 0];
    return SizedBox(
      height: 180,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: levels
            .map(
              (v) => Text(
                '$v%',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
