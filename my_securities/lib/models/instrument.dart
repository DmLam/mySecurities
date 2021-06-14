import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:my_securities/generated/l10n.dart';
import 'package:my_securities/exchange.dart';
import 'package:my_securities/models/portfolio.dart';

import '../database.dart';
import '../stock_exchange_interface.dart';
import 'model.dart';

enum InstrumentType {currency, share, etf, federalBond, subfederalBond, corporateBond, futures, stockIndex}

class Instrument extends ChangeNotifier {
  int id;
  Portfolio _portfolio;
  String isin;
  String ticker;
  String name;
  InstrumentType type;
  Exchange exchange;
  Currency currency;
  Uint8List _image;
  String additional;
  int portfolioPercentPlan;
  int quantity;
  double _averagePrice;
  double _value;
  int _operationCount;

  Portfolio get portfolio => _portfolio;
  Uint8List get image {
    if (_image == null)
      _loadImage();

    return _image;
  }
  double get averagePrice => _averagePrice;
  double get value => _value;
  int get operationCount => _operationCount;

  Instrument(this.id, {@required Portfolio portfolio, isin = '', @required ticker, name = '', currency, type,
    exchange = Exchange.MCX, image, additional, portfolioPercentPlan, quantity = 0,
    averagePrice = 0, value = 0, operationCount = 0}):
    assert(portfolio != null),
    _portfolio = portfolio,
    this.isin = isin,
    this.ticker = ticker,
    this.name = name,
    this.currency = currency,
    this.type = type,
    this.exchange = exchange,
    this.additional = additional,
    this.portfolioPercentPlan = portfolioPercentPlan,
    this.quantity = quantity,
    _image = image,
    _averagePrice = averagePrice,
    _value = value,
    _operationCount = operationCount;

  Instrument.from(Instrument source):
    id = source.id,
    _portfolio = source._portfolio,
    isin = source.isin,
    ticker = source.ticker,
    name = source.name,
    currency = source.currency,
    type = source.type,
    _image = source._image,
    additional = source.additional,
    exchange = source.exchange,
    portfolioPercentPlan = source.portfolioPercentPlan,
    quantity = source.quantity,
    _averagePrice = source._averagePrice,
    _value = source._value,
    _operationCount = source._operationCount;

  Instrument.empty():
    id = null,
    exchange = Exchange.MCX,
    quantity = 0,
    _averagePrice = 0,
    _value = 0,
    _operationCount = 0;


  factory Instrument.fromMap(Map<String, dynamic> json) =>
      Instrument(json["id"],
          portfolio: Model.portfolios.portfolioById(json["portfolio_id"]),
          isin: json["isin"],
          ticker: json["ticker"],
          name: json["name"],
          currency: Currency.values[json["currency_id"] - 1],
          type: InstrumentType.values[json["instrument_type_id"] - 1],
          exchange: Exchange.values[json["exchange_id"] - 1],
          image: json['image'],
          additional: json['additional'],
          portfolioPercentPlan: json['percent'],
          quantity: json["quantity"],
          averagePrice: json["avgprice"],
          value: json["value"],
          operationCount: json["operation_count"]);

  double currentValue() => quantity == null ? 0 : quantity * averagePrice;

  double profit(double currentPrice) => quantity == null ? 0 : quantity * (currentPrice - averagePrice);

  String profitString(double currentPrice, {Currency currency}) => (profit(currentPrice) == 0) ? '' : formatCurrency(profit(currentPrice), currency: currency == null ? this.currency : currency);

  Map<String, dynamic> toMap() => {
    "id": id,
    "isin": isin,
    "ticker": ticker,
    "name": name,
    "currency_id": currency.index + 1,
    "instrument_type_id": type.index + 1,
    "exchange_id": exchange.index + 1,
    "image": image,
    "additional": additional,
    "portfolio_percent_plan": portfolioPercentPlan,
    "quantity": quantity,
    "avgprice": averagePrice,
    "value": value,
    "operation_count": operationCount
  };

  assign(Instrument source) {
    id = source.id;
    _portfolio = source._portfolio;
    isin = source.isin;
    ticker = source.ticker;
    name = source.name;
    currency = source.currency;
    type = source.type;
    exchange = source.exchange;
    _image = Uint8List.fromList(source.image);
    additional = source.additional;
    portfolioPercentPlan = source.portfolioPercentPlan;
    quantity = source.quantity;
    _averagePrice = source.averagePrice;
    _value = source.value;
    _operationCount = source.operationCount;
  }

  _loadImage() async {
    Uint8List newImage = await StockExchangeProvider.stock().getInstrumentImage(this);
    // comparing lengths is the dirty way to check that image had been changed
    if ((_image == null && newImage != null) || (newImage?.length != _image?.length) ) {
      _image = newImage;
      DBProvider.db.setInstrumentImage(id, _image);
      notifyListeners();
    }
  }

  Future<bool> update({int portfolioPercentPlan}) async {
    if (portfolioPercentPlan != null)
      portfolioPercentPlan = portfolioPercentPlan;

    bool result = await DBProvider.db.updateInstrument(this);

    notifyListeners();

    return Future.value(result);
  }
}

extension InstrumentExtension on Instrument {

  String valueString({Currency currency}) => value == null ? '' : formatCurrency(value, currency: currency == null ? this.currency : currency);

  String quantityString() => quantity == null ? '' : quantity.toString() + ' ' + S.current.pcs;

  String averagePriceString({Currency currency}) => averagePrice == null ? '' : formatCurrency(averagePrice, currency: currency == null ? this.currency : currency) ;
}

class InstrumentList {
  final Portfolio _portfolio;
  List<Instrument> _items = [];

  InstrumentList(this._portfolio) {
    _loadFromDb();
  }

  Portfolio get portfolio => _portfolio;

  List<Instrument> get instruments => [..._items];

  Instrument instrumentById(int id) {
    Instrument result;
    for(Instrument instrument in _items) {
      if (instrument.id == id) {
        result = instrument;
        break;
      }
    }

    return result;
  }

  _loadFromDb() async {
    _items = await DBProvider.db.getPortfolioInstruments(_portfolio.id);
  }

  Future<Instrument> add(String ticker, String isin, String name, Currency currency, InstrumentType type, Exchange exchange, String additional) async {
    int id = await DBProvider.db.getInstrumentId(isin);

    if (id == null)
      id = await DBProvider.db.addInstrument(ticker, isin, name, currency, type, exchange, additional);

    Instrument result = Instrument(id, portfolio: _portfolio, ticker: ticker, isin: isin, name: name,
        currency: currency, type: type, exchange: exchange, additional: additional);

    portfolio.update(); // notifing the portfolio listeners

    return Future.value(result);
  }
}