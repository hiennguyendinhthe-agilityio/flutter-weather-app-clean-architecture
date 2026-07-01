import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/chart_demo/models/donut_slice_data.dart';
import 'package:flutter_advanced_course/chart_demo/widgets/donut_chart/donut_chart.dart';

const _kInitialSlices = [
  DonutSliceData(
    label: 'VNM',
    value: 32,
    color: Color(0xFF6C63FF),
    metadata: '₫32,400,000',
  ),
  DonutSliceData(
    label: 'FPT',
    value: 28,
    color: Color(0xFF00C6AE),
    metadata: '₫28,150,000',
  ),
  DonutSliceData(
    label: 'MWG',
    value: 20,
    color: Color(0xFFFF6584),
    metadata: '₫20,800,000',
  ),
  DonutSliceData(
    label: 'HPG',
    value: 12,
    color: Color(0xFFFFB347),
    metadata: '₫12,300,000',
  ),
  DonutSliceData(
    label: 'VIC',
    value: 8,
    color: Color(0xFF4ECDC4),
    metadata: '₫8,900,000',
  ),
  DonutSliceData(
    label: 'VTC',
    value: 5,
    color: Color(0xFFB6B6B6),
    metadata: '₫5,500,000',
  ),
  DonutSliceData(
    label: 'VIB',
    value: 3,
    color: Color(0xFF4ECDC4),
    metadata: '₫3,300,000',
  ),
  DonutSliceData(
    label: 'VIB',
    value: 3,
    color: Color(0xFF4ECDC4),
    metadata: '₫3,300,000',
  ),
];

const _kTotalAssets = '₫102,550,000';

const _kRandomDatasets = [
  [
    DonutSliceData(
      label: 'VNM',
      value: 45,
      color: Color(0xFF6C63FF),
      metadata: '₫46,100,000',
    ),
    DonutSliceData(
      label: 'FPT',
      value: 15,
      color: Color(0xFF00C6AE),
      metadata: '₫15,400,000',
    ),
    DonutSliceData(
      label: 'MWG',
      value: 25,
      color: Color(0xFFFF6584),
      metadata: '₫25,600,000',
    ),
    DonutSliceData(
      label: 'HPG',
      value: 10,
      color: Color(0xFFFFB347),
      metadata: '₫10,250,000',
    ),
    DonutSliceData(
      label: 'VIC',
      value: 5,
      color: Color(0xFF4ECDC4),
      metadata: '₫5,120,000',
    ),
  ],
  [
    DonutSliceData(
      label: 'VNM',
      value: 18,
      color: Color(0xFF6C63FF),
      metadata: '₫18,400,000',
    ),
    DonutSliceData(
      label: 'FPT',
      value: 40,
      color: Color(0xFF00C6AE),
      metadata: '₫41,000,000',
    ),
    DonutSliceData(
      label: 'MWG',
      value: 22,
      color: Color(0xFFFF6584),
      metadata: '₫22,500,000',
    ),
    DonutSliceData(
      label: 'HPG',
      value: 14,
      color: Color(0xFFFFB347),
      metadata: '₫14,300,000',
    ),
    DonutSliceData(
      label: 'VIC',
      value: 6,
      color: Color(0xFF4ECDC4),
      metadata: '₫6,150,000',
    ),
  ],
  [
    DonutSliceData(
      label: 'VNM',
      value: 10,
      color: Color(0xFF6C63FF),
      metadata: '₫10,250,000',
    ),
    DonutSliceData(
      label: 'FPT',
      value: 22,
      color: Color(0xFF00C6AE),
      metadata: '₫22,500,000',
    ),
    DonutSliceData(
      label: 'MWG',
      value: 38,
      color: Color(0xFFFF6584),
      metadata: '₫38,900,000',
    ),
    DonutSliceData(
      label: 'HPG',
      value: 20,
      color: Color(0xFFFFB347),
      metadata: '₫20,480,000',
    ),
    DonutSliceData(
      label: 'VIC',
      value: 10,
      color: Color(0xFF4ECDC4),
      metadata: '₫10,250,000',
    ),
  ],
];

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  List<DonutSliceData> _slices = _kInitialSlices;
  int? _selectedIndex;
  int _datasetIndex = 0;

  String get _displayTotal {
    if (_selectedIndex != null) {
      return _slices[_selectedIndex!].metadata ?? _kTotalAssets;
    }
    return _kTotalAssets;
  }

  String get _displayLabel {
    if (_selectedIndex != null) {
      return _slices[_selectedIndex!].label;
    }
    return 'Total assets';
  }

  double get _selectedPercent {
    if (_selectedIndex == null) return 0;
    final total = _slices.fold(0.0, (s, e) => s + e.value);
    return (_slices[_selectedIndex!].value / total) * 100;
  }

  void _onRandomize() {
    _datasetIndex = (_datasetIndex + 1) % _kRandomDatasets.length;

    setState(() {
      _slices = _kRandomDatasets[_datasetIndex];
      _selectedIndex = null;
    });
  }

  void _onReset() {
    setState(() {
      _slices = _kInitialSlices;
      _selectedIndex = null;
      _datasetIndex = 0;
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
              const SizedBox(height: 32),
              _buildChartSection(),
              const SizedBox(height: 28),
              _buildLegend(),
              const SizedBox(height: 28),
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
          'Investment portfolio',
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
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildChartSection() {
    return Center(
      child: DonutChart(
        slices: _slices,
        dimension: 260,
        selectedIndex: _selectedIndex,
        onSliceSelected: (index) {
          setState(() => _selectedIndex = index);
        },

        centerBuilder: (selectedIndex) => _DonutCenterWidget(
          totalLabel: _displayLabel,
          totalValue: _displayTotal,
          percent: selectedIndex != null ? _selectedPercent : null,
          accentColor: selectedIndex != null
              ? _slices[selectedIndex].color
              : const Color(0xFF6C63FF),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    final total = _slices.fold(0.0, (s, e) => s + e.value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Legend',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 12),

        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Column(
            key: ValueKey(_slices.hashCode),
            children: _slices.indexed.map((record) {
              final (i, slice) = record;
              final pct = (slice.value / total * 100);
              final isSelected = _selectedIndex == i;
              return _LegendItem(
                slice: slice,
                percent: pct,
                isSelected: isSelected,
                isAnySelected: _selectedIndex != null,
                onTap: () {
                  setState(() {
                    _selectedIndex = isSelected ? null : i;
                  });
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: FilledButton.icon(
            onPressed: _onRandomize,
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

class _DonutCenterWidget extends StatelessWidget {
  const _DonutCenterWidget({
    required this.totalLabel,
    required this.totalValue,
    this.percent,
    required this.accentColor,
  });

  final String totalLabel;
  final String totalValue;
  final double? percent;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          totalLabel,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade500,
            letterSpacing: 0.3,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),

        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            totalValue,
            style: TextStyle(
              fontSize: percent != null ? 16 : 18,
              fontWeight: FontWeight.w800,
              color: Colors.grey.shade900,
              letterSpacing: -0.5,
            ),
            maxLines: 1,
          ),
        ),

        if (percent != null) ...[
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${percent!.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: accentColor,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.slice,
    required this.percent,
    required this.isSelected,
    required this.isAnySelected,
    required this.onTap,
  });

  final DonutSliceData slice;
  final double percent;
  final bool isSelected;
  final bool isAnySelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final opacity = isAnySelected && !isSelected ? 0.4 : 1.0;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedOpacity(
        opacity: opacity,
        duration: const Duration(milliseconds: 200),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? slice.color.withValues(alpha: 0.08)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? slice.color.withValues(alpha: 0.4)
                  : Colors.grey.shade100,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: slice.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  slice.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),

              if (slice.metadata != null)
                Text(
                  slice.metadata!,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              const SizedBox(width: 8),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: slice.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${percent.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: slice.color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
