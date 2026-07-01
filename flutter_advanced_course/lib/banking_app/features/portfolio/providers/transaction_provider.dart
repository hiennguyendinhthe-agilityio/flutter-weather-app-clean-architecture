import 'package:flutter/foundation.dart';
import 'package:flutter_advanced_course/banking_app/core/utils/formatters.dart';
import 'package:flutter_advanced_course/banking_app/features/portfolio/models/transaction_model.dart';

enum TxStatus { initial, loading, loaded, error }

class TransactionProvider extends ChangeNotifier {
  TxStatus _status = TxStatus.initial;
  List<TransactionModel> _all = [];
  String _filter = 'All';

  TxStatus get status => _status;
  bool get isLoading => _status == TxStatus.loading;

  final List<String> filters = ['All', 'Income', 'Expense', 'Transfer'];

  String get selectedFilter => _filter;

  List<TransactionModel> get transactions {
    switch (_filter) {
      case 'Income':
        return _all.where((t) => t.txType == TxType.income).toList();
      case 'Expense':
        return _all.where((t) => t.txType == TxType.expense).toList();
      case 'Transfer':
        return _all.where((t) => t.txType == TxType.transfer).toList();
      default:
        return _all;
    }
  }

  /// Group transactions by date label for section headers
  Map<String, List<TransactionModel>> get grouped {
    final map = <String, List<TransactionModel>>{};
    for (final tx in transactions) {
      final key = AppFormatters.formatDateGroup(tx.date);
      (map[key] ??= []).add(tx);
    }
    return map;
  }

  Future<void> loadTransactions(String userId) async {
    if (_status == TxStatus.loading) return;
    _status = TxStatus.loading;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    _all = TransactionModel.mockData();
    _status = TxStatus.loaded;
    notifyListeners();
  }

  void setFilter(String filter) {
    if (_filter == filter) return;
    _filter = filter;
    notifyListeners();
  }
}
