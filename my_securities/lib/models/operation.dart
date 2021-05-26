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
  DateTime date;
  OperationType type;
  int quantity;
  double price;
  double commission;

  double get value => (type == OperationType.buy ? 1 : -1) * (price * quantity * 10000).roundToDouble() / 10000;

  int get id => _id;
  Portfolio get portfolio => _portfolio;
  Instrument get instrument => _instrument;

  String valueString() => value == null ? '' : formatCurrency(value);

  String priceString() => price == null ? '' : formatCurrency(price);

  Operation({@required int id, @required Portfolio portfolio, Instrument instrument,
      @required DateTime date, @required OperationType type, @required int quantity, @required double price,
      double commission}) :
    _id = id,
    _portfolio = portfolio,
    _instrument = instrument,
    date = date,
    type = type,
    quantity = quantity,
    price = price,
    commission = commission;

  Operation.empty({@required Portfolio portfolio, Instrument instrument}) {
    DateTime now = DateTime.now();

    this._id = null;
    this._portfolio = portfolio;
    this._instrument = instrument;
    this.date = DateTime(now.year, now.month, now.day);
    this.type = OperationType.buy;
    this.quantity = 0;
    this.price = 0;
    this.commission = 0;
  }

  assign(Operation source) {
    this._id = source.id;
    this._portfolio = source._portfolio;
    this._instrument = source._instrument;
    this.date = source.date;
    this.type = source.type;
    this.quantity = source.quantity;
    this.price = source.price;
    this.commission = source.commission;

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
}