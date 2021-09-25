import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:my_securities/database_list.dart';
import 'package:my_securities/generated/l10n.dart';
import '../exchange.dart';
import '../constants.dart';
import '../database.dart';
import '../stock_exchange_interface.dart';
import 'model.dart';
import 'portfolio.dart';

enum InstrumentType {currency, share, etf, federalBond, subfederalBond, corporateBond, futures, stockIndex, depositaryReceipt}

extension InstrumentTypeExtension on InstrumentType {
  static final List<int> databaseId = [1, 2, 3, 4, 4, 4, 5, 6, 7];

  int get id => databaseId[this.index];

  String get name => INSTRUMENT_TYPE_NAMES[this.index];
}

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

  _initId() async {
    if (id == null)
      id = await DBProvider.db.getInstrumentId(isin);
  }

  Instrument({int id, @required Portfolio portfolio, String isin = '', @required String ticker,
    String name = '', Currency currency, InstrumentType type,
    Exchange exchange = Exchange.MCX, Uint8List image, String additional,
    int portfolioPercentPlan, int quantity = 0,
    double averagePrice = 0.0, double value = 0.0, int operationCount = 0}):
    assert(portfolio != null),
    _portfolio = portfolio,
    this.id = id,
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
    _operationCount = operationCount
  {
    _initId();
  }

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
      Instrument(
          id: json["id"],
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

  double profit(double currentPrice) => (quantity ?? 0) == 0 ? 0 : quantity * (currentPrice - averagePrice);

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

  Future<int> add() async {
    assert(id == null, 'instrument already added to db (id = $id)');
    id = await DBProvider.db.getInstrumentId(isin);

    if (id == null)
      id = await DBProvider.db.addInstrument(
          ticker, isin, name, currency, type, exchange, additional);

    return Future.value(id);
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

class InstrumentList extends DatabaseList<Instrument> {

  InstrumentList(Portfolio portfolio) : super(portfolio);

  refresh() async {
    await loadFromDb();
  }

  Instrument byId(int id) {
    Instrument result;

    for(Instrument instrument in items) {
      if (instrument.id == id) {
        result = instrument;
        break;
      }
    }

    return result;
  }

  Instrument byTicker(String ticker) {
    Instrument result;

    for(Instrument instrument in items) {
      if (instrument.ticker == ticker) {
        result = instrument;
        break;
      }
    }

    return result;
  }

  loadFromDb() async {
    items = await DBProvider.db.getPortfolioInstruments(portfolio.id);
  }
}