import 'package:my_securities/preferences.dart';
import 'package:my_securities/stock_exchange_interface.dart';

import 'common/utils.dart';
import 'constants.dart';
import 'database.dart';
import 'exchange.dart';
import 'models/instrument.dart';
import 'models/quote.dart';
import 'models/rate.dart';


class _CachedPrice {
  final double _price;
  final DateTime _cacheDateTime;

  _CachedPrice(this._price, this._cacheDateTime);
}

class QuoteProvider {
  Instrument _instrument;
  DateTime lastQuoteUpdate;
  static Currency _mainCurrency;

  static get mainCurrency  {return _mainCurrency;}
  static set mainCurrency(Currency currency) => _setMainCurrency(currency);

  static final Map<int, QuoteProvider> _providers = Map<int, QuoteProvider>();
  final Map<String, _CachedPrice> _priceCache = Map<String, _CachedPrice>();
  final Map<String, _CachedPrice> _rateCache = Map<String, _CachedPrice>();

  static _setMainCurrency(Currency currency) async {
    if (currency == null)
      currency = Preferences.preferences().mainCurrency;

    _mainCurrency = currency;
    for (QuoteProvider provider in _providers.values)
      provider._clearPriceCache();
  }

  void _clearPriceCache() {
    _priceCache.clear();
  }

  Currency getCurrency() => _mainCurrency == null ? _instrument.currency : _mainCurrency;

  // todo: сделать кэширование курсов (аналогично кэшированию текущей цены инструмента)
  Future<double> getCurrencyRate(Currency from, Currency to, {DateTime datetime}) async {
    return StockExchangeProvider.stock().getCurrencyRate(from, to, datetime: datetime);
  }

  Future<double> currencyRate(Currency from, Currency to, DateTime datetime) async {
    double result;
    String cacheKey = from.name + to.name;

    if (_rateCache.containsKey(cacheKey)) {
      _CachedPrice r = _rateCache[cacheKey];
      if (DateTime.now().difference(r._cacheDateTime).inSeconds < CURRENT_PRICE_CACHE_TIME)
        result = r._price;
    }
    if (result == null) {
      result = await StockExchangeProvider.stock().getCurrencyRate(from, to, datetime: datetime);
      if (result != null)
        _rateCache[cacheKey] = _CachedPrice(result, DateTime.now());
      else {
        // Если не смогли получить текущие котировки (биржа закрыта etc.), то возьмем последние из базы,
        // но тогда не будем из кэшировать
        _rateCache.remove(cacheKey);
        // todo: получить последнюю котировку из базы
      }
    }

    return Future.value(result);
  }

  Future<double> convert(double value, Currency from, Currency to, {DateTime datetime}) async {
    double result = value;

    if (to != null) {
      double rate = await currencyRate(from, to, datetime);
      result = result / rate;
    }

    return Future.value(result);
  }

  Future<double> _toMainCurrency(double value, Currency currency) async {
    double result = value;
    if (_mainCurrency != null) {
      result = await convert(result, currency, _mainCurrency);
    }

    return Future.value(result);
  }

  _getLastQuoteUpdate() async {
    lastQuoteUpdate = await DBProvider.db.instrumentLastQuoteUpdate(_instrument.id);
  }

  QuoteProvider(Instrument instrument) {
    _instrument = Instrument.from(instrument);
    _getLastQuoteUpdate();
  }

  factory QuoteProvider.of(Instrument instrument) {
    QuoteProvider result = _providers[instrument.id];

    if (result == null) {
      result = QuoteProvider(instrument);
      _providers[instrument.id] = result;
    }

    return result;
  }

  // возвращает true если какие-то котировки добавлены в базу, иначе false
  Future<bool> _updateQuotes() async {
    bool result = false;
    DateTime today = currentDate();

    if (lastQuoteUpdate == null || lastQuoteUpdate.isBefore(today)) {
      // Если котировки по инструменту начинаются позже, чем дата первой операции по инструменту - загрузим котировки
      DateTime firstOperationDate = await DBProvider.db.instrumentFirstOperationDate(_instrument.id);
      if (firstOperationDate != null) {
        DateTime firstQuoteDate = await DBProvider.db.instrumentFirstQuoteDate(_instrument.id);

        if (firstQuoteDate == null)
          firstQuoteDate = today;
        if (firstQuoteDate.isAfter(firstOperationDate)) {
          List<Quote> quotes = await StockExchangeProvider.stock().getInstrumentQuotes(_instrument.ticker, firstOperationDate, firstQuoteDate);

          if (quotes.length > 0) {
            await DBProvider.db.addQuotes(_instrument.id, quotes);
            result = true;
          }
        }
      }

      // если котировки инструмента не обновлялись сегодня - обновим
      DateTime lastQuoteDate = await DBProvider.db.instrumentLastQuoteUpdate(_instrument.id);
      if (lastQuoteDate == null || lastQuoteDate.isBefore(today)) {
        DateTime from = (lastQuoteUpdate ?? today).add(Duration(days: -1)) ;
        List<Quote> quotes = await StockExchangeProvider.stock().getInstrumentQuotes(_instrument.ticker, from, today);

        if (quotes.length > 0) {
          await DBProvider.db.addQuotes(_instrument.id, quotes);
          result = true;
        }
      }
    }

    lastQuoteUpdate = today;
    await DBProvider.db.updateInstrumentLastQuoteDate(_instrument.id, lastQuoteUpdate);

    return Future.value(result);
  }

  // возвращает true если какие-то курсы добавлены в базу, иначе false
 static Future<bool> updateRates() async {
    bool result = false;
    DateTime today = currentDate();
    DateTime lastRateUpdate = await DBProvider.db.lastRateUpdate();

    if (lastRateUpdate == null || lastRateUpdate.isBefore(today.add(Duration(days: -1)))) {

      DateTime from = lastRateUpdate == null ? today.add(Duration(days: -1)) : lastRateUpdate.add(Duration(days: 1));
      List<Rate> rates = await StockExchangeProvider.stock().getCurrencyRates(Currency.USD, from, today);

      rates.addAll(await StockExchangeProvider.stock().getCurrencyRates(Currency.EUR, from, today));

      if (rates.length > 0) {
        await DBProvider.db.addRates(rates);
        result = true;
      }
    }

    lastRateUpdate = today;

    return Future.value(result);
  }

  Future<Quote> getLastQuote({bool inMainCurrency = false}) async {
    Quote result;

    double q = await StockExchangeProvider.stock().getInstrumentLastQuote(_instrument.ticker);
    if (inMainCurrency) {
      q = await _toMainCurrency(q, _instrument.currency);
    }
    result = Quote(date: currentDate(), open: q, low: q, high: q, close: q);

    return Future.value(result);
  }

  Future<double> getCurrentPrice({bool inMainCurrency = false}) async {
    double result;

    if (_priceCache.containsKey(_instrument.ticker)) {
      _CachedPrice q = _priceCache[_instrument.ticker];
      if (DateTime.now().difference(q._cacheDateTime).inSeconds < CURRENT_PRICE_CACHE_TIME)
        result = q._price;
    }
    if (result == null) { // there is no price in cache
      result = await StockExchangeProvider.stock().getInstrumentCurrentPrice(_instrument.ticker);

      if (result == null) { // impossible to receive current price (may be exchange is not working now
        Quote q = await DBProvider.db.instrumentLastQuote(_instrument.id);
        if (q != null)
          result = q.close;
      }
      if (result != null) {
        _priceCache[_instrument.ticker] = _CachedPrice(result, DateTime.now());
      }
    }
    if (result != null && inMainCurrency) {
      result = await _toMainCurrency(result, _instrument.currency);
    }

    return Future.value(result);
  }

  static updateInstrumentsQuote() async {
    List<Instrument> instruments = await DBProvider.db.getInstruments();

    if (instruments != null) {
      for (var instrument in instruments) {
        QuoteProvider(instrument)._updateQuotes();
      }
    }
  }
}