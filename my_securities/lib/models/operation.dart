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

  double get value => (_type == OperationType.buy ? 1 : -1) * (price * quantity * 10000).roundToDouble() / 10000;

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

  Operation({@required int id, @required Portfolio portfolio, Instrument instrument,
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

  Operation.empty({@required Portfolio portfolio, Instrument instrument}) {
    DateTime now = DateTime.now();

    this._id = null;
    this._portfolio = portfolio;
    this._instrument = instrument;
    this._date = DateTime(now.year, now.month, now.day);
    this._type = OperationType.buy;
    this._quantity = 0;
    this._price = 0;
    this._commission = 0;
  }

  assign(Operation source) {
    this._id = source.id;
    this._portfolio = source._portfolio;
    this._instrument = source._instrument;
    this._date = source.date;
    this._type = source.type;
    this._quantity = source.quantity;
    this._price = source.price;
    this._commission = source.commission;

    notifyListeners();
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

  Future<bool> update ({Instrument instrument, DateTime date, OperationType type,  int quantity,  double price, double commission}) async {
    bool result = true;
    if (Instrument != null)
      _instrument = instrument;
    if (date != null)
      _date = date;
    if (type != null)
      _type = type;
    if (quantity != null)
      _quantity = quantity;
    if (price != null)
      _price = price;
    if (commission != null)
      _commission = commission;

    if (_id != null)
      result = await DBProvider.db.updateOperation(this);
    return Future.value(result);
  }
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

  addOperation (Operation operation, bool createMoneyOperation) {
    DBProvider.db.addOperation(operation, createMoneyOperation);
  }

  deleteOperation(Operation operation) async {
    await DBProvider.db.deleteOperation(operation.id);
  }

}