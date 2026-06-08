import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sales_provider.g.dart';

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

final Map<String, SalesKpiData> _mockSalesData = {
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

@riverpod
class SelectedSalesFilter extends _$SelectedSalesFilter {
  @override
  String build() => '30D';

  void setFilter(String filter) {
    state = filter;
  }
}

@riverpod
SalesKpiData currentSalesData(Ref ref) {
  final filter = ref.watch(selectedSalesFilterProvider);
  return _mockSalesData[filter]!;
}
