import 'package:flutter/foundation.dart';
import 'package:pref/pref.dart';

import 'exchange.dart';

class Preferences extends ChangeNotifier {
  // names for preferences
  static final String prefMAIN_CURRENCY_ID = 'main_currency_id'; // ignore: non_constant_identifier_names
  static final String prefSHOW_HIDDEN_PORTFOLIOS = 'show_hidden_portfolios'; // ignore: non_constant_identifier_names

  static PrefServiceShared _service;
  Future _ready;

  Future get ready => _ready;

  Preferences() {
    if (_service == null)
      _ready = _init();
  }

  Future _init() async {
    _service = await PrefServiceShared.init(
        defaults: {
          prefMAIN_CURRENCY_ID: Currency.USD.index,
          prefSHOW_HIDDEN_PORTFOLIOS: false
        }
    );
  }

  Currency get mainCurrency => Currency.values[_service.sharedPreferences.getInt(prefMAIN_CURRENCY_ID)];
  set mainCurrency(Currency currency) {
    _service.sharedPreferences.setInt(prefMAIN_CURRENCY_ID, currency.index);
    notifyListeners();
  }
  bool get showHiddenPortfolio => _service.sharedPreferences.getBool(prefSHOW_HIDDEN_PORTFOLIOS);
  set showHiddenPortfolio(bool show) {
    _service.sharedPreferences.setBool(prefSHOW_HIDDEN_PORTFOLIOS, show);
    notifyListeners();
  }
}