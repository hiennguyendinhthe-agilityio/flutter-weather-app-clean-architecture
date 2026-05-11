import 'package:flutter/material.dart';
import '../theme/theme_context_ext.dart';
import '../widgets/sales_kpi/sales_donut_chart.dart';
import '../widgets/sales_kpi/sales_kpi_card.dart';
import '../widgets/sales_kpi/sales_time_filter.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SalesKpisScreen — Refactored (Theming + Performance)
//
// 1. THEME: Removed FitnessColors. Uses context.fitnessTheme.
// 2. STATE: Replaced setState with ValueNotifier for filter selection.
// 3. PERFORMANCE: Isolated rebuilds using ValueListenableBuilder.
//    RepaintBoundary around animated donut chart.
// ─────────────────────────────────────────────────────────────────────────────

class SalesKpiData {
  final double percentage;
  final String amountString;
  final String offlineAmount;
  final String offlinePercent;
  final String onlineAmount;
  final String onlinePercent;

  SalesKpiData({
    required this.percentage,
    required this.amountString,
    required this.offlineAmount,
    required this.offlinePercent,
    required this.onlineAmount,
    required this.onlinePercent,
  });
}

class SalesKpisScreen extends StatefulWidget {
  const SalesKpisScreen({super.key});

  @override
  State<SalesKpisScreen> createState() => _SalesKpisScreenState();
}

class _SalesKpisScreenState extends State<SalesKpisScreen> {
  late final ValueNotifier<String> _filterNotifier;

  final List<String> _filters = ['24H', '7D', '14D', '30D'];

  final Map<String, SalesKpiData> _data = {
    '30D': SalesKpiData(
      percentage: 0.76,
      amountString: '\$ 12 245 / 15 400',
      offlineAmount: '\$ 6 984',
      offlinePercent: '58%',
      onlineAmount: '\$ 5 434',
      onlinePercent: '42%',
    ),
    '14D': SalesKpiData(
      percentage: 0.45,
      amountString: '\$ 6 930 / 15 400',
      offlineAmount: '\$ 4 158',
      offlinePercent: '60%',
      onlineAmount: '\$ 2 772',
      onlinePercent: '40%',
    ),
    '7D': SalesKpiData(
      percentage: 0.22,
      amountString: '\$ 3 388 / 15 400',
      offlineAmount: '\$ 1 694',
      offlinePercent: '50%',
      onlineAmount: '\$ 1 694',
      onlinePercent: '50%',
    ),
    '24H': SalesKpiData(
      percentage: 0.04,
      amountString: '\$ 616 / 15 400',
      offlineAmount: '\$ 400',
      offlinePercent: '65%',
      onlineAmount: '\$ 216',
      onlinePercent: '35%',
    ),
  };

  @override
  void initState() {
    super.initState();
    _filterNotifier = ValueNotifier<String>('30D');
  }

  @override
  void dispose() {
    _filterNotifier.dispose();
    super.dispose();
  }

  void _onFilterChanged(String filter) {
    if (_filterNotifier.value != filter) {
      _filterNotifier.value = filter;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ft = context.fitnessTheme;

    return Scaffold(
      backgroundColor: ft.scaffoldBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month, size: 22),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: ValueListenableBuilder<String>(
          valueListenable: _filterNotifier,
          builder: (context, selectedFilter, _) {
            final currentData = _data[selectedFilter]!;

            return Column(
              children: [
                // ── Header Section (Static) ───────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sales KPIs',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: ft.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            'Achievements of goals',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: ft.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: ft.cardBackground,
                          shape: BoxShape.circle,
                          border: Border.all(color: ft.cardBorder),
                        ),
                        child: Icon(
                          Icons.more_vert,
                          color: ft.textPrimary,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40.0),

                // ── Donut Chart (Reactive + Optimized) ────────────────────
                RepaintBoundary(
                  child: SalesKpiDonutChart(
                    percentage: currentData.percentage,
                    amountString: currentData.amountString,
                  ),
                ),

                const Spacer(),

                // ── Time Filter (Reactive) ────────────────────────────────
                SalesTimeFilterBar(
                  filters: _filters,
                  selectedFilter: selectedFilter,
                  onFilterSelected: _onFilterChanged,
                ),

                // ── KPI Cards (Reactive) ──────────────────────────────────
                Padding(
                  padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: SalesKpiCard(
                          icon: Icons.storefront,
                          title: 'Offline sales',
                          amount: currentData.offlineAmount,
                          percentage: currentData.offlinePercent,
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: SalesKpiCard(
                          icon: Icons.web,
                          title: 'Online sales',
                          amount: currentData.onlineAmount,
                          percentage: currentData.onlinePercent,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
