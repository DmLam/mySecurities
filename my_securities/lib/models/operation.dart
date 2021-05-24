import 'package:flutter/material.dart';
import 'package:my_securities/exchange.dart';
import 'package:my_securities/models/portfolio.dart';
import '../database.dart';
import 'instrument.dart';
import 'model.dart';

enum OperationType {buy, sell}

class Operation extends ChangeNotifier{
  int _id;
  Portfolio _portfolio;
  Instrument _instrument;
  DateTime _date;
  OperationType _type;
  int _quantity;
  double _price;
  double _commission;

  double get value => (_type == OperationType.buy ? 1 : -1) * (_price * _quantity * 10000).roundToDouble() / 10000;

  int get id => _id;
  Portfolio get portfolio => _portfolio;
  Instrument get instrument => _instrument;
  DateTime get date => _date;
  OperationType get type => _type;
  int get quantity => _quantity;
  double get price => _price;
  double get commission => _commission;

  String valueString() => value == null ? '' : formatCurrency(value);

  String priceString() => _price == null ? '' : formatCurrency(_price);

  Operation({@required int id, @required Portfolio portfolio, @required Instrument instrument,
      @required DateTime date, @required OperationType type, @required int quantity, @required double price,
      double commission}) :
    _id = id,
    _portfolio = portfolio,
    _instrument = instrument,
    _date = date,
    _type = type,
    _quantity = quantity,
    _price = price,
    _commission = commission;

  Operation.empty() {
    DateTime now = DateTime.now();

    this._id = null;
    this._portfolio = null;
    this._instrument = null;
    this._date = DateTime(now.year, now.month, now.day);
    this._type = OperationType.buy;
    this._quantity = 0;
    this._price = 0;
    this._commission = 0;
  }

  factory Operation.fromMap(Map<String, dynamic> json) =>
      Operation(id: json["id"],
          portfolio: Model.portfolios().portfolioById(json["portfolio_id"]),
          instrument: Model.portfolios().portfolioById(json["portfolio_id"]).instrumentById(json["instrument_id"]),
          date: DateTime.parse(json["date"]),
          type: OperationType.values[json["type"]],
          quantity: json["quantity"],
          price: json["price"],
          commission: json["commission"]
      );
}

class OperationList extends ChangeNotifier {
  List<Operation> _items = [];
  Portfolio _portfolio;

  OperationList(this._portfolio) {
    _loadFromDb();
  }

  List<Operation> get operations => [..._items];

  _loadFromDb() async {
    _items = await DBProvider.db.getPortfolioOperations(_portfolio.id);
  }
}