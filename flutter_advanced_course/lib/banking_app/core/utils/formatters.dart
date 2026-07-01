import 'package:intl/intl.dart';

class AppFormatters {
  AppFormatters._();

  static final _currency = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 2,
  );

  static final _shortCurrency = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 0,
  );

  static final _date = DateFormat('MMM dd, yyyy');
  static final _time = DateFormat('hh:mm a');

  static String formatCurrency(double amount) => _currency.format(amount);

  static String formatCurrencyShort(double amount) =>
      _shortCurrency.format(amount);

  static String formatDate(DateTime date) => _date.format(date);

  static String formatTime(DateTime date) => _time.format(date);

  static String formatDateGroup(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return _date.format(date);
  }

  /// Adds thousands separators to number string
  static String addCommas(String number) {
    return number.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
  }
}
