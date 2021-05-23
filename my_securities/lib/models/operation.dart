import 'package:flutter/material.dart';
import 'package:my_securities/exchange.dart';
import 'package:my_securities/models/portfolio.dart';
import '../database.dart';
import 'instrument.dart';

enum OperationType {buy, sell}

class Operation extends ChangeNotifier{
  Portfolio _portfolio;
  Instrument _instrument;
  int id;
  int _portfolioId;
  int _instrumentId;
  DateTime date;
  OperationType type;
  int quantity;
  double price;
  double commission;

  double get value => (type == OperationType.buy ? 1 : -1) * (price * quantity * 10000).roundToDouble() / 10000;

  Portfolio get portfolio => _portfolio;
  Instrument get instrument => _instrument;

  String valueString() => value == null ? '' : formatCurrency(value);

  String priceString() => price == null ? '' : formatCurrency(price);

  Operation({this.id, int instrumentId, this.date, this.type, this.quantity, this.price, this.commission}){
    _instrumentId = instrumentId;
  }

  Operation.empty() {
    DateTime now = DateTime.now();

    this.id = null;
    this._instrumentId = null;
    this.date = DateTime(now.year, now.month, now.day);
    this.type = OperationType.buy;
    this.quantity = 0;
    this.price = 0;
    this.commission = 0;
  }

  factory Operation.fromMap(Map<String, dynamic> json) =>
      Operation(id: json["id"],
          instrumentId: json["instrument_id"],
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
    _items.forEach((item) {
      item._portfolio = _portfolio;
      item._instrument = item._portfolio.instruments.instrumentById(item._instrumentId);
    });
  }
}