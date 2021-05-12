import 'package:flutter/foundation.dart';
import 'package:pref/pref.dart';

import 'exchange.dart';

class Preferences extends ChangeNotifier {
  // names for preferences
  static final String _pref_MAIN_CURRENCY_ID = 'main_currency_id'; // ignore: non_constant_identifier_names
  static final String _pref_SHOW_HIDDEN_PORTFOLIOS = 'show_hidden_portfolios'; // ignore: non_constant_identifier_names

  static PrefServiceShared _service;

  Preferences() {
    if (_service == null)
      _initService();
  }

  _initService() async {
    _service = await PrefServiceShared.init(
        defaults: {
          _pref_MAIN_CURRENCY_ID: Currency.USD.index,
          _pref_SHOW_HIDDEN_PORTFOLIOS: false
        }
    );
  }

  Currency get mainCurrency => Currency.values[_service.sharedPreferences.getInt(_pref_MAIN_CURRENCY_ID)];
  set mainCurrency(Currency currency) {
    _service.sharedPreferences.setInt(_pref_MAIN_CURRENCY_ID, currency.index);
    notifyListeners();
  }
  bool get showHiddenPortfolio => _service.sharedPreferences.getBool(_pref_SHOW_HIDDEN_PORTFOLIOS);
  set showHiddenPortfolio(bool show) {
    _service.sharedPreferences.setBool(_pref_SHOW_HIDDEN_PORTFOLIOS, show);
    notifyListeners();
  }
}