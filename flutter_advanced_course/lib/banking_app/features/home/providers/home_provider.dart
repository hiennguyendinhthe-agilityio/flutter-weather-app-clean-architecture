import 'package:flutter/foundation.dart';
import 'package:flutter_advanced_course/banking_app/features/home/models/account_model.dart';

enum HomeStatus { initial, loading, loaded, error }

class HomeProvider extends ChangeNotifier {
  HomeStatus _status = HomeStatus.initial;
  AccountModel? _account;

  HomeStatus get status => _status;
  AccountModel? get account => _account;
  bool get isLoading => _status == HomeStatus.loading;
  bool get hasData => _status == HomeStatus.loaded;

  Future<void> loadAccount() async {
    if (_status == HomeStatus.loading) return;
    _status = HomeStatus.loading;
    notifyListeners();

    // Mock API delay
    await Future.delayed(const Duration(milliseconds: 600));

    _account = AccountModel.mock();
    _status = HomeStatus.loaded;
    notifyListeners();
  }
}
