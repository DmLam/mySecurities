import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:my_securities/generated/l10n.dart';
import 'package:my_securities/exchange.dart';
import 'package:my_securities/models/portfolio.dart';

import '../database.dart';
import '../stock_exchange_interface.dart';

enum InstrumentType {currency, share, etf, federalBond, subfederalBond, corporateBond, futures, stockIndex}

class Instrument extends ChangeNotifier{
  int _id;
  String _isin;
  String _ticker;
  String _name;
  InstrumentType _type;
  Exchange _exchange;
  Currency _currency;
  Uint8List _image;
  String _additional;
  int _portfolioPercentPlan;
  int _quantity;
  double _averagePrice;
  double _value;
  int _operationCount;

  int get id => _id;
  String get isin => _isin;
  String get ticker => _ticker;
  String get name => _name;
  Currency get currency => _currency;
  InstrumentType get type => _type;
  Exchange get exchange => _exchange;
  Uint8List get image {
    if (_image == null)
      _loadImage();

    return _image;
  }

  String get additional => _additional;
  int get portfolioPercentPlan => _portfolioPercentPlan;
  int get quantity => _quantity;
  double get averagePrice => _averagePrice;
  double get value => _value;
  int get operationCount => _operationCount;

  Instrument(this._id, {isin = '', @required ticker, name = '', currency, type,
    exchange = Exchange.MCX, image, additional, portfolioPercentPlan, quantity = 0,
    averagePrice = 0, value = 0, operationCount = 0}):
    _isin = isin,
    _ticker = ticker,
    _name = name,
    _currency = currency,
    _type = type,
    _exchange = exchange,
    _image = image,
    _additional = additional,
    _portfolioPercentPlan = portfolioPercentPlan,
    _quantity = quantity,
    _averagePrice = averagePrice,
    _value = value,
    _operationCount = operationCount;

  Instrument.from(Instrument source):
    this._id = source._id,
    this._isin = source._isin,
    this._ticker = source._ticker,
    this._name = source._name,
    this._currency = source._currency,
    this._type = source._type,
    this._image = source._image,
    this._additional = source._additional,
    this._exchange = source._exchange,
    this._portfolioPercentPlan = source._portfolioPercentPlan,
    this._quantity = source._quantity,
    this._averagePrice = source._averagePrice,
    this._value = source._value,
    this._operationCount = source._operationCount;

  Instrument.empty():
    this._id = null,
    this._exchange = Exchange.MCX,
    this._quantity = 0,
    this._averagePrice = 0,
    this._value = 0,
    this._operationCount = 0;


  factory Instrument.fromMap(Map<String, dynamic> json) =>
      Instrument(json["id"],
          isin: json["isin"],
          ticker: json["ticker"],
          name: json["name"],
          currency: Currency.values[json["currency_id"] - 1],
          type: InstrumentType.values[json["instrument_type_id"] - 1],
          exchange: Exchange.values[json["exchange_id"] - 1],
          image: json['image'],
          additional: json['additional'],
          portfolioPercentPlan: json['portfolio_percent_plan'],
          quantity: json["quantity"],
          averagePrice: json["avgprice"],
          value: json["value"],
          operationCount: json["operation_count"]);

  double currentValue() => quantity == null ? 0 : quantity * averagePrice;

  double profit(double currentPrice) => quantity == null ? 0 : quantity * (currentPrice - averagePrice);

  String profitString(double currentPrice, {Currency currency}) => (profit(currentPrice) == 0) ? '' : formatCurrency(profit(currentPrice), currency: currency == null ? this.currency : currency);

  Map<String, dynamic> toMap() => {
    "id": _id,
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

  Instrument assign(Instrument source) {
    this._id = source.id;
    this._isin = source.isin;
    this._ticker = source.ticker;
    this._name = source.name;
    this._currency = source.currency;
    this._type = source.type;
    this._exchange = source.exchange;
    this._image = Uint8List.fromList(source.image);
    this._additional = source.additional;
    this._portfolioPercentPlan = source.portfolioPercentPlan;
    this._quantity = source.quantity;
    this._averagePrice = source.averagePrice;
    this._value = source.value;
    this._operationCount = source.operationCount;

    return source;
  }

  _loadImage() async {
    Uint8List newImage = await StockExchangeProvider.stock().getInstrumentImage(this);
    // comparing lengths is the dirty way to check that image had been changed
    if ((_image == null && newImage != null) || (newImage?.length != _image?.length) ) {
      _image = newImage;
      DBProvider.db.setInstrumentImage(_id, _image);
      notifyListeners();
    }
  }
}

extension InstrumentExtension on Instrument {

  String valueString({Currency currency}) => value == null ? '' : formatCurrency(value, currency: currency == null ? this.currency : currency);

  String quantityString() => quantity == null ? '' : quantity.toString() + ' ' + S.current.pcs;

  String averagePriceString({Currency currency}) => averagePrice == null ? '' : formatCurrency(averagePrice, currency: currency == null ? this.currency : currency) ;
}

class InstrumentList extends ChangeNotifier {
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
}