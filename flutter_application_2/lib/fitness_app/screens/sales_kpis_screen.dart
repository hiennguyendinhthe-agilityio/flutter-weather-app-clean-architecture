import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../widgets/sales_kpi/sales_donut_chart.dart';
import '../widgets/sales_kpi/sales_kpi_card.dart';
import '../widgets/sales_kpi/sales_time_filter.dart';

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
  String _selectedFilter = '30D';
  final List<String> _filters = ['24H', '7D', '14D', '30D'];

  // Mock data for different timeframes
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

  void _onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentData = _data[_selectedFilter]!;

    return Scaffold(
      backgroundColor: FitnessColors.salesBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month, color: Colors.white, size: 22),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Sales KPIs',
                        style: FitnessTextStyles.salesHeaderTitle,
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        'Achievements of goals',
                        style: FitnessTextStyles.salesHeaderSubtitle,
                      ),
                    ],
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: FitnessColors.salesCardBackground,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40.0),

            // Donut Chart
            SalesKpiDonutChart(
              percentage: currentData.percentage,
              amountString: currentData.amountString,
            ),

            const Spacer(),

            // Time Filter
            SalesTimeFilterBar(
              filters: _filters,
              selectedFilter: _selectedFilter,
              onFilterSelected: _onFilterChanged,
            ),

            // KPI Cards
            Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
              child: Row(
                children: [
                  SalesKpiCard(
                    icon: Icons.storefront,
                    title: 'Offline sales',
                    amount: currentData.offlineAmount,
                    percentage: currentData.offlinePercent,
                  ),
                  const SizedBox(width: 16.0),
                  SalesKpiCard(
                    icon: Icons.web,
                    title: 'Online sales',
                    amount: currentData.onlineAmount,
                    percentage: currentData.onlinePercent,
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
