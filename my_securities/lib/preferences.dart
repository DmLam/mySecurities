import 'package:flutter/foundation.dart';
import 'package:my_securities/common/types.dart';
import 'package:my_securities/quote_provider.dart';
import 'package:pref/pref.dart';

import 'exchange.dart';

class Preferences extends ChangeNotifier {
  // names for preferences
  static const String prefDARK_THEME = 'dark_theme';
  static const String prefMAIN_CURRENCY_ID = 'main_currency_id';
  static const String prefSHOW_HIDDEN_PORTFOLIOS = 'show_hidden_portfolios';
  static const String prefHIDE_SOLD_INSTRUMENTS = 'hide_sold_instruments';

  static final Map<String, dynamic> DEFAULT_PREFERENCES = {
    prefDARK_THEME: false,
    prefMAIN_CURRENCY_ID: Currency.USD.index,
    prefSHOW_HIDDEN_PORTFOLIOS: false,
    prefHIDE_SOLD_INSTRUMENTS: false
  };


  static PrefServiceShared? _service;
  static Preferences? _preferences;
  late final Future _ready;

  Future get ready => _ready;
  PrefServiceShared get service {
    final service = _service;
    if (service == null)
      throw InternalException("PrefServiceShared is not initialized");

    return service;
  }

  Preferences() {
    if (_service == null)
      _ready = _init();
  }

  factory Preferences.preferences() {
    Preferences result = _preferences ?? Preferences();

    if (_preferences == null)
      _preferences = result;

    return result;
  }

  Future _init() async {
    PrefServiceShared service = await PrefServiceShared.init(
        defaults: DEFAULT_PREFERENCES
    );
    _service = service;
    service.addKeyListener(prefDARK_THEME, () {
      notifyListeners();
    });
    service.addKeyListener(prefMAIN_CURRENCY_ID, () {
      QuoteProvider.mainCurrency = mainCurrency;
      notifyListeners();
    });
    service.addKeyListener(prefSHOW_HIDDEN_PORTFOLIOS, () {
      notifyListeners();
    });
    service.addKeyListener(prefHIDE_SOLD_INSTRUMENTS, () {
      notifyListeners();
    });
  }

  bool get darkTheme {
    bool result = DEFAULT_PREFERENCES[prefDARK_THEME];
    final service = _service;

    if (service != null)
      result = service.sharedPreferences.getBool(prefDARK_THEME) ?? result;

    return result;
  }
  Currency get mainCurrency {
    int id = DEFAULT_PREFERENCES[prefMAIN_CURRENCY_ID];
    final service = _service;

    if (service != null)
      id = service.sharedPreferences.getInt(prefMAIN_CURRENCY_ID) ?? id;

    return Currency.values[id];
  }
  bool get showHiddenPortfolios {
    bool result = DEFAULT_PREFERENCES[prefSHOW_HIDDEN_PORTFOLIOS];
    final service = _service;

    if (service != null)
      result = service.sharedPreferences.getBool(prefSHOW_HIDDEN_PORTFOLIOS) ?? result;

    return result;
  }
  bool get hideSoldInstruments {
    bool result = DEFAULT_PREFERENCES[prefHIDE_SOLD_INSTRUMENTS];
    final service = _service;

    if (service != null)
      result = service.sharedPreferences.getBool(prefHIDE_SOLD_INSTRUMENTS) ?? result;

    return result;
  }
}