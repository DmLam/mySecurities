import 'dart:typed_data';

import 'exchange.dart';
import 'models/instrument.dart';
import 'models/quote.dart';
import 'models/rate.dart';
import 'moex_data_provider.dart';

class SearchItem {
  final Exchange exchange;
  final String isin;
  final String ticker;
  final String name;
  final String shortName;
  final InstrumentType type;
  final Currency currency;
  final String additional;

  SearchItem({this.exchange, this.ticker, this.name, this.shortName, this.isin, this.type, this.currency, this.additional});
}

  class TimestampedQuote {
    final double quote;
    final DateTime timestamp;

    TimestampedQuote(this.quote, this.timestamp);
  }

abstract class StockExchangeProvider {
  static StockExchangeProvider _stock;

  StockExchangeProvider();

  factory StockExchangeProvider.stock() {
    if (_stock == null)
      _stock = MOEXDataProvider();

    return _stock;
  }

  Future<List> search({String ticker});
  Future<Uint8List> getInstrumentImage(Instrument instrument);
  Future <List<Quote>> getInstrumentQuotes(String ticker, DateTime from, DateTime to);
  // last quote at previous trade session (yesterday)
  Future<double> getInstrumentLastQuote(String ticker);
  Future<double> getInstrumentPrice(String ticker, {DateTime date});
  String getCurrencyTicker(Currency currency);
  Future<double> getCurrencyRate(Currency from, Currency to, {DateTime datetime});
  Future<List<Rate>> getCurrencyRates(Currency currency, DateTime from, DateTime to);
}

