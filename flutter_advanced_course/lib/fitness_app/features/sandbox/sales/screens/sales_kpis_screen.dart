import 'package:flutter/material.dart';
import 'package:flutter_advanced_course/fitness_app/core/theme/theme_context_ext.dart';
import 'package:flutter_advanced_course/fitness_app/core/widgets/sales_kpi/sales_donut_chart.dart';
import 'package:flutter_advanced_course/fitness_app/core/widgets/sales_kpi/sales_kpi_card.dart';
import 'package:flutter_advanced_course/fitness_app/core/widgets/sales_kpi/sales_time_filter.dart';
import 'package:flutter_advanced_course/fitness_app/features/sandbox/sales/providers/sales_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SalesKpisScreen extends ConsumerWidget {
  const SalesKpisScreen({super.key});

  final List<String> _filters = const ['24H', '7D', '14D', '30D'];

  void _onFilterChanged(WidgetRef ref, String filter) {
    final currentFilter = ref.read(selectedSalesFilterProvider);
    if (currentFilter != filter) {
      ref.read(selectedSalesFilterProvider.notifier).setFilter(filter);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = context.cs;
    final tt = context.tt;

    return Scaffold(
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
        child: Builder(
          builder: (context) {
            final selectedFilter = ref.watch(selectedSalesFilterProvider);
            final currentData = ref.watch(currentSalesDataProvider);

            return Column(
              children: [
                // ── Header Section ────────────────────────────────────────
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
                            style: tt.titleLarge?.copyWith(
                              fontSize: 24,
                              color: cs.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            'Achievements of goals',
                            style: tt.bodySmall?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: cs.surface,
                          shape: BoxShape.circle,
                          border: Border.all(color: cs.outlineVariant),
                        ),
                        child: Icon(
                          Icons.more_vert,
                          color: cs.onSurface,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40.0),

                // ── Donut Chart ───────────────────────────────────────────
                RepaintBoundary(
                  child: SalesKpiDonutChart(
                    percentage: currentData.percentage,
                    amountString: currentData.amountString,
                  ),
                ),

                const Spacer(),

                // ── Time Filter ───────────────────────────────────────────
                SalesTimeFilterBar(
                  filters: _filters,
                  selectedFilter: selectedFilter,
                  onFilterSelected: (filter) => _onFilterChanged(ref, filter),
                ),

                // ── KPI Cards ─────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.only(
                    left: 24.0,
                    right: 24.0,
                    bottom: 24.0,
                  ),
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
