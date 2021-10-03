import 'package:flutter/foundation.dart';
import 'package:my_securities/quote_provider.dart';
import 'package:pref/pref.dart';

import 'exchange.dart';

class Preferences extends ChangeNotifier {
  // names for preferences
  static final String prefDARK_THEME = 'dark_theme'; // ignore: non_constant_identifier_names
  static final String prefMAIN_CURRENCY_ID = 'main_currency_id'; // ignore: non_constant_identifier_names
  static final String prefSHOW_HIDDEN_PORTFOLIOS = 'show_hidden_portfolios'; // ignore: non_constant_identifier_names
  static final String prefHIDE_SOLD_INSTRUMENTS = 'hide_sold_instruments'; // ignore: non_constant_identifier_names

  static PrefServiceShared _service;
  static Preferences _preferences;
  Future _ready;

  Future get ready => _ready;
  PrefServiceShared get service => _service;

  Preferences() {
    if (_service == null)
      _ready = _init();
  }

  factory Preferences.preferences() {
    if (_preferences == null)
      _preferences = Preferences();

    return _preferences;
  }

  Future _init() async {
    _service = await PrefServiceShared.init(
        defaults: {
          prefDARK_THEME: false,
          prefMAIN_CURRENCY_ID: Currency.USD.index,
          prefSHOW_HIDDEN_PORTFOLIOS: false,
          prefHIDE_SOLD_INSTRUMENTS: false
        }
    );
    _service.addKeyListener(prefDARK_THEME, () {
      notifyListeners();
    });
    _service.addKeyListener(prefMAIN_CURRENCY_ID, () {
      QuoteProvider.mainCurrency = mainCurrency;
      notifyListeners();
    });
    _service.addKeyListener(prefSHOW_HIDDEN_PORTFOLIOS, () {
      notifyListeners();
    });
    _service.addKeyListener(prefHIDE_SOLD_INSTRUMENTS, () {
      notifyListeners();
    });
  }

  bool get darkTheme => _service.sharedPreferences.getBool(prefDARK_THEME);
  Currency get mainCurrency => Currency.values[_service.sharedPreferences.getInt(prefMAIN_CURRENCY_ID)];
  bool get showHiddenPortfolios => _service.sharedPreferences.getBool(prefSHOW_HIDDEN_PORTFOLIOS);
  bool get hideSoldInstruments => _service.sharedPreferences.getBool(prefHIDE_SOLD_INSTRUMENTS);
}