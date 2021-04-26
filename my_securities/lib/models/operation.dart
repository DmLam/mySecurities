import 'package:flutter/cupertino.dart';
import 'package:my_securities/common/exchange.dart';

import '../common/database.dart';

enum OperationType {buy, sell}

class Operation{
  int id;
  int portfolioInstrumentId;
  int instrumentId;
  DateTime date;
  OperationType type;
  int quantity;
  double price;
  double commission;

  double get value => (type == OperationType.buy ? 1 : -1) * (price * quantity * 10000).roundToDouble() / 10000;

  String valueString() => value == null ? '' : formatCurrency(value);

  String priceString() => price == null ? '' : formatCurrency(price);

  Operation({this.id, this.portfolioInstrumentId, this.instrumentId, this.date, this.type, this.quantity, this.price, this.commission});

  Operation.from(Operation op) :
        this.id = op.id,
        this.portfolioInstrumentId = op.portfolioInstrumentId,
        this.instrumentId = op.instrumentId,
        this.date = op.date,
        this.type = op.type,
        this.quantity = op.quantity,
        this.price = op.price,
        this.commission = op.commission;

  Operation.empty() {
    DateTime now = DateTime.now();

    this.id = null;
    this.portfolioInstrumentId = null;
    this.instrumentId = null;
    this.date = DateTime(now.year, now.month, now.day);
    this.type = OperationType.buy;
    this.quantity = 0;
    this.price = 0;
    this.commission = 0;
  }

  factory Operation.fromMap(Map<String, dynamic> json) =>
      Operation(id: json["id"],
          portfolioInstrumentId: json["portfolio_instrument_id"],
          instrumentId: json["instrument_id"],
          date: DateTime.parse(json["date"]),
          type: OperationType.values[json["type"]],
          quantity: json["quantity"],
          price: json["price"],
          commission: json["commission"]
      );

  Operation assign(Operation op) {
    id = op.id;
    portfolioInstrumentId = op.portfolioInstrumentId;
    instrumentId = op.instrumentId;
    date = op.date;
    type = op.type;
    quantity = op.quantity;
    price = op.price;
    commission= op.commission;

    return op;
  }
}

class OperationList extends ChangeNotifier {
  List<Operation> _items = [];
  int _portfolioId;

  OperationList(this._portfolioId) {
    _loadFromDb();
  }

  int get length => _items.length;

  Operation operator [](int index) => _items[index];

  _loadFromDb() async {
    _items = await DBProvider.db.getPortfolioOperations(_portfolioId);
//    notifyListeners();
  }
}